{******************************************************************************}
{                                                                              }
{           Delphi-WebMocks                                                    }
{                                                                              }
{           Copyright (c) 2019 Richard Hatherall                               }
{                                                                              }
{           richard@appercept.com                                              }
{           https://appercept.com                                              }
{                                                                              }
{******************************************************************************}
{                                                                              }
{   Licensed under the Apache License, Version 2.0 (the "License");            }
{   you may not use this file except in compliance with the License.           }
{   You may obtain a copy of the License at                                    }
{                                                                              }
{       http://www.apache.org/licenses/LICENSE-2.0                             }
{                                                                              }
{   Unless required by applicable law or agreed to in writing, software        }
{   distributed under the License is distributed on an "AS IS" BASIS,          }
{   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   }
{   See the License for the specific language governing permissions and        }
{   limitations under the License.                                             }
{                                                                              }
{******************************************************************************}

unit WebMock.Matching.Tests;

interface

uses
  DUnitX.TestFramework,
  System.Classes, System.SysUtils,
  WebMock;

type
  [TestFixture]
  TWebMockMatchingTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    [TestCase('Exact Match', 'GET,/,')]
    [TestCase('Wildcard Method Match', '*,/,')]
    [TestCase('Wildcard URI Match', 'GET,*,anypath')]
    procedure RequestWithMethodAndStringPath_Matching_RespondsOK(const AMatcherMethod, AMatcherURI, ARequestURI: string);
    [Test]
    [TestCase('No Match', 'POST,/pathA,pathB')]
    [TestCase('Wildcard Method Not Matching URI', '*,/pathA,pathB')]
    [TestCase('Wildcard URI Not Matching Method', 'POST,*,')]
    procedure StubWithMethodAndStringURI_NotMatching_RespondsNotImplemented(const AMatcherMethod, AMatcherURI, ARequestURI: string);
    [Test]
    [TestCase('Exact Match', 'GET,^/path$,path')]
    [TestCase('Resource by ID', 'GET,^/resource/\d+$,resource/123')]
    procedure RequestWithMethodAndRegExPath_Matching_RespondsOK(const AMatcherMethod, AMatcherURIPattern, ARequestURI: string);
    [Test]
    [TestCase('No Simple Match', 'GET,^/path$,other_path')]
    [TestCase('No Resource by ID', 'GET,^/resource/\d+$,resource/abc')]
    procedure RequestWithMethodAndRegExPath_NotMatching_RespondsNotImplemented(const AMatcherMethod, AMatcherURIPattern, ARequestURI: string);
    [Test]
    procedure Request_MatchingSingleHeader_RespondsOK;
    [Test]
    procedure Request_NotMatchingSingleHeader_RespondsNotImplemented;
    [Test]
    procedure Request_MatchingMultipleHeaders_RespondsOK;
    [Test]
    procedure Request_PartiallyMatchingMultipleHeaders_RespondsNotImplemented;
    [Test]
    procedure Request_MatchingMultipleHeadersStringList_RespondsOK;
    [Test]
    procedure Request_MatchingSingleHeaderByRegEx_RespondsOK;
    [Test]
    procedure Request_NotMatchingSingleHeaderByRegEx_RespondsNotImplemented;
  end;

implementation

uses
  System.Net.HttpClient, System.Net.URLClient, System.RegularExpressions,
  System.StrUtils,
  TestHelpers,
  WebMock.RequestStub,
  WebMock.ResponseStatus;

procedure TWebMockMatchingTests.Request_MatchingMultipleHeadersStringList_RespondsOK;
var
  LMatcherHeaders: TStringList;
  LHeaders: TNetHeaders;
  LResponse: IHTTPResponse;
begin
  LHeaders := TNetHeaders.Create(
    TNetHeader.Create('Header1', 'Value1'),
    TNetHeader.Create('Header2', 'Value2')
  );
  LMatcherHeaders := TStringList.Create;
  LMatcherHeaders.Values['Header1'] := 'Value1';
  LMatcherHeaders.Values['Header2'] := 'Value2';

  WebMock.StubRequest('*', '*').WithHeaders(LMatcherHeaders);
  LResponse := WebClient.Get(WebMock.BaseURL, nil, LHeaders);

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TWebMockMatchingTests.Request_MatchingMultipleHeaders_RespondsOK;
var
  LHeaderName1, LHeaderValue1, LHeaderName2, LHeaderValue2: string;
  LHeaders: TNetHeaders;
  LResponse: IHTTPResponse;
begin
  LHeaderName1 := 'Header1';
  LHeaderValue1 := 'Value1';
  LHeaderName2 := 'Header2';
  LHeaderValue2 := 'Value2';
  LHeaders := TNetHeaders.Create(
    TNetHeader.Create(LHeaderName1, LHeaderValue1),
    TNetHeader.Create(LHeaderName2, LHeaderValue2)
  );

  WebMock.StubRequest('*', '*')
    .WithHeader(LHeaderName1, LHeaderValue1)
    .WithHeader(LHeaderName2, LHeaderValue2);
  LResponse := WebClient.Get(WebMock.BaseURL, nil, LHeaders);

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TWebMockMatchingTests.Request_MatchingSingleHeaderByRegEx_RespondsOK;
var
  LHeaderName: string;
  LHeaders: TNetHeaders;
  LResponse: IHTTPResponse;
begin
  LHeaderName := 'Accept';
  LHeaders := TNetHeaders.Create(
    TNetHeader.Create(LHeaderName, 'text/plain')
  );

  WebMock.StubRequest('*', '*')
    .WithHeader(LHeaderName, TRegEx.Create('text/.+'));
  LResponse := WebClient.Get(WebMock.BaseURL, nil, LHeaders);

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TWebMockMatchingTests.Request_MatchingSingleHeader_RespondsOK;
var
  LHeaderName, LHeaderValue: string;
  LHeaders: TNetHeaders;
  LResponse: IHTTPResponse;
begin
  LHeaderName := 'CustomerHeader';
  LHeaderValue := 'Value';
  LHeaders := TNetHeaders.Create(
    TNetHeader.Create(LHeaderName, LHeaderValue)
  );

  WebMock.StubRequest('*', '*').WithHeader(LHeaderName, LHeaderValue);
  LResponse := WebClient.Get(WebMock.BaseURL, nil, LHeaders);

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TWebMockMatchingTests.StubWithMethodAndStringURI_NotMatching_RespondsNotImplemented(const AMatcherMethod, AMatcherURI, ARequestURI: string);
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest(AMatcherMethod, AMatcherURI);
  LResponse := WebClient.Get(WebMock.URLFor(ARequestURI));

  Assert.AreEqual(501, LResponse.StatusCode);
end;

procedure TWebMockMatchingTests.Request_NotMatchingSingleHeaderByRegEx_RespondsNotImplemented;
var
  LHeaderName: string;
  LHeaders: TNetHeaders;
  LResponse: IHTTPResponse;
begin
  LHeaderName := 'Accept';
  LHeaders := TNetHeaders.Create(
    TNetHeader.Create(LHeaderName, 'text/plain')
  );

  WebMock.StubRequest('*', '*')
    .WithHeader(LHeaderName, TRegEx.Create('video/.+'));
  LResponse := WebClient.Get(WebMock.BaseURL, nil, LHeaders);

  Assert.AreEqual(501, LResponse.StatusCode);
end;

procedure TWebMockMatchingTests.Request_NotMatchingSingleHeader_RespondsNotImplemented;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('*', '*').WithHeader('CustomerHeader', 'Value');
  LResponse := WebClient.Get(WebMock.BaseURL);

  Assert.AreEqual(501, LResponse.StatusCode);
end;

procedure TWebMockMatchingTests.Request_PartiallyMatchingMultipleHeaders_RespondsNotImplemented;
var
  LHeaderName1, LHeaderValue1, LHeaderName2, LHeaderValue2: string;
  LHeaders: TNetHeaders;
  LResponse: IHTTPResponse;
begin
  LHeaderName1 := 'Header1';
  LHeaderValue1 := 'Value1';
  LHeaderName2 := 'Header2';
  LHeaderValue2 := 'Value2';
  LHeaders := TNetHeaders.Create(
    TNetHeader.Create(LHeaderName1, LHeaderValue1),
    TNetHeader.Create(LHeaderName2, 'WrongValue')
  );

  WebMock.StubRequest('*', '*')
    .WithHeader(LHeaderName1, LHeaderValue1)
    .WithHeader(LHeaderName2, LHeaderValue2);
  LResponse := WebClient.Get(WebMock.BaseURL, nil, LHeaders);

  Assert.AreEqual(501, LResponse.StatusCode);
end;

procedure TWebMockMatchingTests.RequestWithMethodAndRegExPath_Matching_RespondsOK(
  const AMatcherMethod, AMatcherURIPattern, ARequestURI: string);
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest(AMatcherMethod, TRegEx.Create(AMatcherURIPattern));
  LResponse := WebClient.Get(WebMock.URLFor(ARequestURI));

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TWebMockMatchingTests.RequestWithMethodAndRegExPath_NotMatching_RespondsNotImplemented(
  const AMatcherMethod, AMatcherURIPattern, ARequestURI: string);
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest(AMatcherMethod, TRegEx.Create(AMatcherURIPattern));
  LResponse := WebClient.Get(WebMock.URLFor(ARequestURI));

  Assert.AreEqual(501, LResponse.StatusCode);
end;

procedure TWebMockMatchingTests.RequestWithMethodAndStringPath_Matching_RespondsOK(const AMatcherMethod, AMatcherURI, ARequestURI: string);
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest(AMatcherMethod, AMatcherURI);
  LResponse := WebClient.Get(WebMock.URLFor(ARequestURI));

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TWebMockMatchingTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockMatchingTests.TearDown;
begin
  WebMock.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockMatchingTests);
end.

