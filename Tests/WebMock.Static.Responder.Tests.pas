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

unit WebMock.Static.Responder.Tests;

interface

uses
  DUnitX.TestFramework,
  WebMock.Static.Responder;

type
  [TestFixture]
  TWebMockStaticResponderTests = class(TObject)
  private
    Responder: TWebMockStaticResponder;
  public
    [Test]
    procedure GetResponseTo_Always_ReturnsResponse;
  end;

implementation

uses
  WebMock.Response;

{ TWebMockStaticResponderTests }

procedure TWebMockStaticResponderTests.GetResponseTo_Always_ReturnsResponse;
var
  LResponse: IWebMockResponse;
begin
  LResponse := TWebMockResponse.Create;
  Responder := TWebMockStaticResponder.Create(LResponse);

  Assert.AreSame(LResponse, Responder.GetResponseTo(nil) as TWebMockResponse);

  Responder.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockStaticResponderTests);
end.
