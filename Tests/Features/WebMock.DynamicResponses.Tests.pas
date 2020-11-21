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

unit WebMock.DynamicResponses.Tests;

interface

uses
  DUnitX.TestFramework,
  WebMock;

type
  [TestFixture]
  TWebMockDynamicResponsesTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure DynamicResponse_WithStaticMatcher_ReceivesRequest;
    [Test]
    procedure DynamicResponse_WithDynamicMatcher_ReceivesRequest;
  end;

implementation

uses
  System.Net.HttpClient,
  TestHelpers,
  WebMock.HTTP.Messages,
  WebMock.Response;

{ TWebMockDynamicResponsesTests }

procedure TWebMockDynamicResponsesTests.DynamicResponse_WithDynamicMatcher_ReceivesRequest;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest(
    function(ARequest: IWebMockHTTPRequest): Boolean
    begin
      Result := True;
    end
  ).ToRespondWith(
    procedure(const ARequest: IWebMockHTTPRequest; const AResponse: IWebMockResponseBuilder)
    begin
      AResponse
        .WithStatus(555)
        .WithBody('Dynamic response.');
    end
  );

  LResponse := WebClient.Get(WebMock.URLFor('/'));

  Assert.AreEqual(555, LResponse.StatusCode);
end;

procedure TWebMockDynamicResponsesTests.DynamicResponse_WithStaticMatcher_ReceivesRequest;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('*', '*')
    .ToRespondWith(
      procedure(const ARequest: IWebMockHTTPRequest; const AResponse: IWebMockResponseBuilder)
      begin
        AResponse
          .WithStatus(555)
          .WithBody('Dynamic response.');
      end
    );

  LResponse := WebClient.Get(WebMock.URLFor('/'));

  Assert.AreEqual(555, LResponse.StatusCode);
end;

procedure TWebMockDynamicResponsesTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockDynamicResponsesTests.TearDown;
begin
  WebMock.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockDynamicResponsesTests);
end.
