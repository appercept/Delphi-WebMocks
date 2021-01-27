{******************************************************************************}
{                                                                              }
{           Delphi-WebMocks                                                    }
{                                                                              }
{           Copyright (c) 2019-2020 Richard Hatherall                          }
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

unit WebMock.MatchingBody.Tests;

interface

uses
  DUnitX.TestFramework,
  System.Classes, System.SysUtils,
  WebMock;

type

  [TestFixture]
  TWebMockMatchingBodyTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Request_WithStringMatchingBodyExactly_RespondsOK;
    [Test]
    procedure Request_WithStringNotMatchingBody_RespondsNotImplemented;
    [Test]
    procedure Request_WithPatternMatchingBody_RespondsOK;
    [Test]
    procedure Request_WithPatternNotMatchingBody_RespondsNotImplemented;
    [Test]
    procedure Request_WithFormDataMatchingBody_RespondsOK;
    [Test]
    procedure Request_WithFormDataMatchingBodyWithEncodedValues_RespondsOK;
    [Test]
    procedure Request_WithFormDataMatchingBodyWithMultipleFields_RespondsOK;
  end;

implementation

{ TWebMockMatchingBodyTests }

uses
  System.Net.HttpClient, System.RegularExpressions,
  TestHelpers;

procedure TWebMockMatchingBodyTests.Request_WithFormDataMatchingBodyWithEncodedValues_RespondsOK;
var
  LFormData: TStringList;
  LResponse: IHTTPResponse;
  LValue: string;
begin
  LValue := 'A encoded value & things.';
  LFormData := TStringList.Create;
  LFormData.AddPair('AField', LValue);

  WebMock.StubRequest('*', '*').WithFormData('AField', LValue);
  LResponse := WebClient.Post(WebMock.BaseURL, LFormData);

  Assert.AreEqual(200, LResponse.StatusCode);

  LFormData.Free;
end;

procedure TWebMockMatchingBodyTests.Request_WithFormDataMatchingBodyWithMultipleFields_RespondsOK;
var
  LFormData: TStringList;
  LResponse: IHTTPResponse;
begin
  LFormData := TStringList.Create;
  LFormData.AddPair('Field1', 'Value1');
  LFormData.AddPair('Field2', 'Value2');

  WebMock.StubRequest('*', '*')
    .WithFormData('Field1', 'Value1')
    .WithFormData('Field2', 'Value2');
  LResponse := WebClient.Post(WebMock.BaseURL, LFormData);

  Assert.AreEqual(200, LResponse.StatusCode);

  LFormData.Free;
end;

procedure TWebMockMatchingBodyTests.Request_WithFormDataMatchingBody_RespondsOK;
var
  LFormData: TStringList;
  LResponse: IHTTPResponse;
begin
  LFormData := TStringList.Create;
  LFormData.AddPair('AField', 'AValue');

  WebMock.StubRequest('*', '*').WithFormData('AField', 'AValue');
  LResponse := WebClient.Post(WebMock.BaseURL, LFormData);

  Assert.AreEqual(200, LResponse.StatusCode);

  LFormData.Free;
end;

procedure TWebMockMatchingBodyTests.Request_WithPatternMatchingBody_RespondsOK;
var
  LContent: string;
  LContentStream: TStringStream;
  LResponse: IHTTPResponse;
begin
  LContent := 'Hello world!';
  LContentStream := TStringStream.Create(LContent);

  WebMock.StubRequest('*', '*').WithBody(TRegEx.Create('Hello'));
  LResponse := WebClient.Post(WebMock.BaseURL, LContentStream);

  Assert.AreEqual(200, LResponse.StatusCode);

  LContentStream.Free;
end;

procedure TWebMockMatchingBodyTests.Request_WithPatternNotMatchingBody_RespondsNotImplemented;
var
  LContent: string;
  LContentStream: TStringStream;
  LResponse: IHTTPResponse;
begin
  LContent := 'Hello world!';
  LContentStream := TStringStream.Create(LContent);

  WebMock.StubRequest('*', '*').WithBody(TRegEx.Create('Goodbye'));
  LResponse := WebClient.Post(WebMock.BaseURL, LContentStream);

  Assert.AreEqual(501, LResponse.StatusCode);

  LContentStream.Free;
end;

procedure TWebMockMatchingBodyTests.Request_WithStringMatchingBodyExactly_RespondsOK;
var
  LContent: string;
  LContentStream: TStringStream;
  LResponse: IHTTPResponse;
begin
  LContent := 'Hello world!';
  LContentStream := TStringStream.Create(LContent);

  WebMock.StubRequest('*', '*').WithBody(LContent);
  LResponse := WebClient.Post(WebMock.BaseURL, LContentStream);

  Assert.AreEqual(200, LResponse.StatusCode);

  LContentStream.Free;
end;

procedure TWebMockMatchingBodyTests.Request_WithStringNotMatchingBody_RespondsNotImplemented;
var
  LContentStream: TStringStream;
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('*', '*').WithBody('Hello!');
  LContentStream := TStringStream.Create('Goodbye!');
  LResponse := WebClient.Post(WebMock.BaseURL, LContentStream);

  Assert.AreEqual(501, LResponse.StatusCode);

  LContentStream.Free;
end;

procedure TWebMockMatchingBodyTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockMatchingBodyTests.TearDown;
begin
  WebMock.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockMatchingBodyTests);
end.
