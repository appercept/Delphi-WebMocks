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

unit WebMock.Dynamic.Responder;

interface

uses
  WebMock.HTTP.Messages,
  WebMock.Responder,
  WebMock.Response;

type
  TWebMockDynamicResponse = reference to procedure (
    const ARequest: IWebMockHTTPRequest;
    const AResponse: IWebMockResponseBuilder
  );

  TWebMockDynamicResponder = class(TInterfacedObject, IWebMockResponder)
  private
    FProc: TWebMockDynamicResponse;
  public
    constructor Create(const AProc: TWebMockDynamicResponse);
    function GetResponseTo(const ARequest: IWebMockHTTPRequest): IWebMockResponse;
  end;

implementation

{ TWebMockDynamicResponder }

constructor TWebMockDynamicResponder.Create(
  const AProc: TWebMockDynamicResponse);
begin
  inherited Create;
  FProc := AProc;
end;

function TWebMockDynamicResponder.GetResponseTo(
  const ARequest: IWebMockHTTPRequest): IWebMockResponse;
var
  LResponse: TWebMockResponse;
begin
  LResponse := TWebMockResponse.Create;
  FProc(ARequest, LResponse.Builder);
  Result := LResponse;
end;

end.
