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

unit WebMock.Dynamic.RequestStub.Tests;

interface

uses
  DUnitX.TestFramework,
  WebMock.Dynamic.RequestStub;

type
  [TestFixture]
  TWebMockDynamicRequestStubTests = class(TObject)
  private
    StubbedRequest: TWebMockDynamicRequestStub;
  public
    [Test]
    procedure Class_Always_ImplementsIWebMockRequestStub;
    [Test]
    procedure IsMatch_WhenInitializedWithFunctionReturningTrue_ReturnsTrue;
    [Test]
    procedure IsMatch_WhenInitializedWithFunctionReturningFalse_ReturnsFalse;
    [Test]
    procedure ToRespond_Always_ReturnsAResponseStub;
    [Test]
    procedure ToRespond_WithNoArguments_DoesNotRaiseException;
    [Test]
    procedure ToRespond_WithNoArguments_DoesNotChangeStatus;
    [Test]
    procedure ToString_Always_ReturnsAStringDescription;
  end;

implementation

uses
  IdCustomHTTPServer,
  Mock.Indy.HTTPRequestInfo,
  WebMock.HTTP.Messages,
  WebMock.HTTP.Request,
  WebMock.RequestStub,
  WebMock.Response,
  WebMock.ResponseStatus;

{ TWebMockDynamicRequestStubTests }

procedure TWebMockDynamicRequestStubTests.Class_Always_ImplementsIWebMockRequestStub;
var
  LSubject: IInterface;
begin
  LSubject := TWebMockDynamicRequestStub.Create(
    function(ARequest: IWebMockHTTPRequest): Boolean
    begin
      Result := False;
    end
  );

  Assert.Implements<IWebMockRequestStub>(LSubject);
end;

procedure TWebMockDynamicRequestStubTests.IsMatch_WhenInitializedWithFunctionReturningFalse_ReturnsFalse;
var
  LRequestInfo: TIdHTTPRequestInfo;
  LRequest: IWebMockHTTPRequest;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/');
  LRequest := TWebMockHTTPRequest.Create(LRequestInfo);

  StubbedRequest := TWebMockDynamicRequestStub.Create(
    function(ARequest: IWebMockHTTPRequest): Boolean
    begin
      Result := False;
    end
  );

  Assert.IsFalse(StubbedRequest.IsMatch(LRequest));
end;

procedure TWebMockDynamicRequestStubTests.IsMatch_WhenInitializedWithFunctionReturningTrue_ReturnsTrue;
var
  LRequestInfo: TIdHTTPRequestInfo;
  LRequest: IWebMockHTTPRequest;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/');
  LRequest := TWebMockHTTPRequest.Create(LRequestInfo);

  StubbedRequest := TWebMockDynamicRequestStub.Create(
    function(ARequest: IWebMockHTTPRequest): Boolean
    begin
      Result := True;
    end
  );

  Assert.IsTrue(StubbedRequest.IsMatch(LRequest));
end;

procedure TWebMockDynamicRequestStubTests.ToRespond_Always_ReturnsAResponseStub;
begin
  Assert.IsNotNull(StubbedRequest.ToRespond as IWebMockResponseBuilder);
end;

procedure TWebMockDynamicRequestStubTests.ToRespond_WithNoArguments_DoesNotChangeStatus;
var
  LExpectedStatus: TWebMockResponseStatus;
begin
  LExpectedStatus := StubbedRequest.Responder.GetResponseTo(nil).Status;

  StubbedRequest.ToRespond;

  Assert.AreSame(LExpectedStatus,
                 StubbedRequest.Responder.GetResponseTo(nil).Status);
end;

procedure TWebMockDynamicRequestStubTests.ToRespond_WithNoArguments_DoesNotRaiseException;
begin
  Assert.WillNotRaiseAny(
    procedure
    begin
      StubbedRequest.ToRespond;
    end
  );
end;

procedure TWebMockDynamicRequestStubTests.ToString_Always_ReturnsAStringDescription;
begin
  Assert.IsTrue(Length(StubbedRequest.ToString) > 0, 'ToString should return a description');
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockDynamicRequestStubTests);
end.
