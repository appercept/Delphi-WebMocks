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

unit WebMock.Tests;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  WebMock;

type

  [TestFixture]
  TWebMockTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Create_WithNoArguments_StartsListeningOnPortGreaterThan8080;
    [Test]
    procedure Create_WithNoArgumentsWhenRepeated_StartsListeningOnDifferentPorts;
    [Test]
    procedure Create_WithPort_StartsListeningOnPortPort;
    [Test]
    procedure BaseURL_ByDefault_ReturnsLocalHostURLWithPort;
    [Test]
    procedure Port_Always_ReturnsTheListeningPort;
    [Test]
    procedure Reset_Always_ClearsHistory;
    [Test]
    procedure Reset_Always_ClearsStubRegistry;
    [Test]
    procedure ResetHistory_Always_ClearsHistory;
    [Test]
    procedure ResetStubRegistry_Always_ClearsStubRegistry;
    [Test]
    procedure StubRequest_WithStringURI_ReturnsARequestStub;
    [Test]
    procedure StubRequest_WithRegExURI_ReturnsARequestStub;
    [Test]
    procedure URLFor_GivenEmptyString_ReturnsBaseURL;
    [Test]
    procedure URLFor_GivenStringWithoutLeadingSlash_ReturnsCorrectlyJoinedURL;
    [Test]
    procedure URLFor_GivenStringWithLeadingSlash_ReturnsCorrectlyJoinedURL;
  end;

implementation

uses
  System.Net.HttpClient, System.RegularExpressions, System.StrUtils,
  TestHelpers,
  WebMock.RequestStub, WebMock.Static.RequestStub;

procedure TWebMockTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockTests.TearDown;
begin
  WebMock.Free;
end;

procedure TWebMockTests.URLFor_GivenEmptyString_ReturnsBaseURL;
begin
  Assert.AreEqual(WebMock.BaseURL, WebMock.URLFor(''));
end;

procedure TWebMockTests.URLFor_GivenStringWithLeadingSlash_ReturnsCorrectlyJoinedURL;
begin
  Assert.AreEqual(Format('http://127.0.0.1:%d/file', [WebMock.Port]), WebMock.URLFor('/file'));
end;

procedure TWebMockTests.URLFor_GivenStringWithoutLeadingSlash_ReturnsCorrectlyJoinedURL;
begin
  Assert.AreEqual(Format('http://127.0.0.1:%d/file', [WebMock.Port]), WebMock.URLFor('file'));
end;

procedure TWebMockTests.BaseURL_ByDefault_ReturnsLocalHostURLWithPort;
begin
  Assert.AreEqual(Format('http://127.0.0.1:%d/', [WebMock.Port]), WebMock.BaseURL);
end;

procedure TWebMockTests.Create_WithNoArgumentsWhenRepeated_StartsListeningOnDifferentPorts;
var
  LWebMock1, LWebMock2: TWebMock;
begin
  LWebMock1 := TWebMock.Create;
  LWebMock2 := TWebMock.Create;

  Assert.IsTrue(LWebMock2.Port > LWebMock1.Port);
end;

procedure TWebMockTests.Create_WithNoArguments_StartsListeningOnPortGreaterThan8080;
var
  LResponse: IHTTPResponse;
begin
  LResponse := WebClient.Get(WebMock.URLFor('/'));

  Assert.IsTrue(WebMock.Port >= 8080);
end;

procedure TWebMockTests.Create_WithPort_StartsListeningOnPortPort;
var
  LResponse: IHTTPResponse;
begin
  WebMock.Free;

  WebMock := TWebMock.Create(8079);
  LResponse := WebClient.Get('http://localhost:8079/');

  Assert.AreEqual('Delphi WebMocks', LResponse.HeaderValue['Server']);
end;

procedure TWebMockTests.Port_Always_ReturnsTheListeningPort;
begin
  Assert.IsTrue(WebMock.Port > 0);
end;

procedure TWebMockTests.ResetHistory_Always_ClearsHistory;
begin
  WebClient.Get(WebMock.URLFor('history'));

  WebMock.ResetHistory;

  Assert.AreEqual(0, WebMock.History.Count);
end;

procedure TWebMockTests.Reset_Always_ClearsHistory;
begin
  WebClient.Get(WebMock.URLFor('history'));

  WebMock.Reset;

  Assert.AreEqual(0, WebMock.History.Count);
end;

procedure TWebMockTests.Reset_Always_ClearsStubRegistry;
begin
  WebMock.StubRequest('GET', 'document');

  WebMock.Reset;

  Assert.AreEqual(0, WebMock.StubRegistry.Count);
end;

procedure TWebMockTests.ResetStubRegistry_Always_ClearsStubRegistry;
begin
  WebMock.StubRequest('GET', 'document');

  WebMock.ResetStubRegistry;

  Assert.AreEqual(0, WebMock.StubRegistry.Count);
end;

procedure TWebMockTests.StubRequest_WithRegExURI_ReturnsARequestStub;
begin
  Assert.IsTrue(WebMock.StubRequest('GET', TRegEx.Create('.*')) is TWebMockStaticRequestStub);
end;

procedure TWebMockTests.StubRequest_WithStringURI_ReturnsARequestStub;
begin
  Assert.IsTrue(WebMock.StubRequest('GET', '/') is TWebMockStaticRequestStub);
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockTests);
end.
