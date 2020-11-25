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

unit WebMock.Dynamic.Responder.Tests;

interface

uses
  DUnitX.TestFramework,
  Mock.Indy.HTTPRequestInfo,
  WebMock.Dynamic.Responder,
  WebMock.HTTP.Messages,
  WebMock.HTTP.Request;

type
  [TestFixture]
  TWebMockDynamicResponderTests = class(TObject)
  private
    Responder: TWebMockDynamicResponder;
    IndyRequest: TMockIdHTTPRequestInfo;
    Request: IWebMockHTTPRequest;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure GetResponseTo_Always_ReturnsResponse;
    [Test]
    procedure GetResponseTo_Always_CallsProcWithRequest;
    [Test]
    procedure GetResponseTo_Always_CallsProcWithInitialisedResponseBuilder;
    [Test]
    procedure GetResponseTo_Always_ReturnsBuiltResponse;
  end;

implementation

uses
  WebMock.Response;

{ TWebMockDynamicResponderTests }

procedure TWebMockDynamicResponderTests.GetResponseTo_Always_CallsProcWithInitialisedResponseBuilder;
begin
  Responder := TWebMockDynamicResponder.Create(
    procedure(const ARequest: IWebMockHTTPRequest; const AResponse: IWebMockResponseBuilder)
    begin
      Assert.IsNotNull(AResponse, 'Response builder should be initialised.');
    end
  );
  Responder.GetResponseTo(Request);

  Responder.Free;
end;

procedure TWebMockDynamicResponderTests.GetResponseTo_Always_CallsProcWithRequest;
begin
  Responder := TWebMockDynamicResponder.Create(
    procedure(const ARequest: IWebMockHTTPRequest; const AResponse: IWebMockResponseBuilder)
    begin
      Assert.AreSame(Request, ARequest);
    end
  );
  Responder.GetResponseTo(Request);

  Responder.Free;
end;

procedure TWebMockDynamicResponderTests.GetResponseTo_Always_ReturnsBuiltResponse;
var
  LResponse: TWebMockResponse;
begin
  Responder := TWebMockDynamicResponder.Create(
    procedure(const ARequest: IWebMockHTTPRequest; const AResponse: IWebMockResponseBuilder)
    begin
      AResponse.WithStatus(401);
    end
  );
  LResponse := Responder.GetResponseTo(Request);

  Assert.AreEqual(401, LResponse.Status.Code);

  Responder.Free;
end;

procedure TWebMockDynamicResponderTests.GetResponseTo_Always_ReturnsResponse;
begin
  Responder := TWebMockDynamicResponder.Create(
    procedure(const ARequest: IWebMockHTTPRequest; const AResponse: IWebMockResponseBuilder)
    begin
      // Do nothing.
    end
  );

  Assert.IsNotNull(Responder.GetResponseTo(nil));

  Responder.Free;
end;

procedure TWebMockDynamicResponderTests.Setup;
begin
  IndyRequest := TMockIdHTTPRequestInfo.Mock;
  Request := TWebMockHTTPRequest.Create(IndyRequest);
end;

procedure TWebMockDynamicResponderTests.TearDown;
begin
  Request := nil;
  IndyRequest.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockDynamicResponderTests);
end.
