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

unit WebMock.HTTP.RequestMatcher.Tests;

interface

uses
  DUnitX.TestFramework,
  WebMock.HTTP.RequestMatcher,
  IdCustomHTTPServer;

type

  [TestFixture]
  TWebMockHTTPRequestMatcherTests = class(TObject)
  private
    RequestMatcher: TWebMockHTTPRequestMatcher;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    [TestCase('HTTPMethod GET', 'HTTPMethod,GET')]
    procedure StringProperty_Defaults_ToValue(APropertyName, Expected: string);
    [Test]
    procedure Headers_Always_IsADictionary;
    [Test]
    procedure Body_ByDefault_MatchesAnyString;
    [Test]
    procedure IsMatch_GivenAMatchingRequest_ReturnsTrue;
    [Test]
    procedure IsMatch_WhenMethodIsWildcardGivenAnyRequestInfoMethod_ReturnsTrue;
    [Test]
    procedure IsMatch_WhenURIIsWildcardGivenAnyRequestInfoURI_ReturnsTrue;
    [Test]
    procedure IsMatch_GivenDifferingHTTPMethod_ReturnsFalse;
    [Test]
    procedure IsMatch_GivenDifferingURI_ReturnsFalse;
    [Test]
    procedure IsMatch_WhenContentMatcherMatchesRequestInfo_ReturnsTrue;
    [Test]
    procedure IsMatch_WhenContentMatcherDoesNotMatchRequestInfo_ReturnsFalse;
    [Test]
    procedure IsMatch_WhenHeadersAreSetGivenMatchingRequestInfo_ReturnsTrue;
    [Test]
    procedure IsMatch_WhenHeadersAreSetGivenNonMatchingRequestInfo_ReturnsFalse;
  end;

implementation

uses
  Mock.Indy.HTTPRequestInfo,
  TestHelpers,
  System.Classes, System.Generics.Collections,
  WebMock.HTTP.Messages, WebMock.HTTP.Request, WebMock.StringMatcher,
  WebMock.StringAnyMatcher, WebMock.StringWildcardMatcher;

{ TWebMockHTTPRequestMatcherTests }

procedure TWebMockHTTPRequestMatcherTests.Setup;
begin
  RequestMatcher := TWebMockHTTPRequestMatcher.Create('');
end;

procedure TWebMockHTTPRequestMatcherTests.TearDown;
begin
  RequestMatcher := nil;
end;

procedure TWebMockHTTPRequestMatcherTests.Body_ByDefault_MatchesAnyString;
begin
  Assert.IsTrue(RequestMatcher.Body.IsMatch('Any Value'));
end;

procedure TWebMockHTTPRequestMatcherTests.Headers_Always_IsADictionary;
begin
  Assert.IsTrue(RequestMatcher.Headers is TDictionary<string, IStringMatcher>);
end;

procedure TWebMockHTTPRequestMatcherTests.IsMatch_GivenAMatchingRequest_ReturnsTrue;
var
  LRequestInfo: TIdHTTPRequestInfo;
  LRequest: IWebMockHTTPRequest;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/match');
  LRequest := TWebMockHTTPRequest.Create(LRequestInfo);

  RequestMatcher := TWebMockHTTPRequestMatcher.Create('/match', 'GET');

  Assert.IsTrue(RequestMatcher.IsMatch(LRequest));
end;

procedure TWebMockHTTPRequestMatcherTests.IsMatch_GivenDifferingHTTPMethod_ReturnsFalse;
var
  LRequestInfo: TIdHTTPRequestInfo;
  LRequest: IWebMockHTTPRequest;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('HEAD');
  LRequest := TWebMockHTTPRequest.Create(LRequestInfo);

  RequestMatcher := TWebMockHTTPRequestMatcher.Create('GET');

  Assert.IsFalse(RequestMatcher.IsMatch(LRequest));
end;

procedure TWebMockHTTPRequestMatcherTests.IsMatch_GivenDifferingURI_ReturnsFalse;
var
  LRequestInfo: TIdHTTPRequestInfo;
  LRequest: IWebMockHTTPRequest;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/no-match');
  LRequest := TWebMockHTTPRequest.Create(LRequestInfo);

  RequestMatcher := TWebMockHTTPRequestMatcher.Create('/match', 'GET');

  Assert.IsFalse(RequestMatcher.IsMatch(LRequest));
end;

procedure TWebMockHTTPRequestMatcherTests.IsMatch_WhenContentMatcherDoesNotMatchRequestInfo_ReturnsFalse;
var
  LRequestInfo: TIdHTTPRequestInfo;
  LContentBody: TStringStream;
  LRequest: IWebMockHTTPRequest;
begin
  LContentBody := TStringStream.Create('No Match');
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('POST', '/');
  LRequestInfo.PostStream := LContentBody;
  LRequest := TWebMockHTTPRequest.Create(LRequestInfo);
  RequestMatcher := TWebMockHTTPRequestMatcher.Create('/', 'POST');
  RequestMatcher.Body := TWebMockStringWildcardMatcher.Create('Other Value');

  Assert.IsFalse(RequestMatcher.IsMatch(LRequest));
end;

procedure TWebMockHTTPRequestMatcherTests.IsMatch_WhenContentMatcherMatchesRequestInfo_ReturnsTrue;
var
  LRequestInfo: TIdHTTPRequestInfo;
  LContentBody: TStringStream;
  LRequest: IWebMockHTTPRequest;
begin
  LContentBody := TStringStream.Create('Match');
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('POST', '/');
  LRequestInfo.PostStream := LContentBody;
  LRequest := TWebMockHTTPRequest.Create(LRequestInfo);
  RequestMatcher := TWebMockHTTPRequestMatcher.Create('/', 'POST');
  RequestMatcher.Body := TWebMockStringWildcardMatcher.Create('Match');

  Assert.IsTrue(RequestMatcher.IsMatch(LRequest));
end;

procedure TWebMockHTTPRequestMatcherTests.IsMatch_WhenHeadersAreSetGivenMatchingRequestInfo_ReturnsTrue;
var
  LRequestInfo: TIdHTTPRequestInfo;
  LHeaderName, LHeaderValue: string;
  LRequest: IWebMockHTTPRequest;
begin
  LHeaderName := 'Header1';
  LHeaderValue := 'Value1';
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/match');
  LRequestInfo.RawHeaders.AddValue(LHeaderName, LHeaderValue);
  LRequest := TWebMockHTTPRequest.Create(LRequestInfo);

  RequestMatcher := TWebMockHTTPRequestMatcher.Create('/match', 'GET');
  RequestMatcher.Headers.AddOrSetValue(
    LHeaderName, TWebMockStringWildcardMatcher.Create(LHeaderValue)
  );

  Assert.IsTrue(RequestMatcher.IsMatch(LRequest));
end;

procedure TWebMockHTTPRequestMatcherTests.IsMatch_WhenHeadersAreSetGivenNonMatchingRequestInfo_ReturnsFalse;
var
  LRequestInfo: TIdHTTPRequestInfo;
  LRequest: IWebMockHTTPRequest;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/match');
  LRequest := TWebMockHTTPRequest.Create(LRequestInfo);

  RequestMatcher := TWebMockHTTPRequestMatcher.Create('/match', 'GET');
  RequestMatcher.Headers.AddOrSetValue(
    'Header1', TWebMockStringWildcardMatcher.Create('Value1')
  );

  Assert.IsFalse(RequestMatcher.IsMatch(LRequest));
end;

procedure TWebMockHTTPRequestMatcherTests.IsMatch_WhenMethodIsWildcardGivenAnyRequestInfoMethod_ReturnsTrue;
var
  LRequestInfo: TIdHTTPRequestInfo;
  LRequest: IWebMockHTTPRequest;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('HEAD');
  LRequest := TWebMockHTTPRequest.Create(LRequestInfo);

  RequestMatcher := TWebMockHTTPRequestMatcher.Create('*', '*');

  Assert.IsTrue(RequestMatcher.IsMatch(LRequest));
end;

procedure TWebMockHTTPRequestMatcherTests.IsMatch_WhenURIIsWildcardGivenAnyRequestInfoURI_ReturnsTrue;
var
  LRequestInfo: TIdHTTPRequestInfo;
  LRequest: IWebMockHTTPRequest;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/match');
  LRequest := TWebMockHTTPRequest.Create(LRequestInfo);

  RequestMatcher := TWebMockHTTPRequestMatcher.Create('*', 'GET');

  Assert.IsTrue(RequestMatcher.IsMatch(LRequest));
end;

procedure TWebMockHTTPRequestMatcherTests.StringProperty_Defaults_ToValue(
  APropertyName, Expected: string);
var
  Actual: string;
begin
  Actual := GetPropertyValue(RequestMatcher, APropertyName).ToString;

  Assert.AreEqual(Expected, Actual);
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockHTTPRequestMatcherTests);
end.
