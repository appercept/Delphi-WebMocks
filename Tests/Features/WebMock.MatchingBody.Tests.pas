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
  end;

implementation

{ TWebMockMatchingBodyTests }

uses
  System.Net.HttpClient, System.RegularExpressions,
  TestHelpers;

procedure TWebMockMatchingBodyTests.Request_WithPatternMatchingBody_RespondsOK;
var
  LContent: string;
  LResponse: IHTTPResponse;
begin
  LContent := 'Hello world!';

  WebMock.StubRequest('*', '*').WithBody(TRegEx.Create('Hello'));
  LResponse := WebClient.Post(WebMock.BaseURL, TStringStream.Create(LContent));

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TWebMockMatchingBodyTests.Request_WithPatternNotMatchingBody_RespondsNotImplemented;
var
  LContent: string;
  LResponse: IHTTPResponse;
begin
  LContent := 'Hello world!';

  WebMock.StubRequest('*', '*').WithBody(TRegEx.Create('Goodbye'));
  LResponse := WebClient.Post(WebMock.BaseURL, TStringStream.Create(LContent));

  Assert.AreEqual(501, LResponse.StatusCode);
end;

procedure TWebMockMatchingBodyTests.Request_WithStringMatchingBodyExactly_RespondsOK;
var
  LContent: string;
  LResponse: IHTTPResponse;
begin
  LContent := 'Hello world!';

  WebMock.StubRequest('*', '*').WithBody(LContent);
  LResponse := WebClient.Post(WebMock.BaseURL, TStringStream.Create(LContent));

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TWebMockMatchingBodyTests.Request_WithStringNotMatchingBody_RespondsNotImplemented;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('*', '*').WithBody('Hello!');
  LResponse := WebClient.Post(WebMock.BaseURL, TStringStream.Create('Goodbye!'));

  Assert.AreEqual(501, LResponse.StatusCode);
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
