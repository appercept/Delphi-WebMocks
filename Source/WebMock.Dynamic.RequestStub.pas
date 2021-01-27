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
  WebMock.Dynamic.Responder,
  WebMock.HTTP.Messages,
  WebMock.RequestStub,
  WebMock.Responder,
  WebMock.Response,
  WebMock.ResponseStatus;

type
  TWebMockDynamicRequestMatcher = reference to function(
    ARequest: IWebMockHTTPRequest
  ): Boolean;

  TWebMockDynamicRequestStub = class(TInterfacedObject, IWebMockRequestStub)
  private
    FMatcher: TWebMockDynamicRequestMatcher;
    FResponder: IWebMockResponder;
    FResponse: IWebMockResponse;
    property Response: IWebMockResponse read FResponse;
  public
    constructor Create(const AMatcher: TWebMockDynamicRequestMatcher);
    function ToRespond: IWebMockResponseBuilder; overload;
    function ToRespond(AResponseStatus: TWebMockResponseStatus)
      : IWebMockResponseBuilder; overload;
    procedure ToRespondWith(const AProc: TWebMockDynamicResponse);

    { IWebMockRequestStub }
    function IsMatch(ARequest: IWebMockHTTPRequest): Boolean;
    function GetResponder: IWebMockResponder;
    procedure SetResponder(const AResponder: IWebMockResponder);
    function ToString: string; override;
    property Responder: IWebMockResponder read GetResponder write SetResponder;

    property Matcher: TWebMockDynamicRequestMatcher read FMatcher;
  end;

implementation

uses
  System.SysUtils,
  WebMock.Static.Responder;

{ TWebMockDynamicRequestStub }

constructor TWebMockDynamicRequestStub.Create(
  const AMatcher: TWebMockDynamicRequestMatcher);
begin
  inherited Create;
  FMatcher := AMatcher;
  FResponse := TWebMockResponse.Create;
  FResponder := TWebMockStaticResponder.Create(FResponse)
end;

function TWebMockDynamicRequestStub.GetResponder: IWebMockResponder;
begin
  Result := FResponder;
end;

function TWebMockDynamicRequestStub.IsMatch(
  ARequest: IWebMockHTTPRequest): Boolean;
begin
  Result := Matcher(ARequest);
end;

procedure TWebMockDynamicRequestStub.SetResponder(
  const AResponder: IWebMockResponder);
begin
  FResponder := AResponder;
end;

function TWebMockDynamicRequestStub.ToRespond(
  AResponseStatus: TWebMockResponseStatus): IWebMockResponseBuilder;
begin
  Result := Response.Builder.WithStatus(AResponseStatus);
end;

function TWebMockDynamicRequestStub.ToRespond: IWebMockResponseBuilder;
begin
  Result := Response.Builder;
end;

procedure TWebMockDynamicRequestStub.ToRespondWith(
  const AProc: TWebMockDynamicResponse);
begin
  Responder := TWebMockDynamicResponder.Create(AProc);
end;

function TWebMockDynamicRequestStub.ToString: string;
begin
  Result := Format('(Dynamic Matcher)' + ^I + '%s', [Response.ToString]);
end;

end.
