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

unit WebMock.Responses.Tests;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  WebMock;

type

  [TestFixture]
  TWebMockResponsesTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Response_WhenRequestStubbed_ReturnsOK;
    [Test]
    procedure Response_WhenRequestIsNotStubbed_ReturnsNotImplemented;
    [Test]
    procedure Response_WhenToRespondSetsStatus_ReturnsSpecifiedStatusCode;
    [Test]
    procedure Response_WhenToRespondSetsStatus_ReturnsSpecifiedStatusText;
    [Test]
    procedure Response_WhenToRespondSetsCustomStatus_ReturnsSpecifiedStatusText;
    [Test]
    procedure Response_WhenRequestAuthorizationHeaderIsNotBasic_ItRespondsWithoutError;
  end;

implementation

{ TWebMockResponsesTests }

uses
  System.Net.HttpClient,
  System.Net.URLClient,
  System.StrUtils,
  TestHelpers,
  WebMock.ResponseStatus;

procedure TWebMockResponsesTests.Response_WhenRequestAuthorizationHeaderIsNotBasic_ItRespondsWithoutError;
var
  LHeaders: TNetHeaders;
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('*', '*');

  LHeaders := TNetHeaders.Create(
    TNetHeader.Create('Authorization', 'NonStandardAuthScheme')
  );
  LResponse := WebClient.Get(WebMock.BaseURL, nil, LHeaders);

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TWebMockResponsesTests.Response_WhenRequestIsNotStubbed_ReturnsNotImplemented;
var
  LResponse: IHTTPResponse;
begin
  LResponse := WebClient.Get(WebMock.BaseURL);

  Assert.AreEqual(501, LResponse.StatusCode);
end;

procedure TWebMockResponsesTests.Response_WhenRequestStubbed_ReturnsOK;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/');
  LResponse := WebClient.Get(WebMock.BaseURL);

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TWebMockResponsesTests.Response_WhenToRespondSetsCustomStatus_ReturnsSpecifiedStatusText;
var
  LExpectedStatus: TWebMockResponseStatus;
  LResponse: IHTTPResponse;
  LContentStream: TStringStream;
begin
  LExpectedStatus := TWebMockResponseStatus.Create(999, 'My Status');

  WebMock.StubRequest('POST', '/response').ToRespond(LExpectedStatus);
  LContentStream := TStringStream.Create('');
  LResponse := WebClient.Post(WebMock.URLFor('response'), LContentStream);

  Assert.IsTrue(EndsStr('My Status', LResponse.StatusText));

  LContentStream.Free;
end;

procedure TWebMockResponsesTests.Response_WhenToRespondSetsStatus_ReturnsSpecifiedStatusCode;
var
  LResponse: IHTTPResponse;
  LContentStream: TStringStream;
begin
  WebMock.StubRequest('POST', '/response').ToRespond(Created);
  LContentStream := TStringStream.Create('');
  LResponse := WebClient.Post(WebMock.URLFor('response'), LContentStream);

  Assert.AreEqual(201, LResponse.StatusCode);

  LContentStream.Free;
end;

procedure TWebMockResponsesTests.Response_WhenToRespondSetsStatus_ReturnsSpecifiedStatusText;
var
  LResponse: IHTTPResponse;
  LContentStream: TStringStream;
begin
  WebMock.StubRequest('POST', '/response').ToRespond(Created);
  LContentStream := TStringStream.Create('');
  LResponse := WebClient.Post(WebMock.URLFor('response'), LContentStream);

  Assert.IsTrue(EndsStr('Created', LResponse.StatusText));

  LContentStream.Free;
end;

procedure TWebMockResponsesTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockResponsesTests.TearDown;
begin
  WebMock.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockResponsesTests);
end.
