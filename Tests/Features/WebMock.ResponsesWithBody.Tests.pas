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

unit WebMock.ResponsesWithBody.Tests;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  WebMock;

type

  [TestFixture]
  TWebMockResponsesWithBodyTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Response_WhenWithBodyIsAStringWithoutContentType_SetsContentTypeToPlainText;
    [Test]
    procedure Response_WhenWithBodyIsAStringWithContentType_SetsContentType;
    [Test]
    procedure Response_WhenWithBodyIsAString_ReturnsStringAsContent;
    [Test]
    procedure Response_WhenWithBodyIsString_ReturnsUTF8CharSet;
    [Test]
    procedure Response_WhenWithBodyIsStringOnMultipleCalls_Succeeds;
    [Test]
    procedure Response_WhenWithBodyFileWithoutContentType_SetsContentTypeToInferedType;
    [Test]
    procedure Response_WhenWithBodyFileWithContentType_SetsContentType;
    [Test]
    procedure Response_WhenWithBodyFileOnMultipleCalls_Succeeds;
  end;

implementation

{ TWebMockResponsesWithBodyTests }

uses
  IdGlobal,
  System.Net.HttpClient,
  TestHelpers;

procedure TWebMockResponsesWithBodyTests.Response_WhenWithBodyFileOnMultipleCalls_Succeeds;
var
  LExpected: string;
  LResponse: IHTTPResponse;
begin
  LExpected := '{ "key": "value" }';
  WebMock.StubRequest('GET', '/json').ToRespond.WithBodyFile(FixturePath('Response.json'));

  // First request
  LResponse := WebClient.Get(WebMock.URLFor('json'));
  Assert.AreEqual(LExpected, LResponse.ContentAsString.Trim, 'on first request');

  // Second request
  LResponse := WebClient.Get(WebMock.URLFor('json'));
  Assert.AreEqual(LExpected, LResponse.ContentAsString.Trim, 'on second request');
end;

procedure TWebMockResponsesWithBodyTests.Response_WhenWithBodyFileWithContentType_SetsContentType;
var
  LExpected: string;
  LResponse: IHTTPResponse;
begin
  LExpected := 'application/xml';

  WebMock.StubRequest('GET', '/json').ToRespond.WithBodyFile(FixturePath('Response.json'), LExpected);
  LResponse := WebClient.Get(WebMock.URLFor('json'));

  Assert.AreEqual(LExpected, LResponse.HeaderValue['Content-Type']);
end;

procedure TWebMockResponsesWithBodyTests.Response_WhenWithBodyFileWithoutContentType_SetsContentTypeToInferedType;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/json').ToRespond.WithBodyFile(FixturePath('Response.json'));
  LResponse := WebClient.Get(WebMock.URLFor('json'));

  Assert.AreEqual('application/json', LResponse.HeaderValue['Content-Type']);
end;

procedure TWebMockResponsesWithBodyTests.Response_WhenWithBodyIsAStringWithContentType_SetsContentType;
var
  LExpected: string;
  LResponse: IHTTPResponse;
begin
  LExpected := 'text/rtf';

  WebMock.StubRequest('GET', '/text').ToRespond.WithBody('Text', LExpected);
  LResponse := WebClient.Get(WebMock.URLFor('text'));

  Assert.StartsWith(LExpected, LResponse.HeaderValue['Content-Type']);
end;

procedure TWebMockResponsesWithBodyTests.Response_WhenWithBodyIsAStringWithoutContentType_SetsContentTypeToPlainText;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/text').ToRespond.WithBody('Text');
  LResponse := WebClient.Get(WebMock.URLFor('text'));

  Assert.StartsWith('text/plain', LResponse.HeaderValue['Content-Type']);
end;

procedure TWebMockResponsesWithBodyTests.Response_WhenWithBodyIsAString_ReturnsStringAsContent;
var
  LExpectedContent: string;
  LResponse: IHTTPResponse;
  LContentText: string;
begin
  LExpectedContent := 'Body Text';

  WebMock.StubRequest('GET', '/text').ToRespond.WithBody(LExpectedContent);
  LResponse := WebClient.Get(WebMock.URLFor('text'));

  LContentText := ReadStringFromStream(LResponse.ContentStream);
  Assert.AreEqual(LExpectedContent, LContentText);
end;

procedure TWebMockResponsesWithBodyTests.Response_WhenWithBodyIsStringOnMultipleCalls_Succeeds;
var
  LContent: string;
  LResponse: IHTTPResponse;
begin
  LContent := 'Some text...';
  WebMock.StubRequest('GET', '/text').ToRespond.WithBody(LContent);

  // First request
  LResponse := WebClient.Get(WebMock.URLFor('text'));
  Assert.EndsWith(LContent, LResponse.ContentAsString);

  // Second request
  LResponse := WebClient.Get(WebMock.URLFor('text'));
  Assert.EndsWith(LContent, LResponse.ContentAsString);
end;

procedure TWebMockResponsesWithBodyTests.Response_WhenWithBodyIsString_ReturnsUTF8CharSet;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/text').ToRespond.WithBody('UTF-8 Text');
  LResponse := WebClient.Get(WebMock.URLFor('text'));

  Assert.EndsWith('utf-8', LResponse.HeaderValue['Content-Type']);
end;

procedure TWebMockResponsesWithBodyTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockResponsesWithBodyTests.TearDown;
begin
  WebMock.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockResponsesWithBodyTests);
end.
