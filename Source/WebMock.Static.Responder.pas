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

unit WebMock.Static.Responder;

interface

uses
  WebMock.HTTP.Messages,
  WebMock.Responder,
  WebMock.Response;

type
  TWebMockStaticResponder = class(TInterfacedObject, IWebMockResponder)
  private
    FResponse: IWebMockResponse;
  public
    constructor Create(const AResponse: IWebMockResponse);

    { IWebMockResponder }
    function GetResponseTo(const ARequest: IWebMockHTTPRequest): IWebMockResponse;

    property Response: IWebMockResponse read FResponse;
  end;

implementation

{ TWebMockStaticResponder }

constructor TWebMockStaticResponder.Create(const AResponse: IWebMockResponse);
begin
  inherited Create;
  FResponse := AResponse;
end;

function TWebMockStaticResponder.GetResponseTo(
  const ARequest: IWebMockHTTPRequest): IWebMockResponse;
begin
  Result := FResponse;
end;

end.
