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

unit WebMock.Dynamic.RequestStub;

interface

uses
  WebMock.HTTP.Messages, WebMock.RequestStub, WebMock.Response,
  WebMock.ResponseStatus;

type
  TWebMockDynamicRequestMatcher = reference to function(
    ARequest: IWebMockHTTPRequest
  ): Boolean;

  TWebMockDynamicRequestStub = class(TInterfacedObject, IWebMockRequestStub)
  private
    FMatcher: TWebMockDynamicRequestMatcher;
    FResponse: TWebMockResponse;
  public
    constructor Create(const AMatcher: TWebMockDynamicRequestMatcher);
    function ToRespond(AResponseStatus: TWebMockResponseStatus = nil)
      : TWebMockResponse;

    // IWebMockRequestStub
    function IsMatch(ARequest: IWebMockHTTPRequest): Boolean;
    function GetResponse: TWebMockResponse;
    procedure SetResponse(const AResponse: TWebMockResponse);
    function ToString: string; override;
    property Response: TWebMockResponse read GetResponse write SetResponse;

    property Matcher: TWebMockDynamicRequestMatcher read FMatcher;
  end;

implementation

uses
  System.SysUtils;

{ TWebMockDynamicRequestStub }

constructor TWebMockDynamicRequestStub.Create(
  const AMatcher: TWebMockDynamicRequestMatcher);
begin
  inherited Create;
  FMatcher := AMatcher;
  FResponse := TWebMockResponse.Create;
end;

function TWebMockDynamicRequestStub.GetResponse: TWebMockResponse;
begin
  Result := FResponse;
end;

function TWebMockDynamicRequestStub.IsMatch(
  ARequest: IWebMockHTTPRequest): Boolean;
begin
  Result := Matcher(ARequest);
end;

procedure TWebMockDynamicRequestStub.SetResponse(
  const AResponse: TWebMockResponse);
begin
  FResponse := AResponse;
end;

function TWebMockDynamicRequestStub.ToRespond(
  AResponseStatus: TWebMockResponseStatus): TWebMockResponse;
begin
  if Assigned(AResponseStatus) then
    Response.Status := AResponseStatus;

  Result := Response;
end;

function TWebMockDynamicRequestStub.ToString: string;
begin
  Result := Format('(Dynamic Matcher)' + ^I + '%s', [Response.ToString]);
end;

end.
