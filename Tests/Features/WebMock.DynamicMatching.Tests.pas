{******************************************************************************}
{                                                                              }
{           Delphi-WebMocks                                                    }
{                                                                              }
{           Copyright (c) 2020 Richard Hatherall                               }
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

unit WebMock.DynamicMatching.Tests;

interface

uses
  DUnitX.TestFramework,
  WebMock;

type
  [TestFixture]
  TWebMockDynamicMatchingTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure DynamicMatcher_ReturningTrue_RespondsOK;
    [Test]
    procedure DynamicMatcher_ReturningFalse_RespondsNotImplemented;
    [Test]
    procedure DynamicMatcher_OnEachRequest_ProvidesRequestForEvaluation;
    [Test]
    procedure DynamicMatcher_OnEachRequest_CanChooseToRespond;
    [Test]
    procedure DynamicMatcher_Always_CanBeChainedToProvideCustomResponses;
  end;

implementation

uses
  System.Classes, System.Net.HttpClient,
  TestHelpers,
  WebMock.HTTP.Messages, WebMock.ResponseStatus;

{ TWebMockDynamicMatchingTests }

procedure TWebMockDynamicMatchingTests.DynamicMatcher_Always_CanBeChainedToProvideCustomResponses;
var
  LResponse: IHTTPResponse;
  LContentStream: TStringStream;
begin
  WebMock.StubRequest(
    function(ARequest: IWebMockHTTPRequest): Boolean
    begin
      Result := True;
    end
  ).ToRespond(Created);
  LContentStream := TStringStream.Create('');
  LResponse := WebClient.Post(WebMock.URLFor('/resource'), LContentStream);

  Assert.AreEqual(201, LResponse.StatusCode);

  LContentStream.Free;
end;

procedure TWebMockDynamicMatchingTests.DynamicMatcher_OnEachRequest_CanChooseToRespond;
var
  LCounter: Integer;
  LResponse: IHTTPResponse;
begin
  LCounter := 0;

  WebMock.StubRequest(
    function(ARequest: IWebMockHTTPRequest): Boolean
    begin
      Inc(LCounter);
      Result := (LCounter mod 2) = 0;
    end
  );

  LResponse := WebClient.Get(WebMock.URLFor('/'));
  Assert.AreEqual(501, LResponse.StatusCode);

  LResponse := WebClient.Get(WebMock.URLFor('/'));
  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TWebMockDynamicMatchingTests.DynamicMatcher_OnEachRequest_ProvidesRequestForEvaluation;
var
  LRequest: IWebMockHTTPRequest;
begin
  WebMock.StubRequest(
    function(ARequest: IWebMockHTTPRequest): Boolean
    begin
      LRequest := ARequest;
      Result := True;
    end
  );
  WebClient.Get(WebMock.URLFor('/'));

  Assert.AreEqual('GET', LRequest.Method);
  Assert.AreEqual('/', LRequest.RequestURI);
end;

procedure TWebMockDynamicMatchingTests.DynamicMatcher_ReturningFalse_RespondsNotImplemented;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest(
    function(ARequest: IWebMockHTTPRequest): Boolean
    begin
      Result := False;
    end
  );
  LResponse := WebClient.Get(WebMock.URLFor('/'));

  Assert.AreEqual(501, LResponse.StatusCode);
end;

procedure TWebMockDynamicMatchingTests.DynamicMatcher_ReturningTrue_RespondsOK;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest(
    function(ARequest: IWebMockHTTPRequest): Boolean
    begin
      Result := True;
    end
  );
  LResponse := WebClient.Get(WebMock.URLFor('/'));

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TWebMockDynamicMatchingTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockDynamicMatchingTests.TearDown;
begin
  WebMock.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockDynamicMatchingTests);
end.
