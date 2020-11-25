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

unit WebMock.Response.Tests;

interface

uses
  DUnitX.TestFramework,
  WebMock.Response;

type
  [TestFixture]
  TWebMockResponseTests = class(TObject)
  private
    WebMockResponse: TWebMockResponse;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Create_WithoutArguments_SetsStatusToOK;
    [Test]
    procedure Create_WithStatus_SetsStatus;
    [Test]
    procedure BodySource_WhenNotSet_ReturnsEmptyContentSource;
  end;

implementation

{ TWebMockResponseTests }

uses
  TestHelpers,
  WebMock.ResponseStatus;

procedure TWebMockResponseTests.Setup;
begin
  WebMockResponse := TWebMockResponse.Create;
end;

procedure TWebMockResponseTests.TearDown;
begin
  WebMockResponse.Free;
end;

procedure TWebMockResponseTests.BodySource_WhenNotSet_ReturnsEmptyContentSource;
begin
  Assert.AreEqual(Int64(0), WebMockResponse.BodySource.ContentStream.Size);
end;

procedure TWebMockResponseTests.Create_WithoutArguments_SetsStatusToOK;
begin
  Assert.AreEqual(200, WebMockResponse.Status.Code);
end;

procedure TWebMockResponseTests.Create_WithStatus_SetsStatus;
var
  LExpectedStatus: TWebMockResponseStatus;
begin
  LExpectedStatus := TWebMockResponseStatus.Accepted;

  WebMockResponse := TWebMockResponse.Create(LExpectedStatus);

  Assert.AreSame(LExpectedStatus, WebMockResponse.Status);
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockResponseTests);
end.
