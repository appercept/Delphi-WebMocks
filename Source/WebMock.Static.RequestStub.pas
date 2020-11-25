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

unit WebMock.Static.RequestStub;

interface

uses
  IdCustomHTTPServer,
  System.Classes,
  System.Generics.Collections,
  System.RegularExpressions,
  WebMock.Dynamic.Responder,
  WebMock.HTTP.Messages,
  WebMock.HTTP.RequestMatcher,
  WebMock.RequestStub,
  WebMock.Responder,
  WebMock.Response,
  WebMock.ResponseStatus;

type
  TWebMockStaticRequestStub = class(TInterfacedObject, IWebMockRequestStub)
  private
    FMatcher: TWebMockHTTPRequestMatcher;
    FResponder: IWebMockResponder;
    FResponse: TWebMockResponse;
    property Response: TWebMockResponse read FResponse;
  public
    constructor Create(AMatcher: TWebMockHTTPRequestMatcher);
    destructor Destroy; override;
    function ToRespond(AResponseStatus: TWebMockResponseStatus = nil)
      : IWebMockResponseBuilder;
    procedure ToRespondWith(const AProc: TWebMockDynamicResponse);

    function WithBody(const AContent: string): TWebMockStaticRequestStub; overload;
    function WithBody(const APattern: TRegEx): TWebMockStaticRequestStub; overload;
    function WithHeader(AName, AValue: string): TWebMockStaticRequestStub; overload;
    function WithHeader(AName: string; APattern: TRegEx)
      : TWebMockStaticRequestStub; overload;
    function WithHeaders(AHeaders: TStringList): TWebMockStaticRequestStub;

    // IWebMockRequestStub
    function IsMatch(ARequest: IWebMockHTTPRequest): Boolean;
    function GetResponder: IWebMockResponder;
    procedure SetResponder(const AResponder: IWebMockResponder);
    function ToString: string; override;
    property Responder: IWebMockResponder read GetResponder write SetResponder;

    property Matcher: TWebMockHTTPRequestMatcher read FMatcher;
  end;

implementation

uses
  System.SysUtils,
  WebMock.Static.Responder,
  WebMock.StringWildcardMatcher,
  WebMock.StringRegExMatcher;

{ TWebMockRequestStub }

constructor TWebMockStaticRequestStub.Create(AMatcher: TWebMockHTTPRequestMatcher);
begin
  inherited Create;
  FMatcher := AMatcher;
  FResponse := TWebMockResponse.Create;
  FResponder := TWebMockStaticResponder.Create(Response);
end;

destructor TWebMockStaticRequestStub.Destroy;

begin
  FResponse.Free;
  FMatcher.Free;
  inherited;
end;

function TWebMockStaticRequestStub.GetResponder: IWebMockResponder;
begin
  Result := FResponder;
end;

function TWebMockStaticRequestStub.IsMatch(
  ARequest: IWebMockHTTPRequest): Boolean;
begin
  Result := Matcher.IsMatch(ARequest);
end;

procedure TWebMockStaticRequestStub.SetResponder(
  const AResponder: IWebMockResponder);
begin
  FResponder := AResponder;
end;

function TWebMockStaticRequestStub.ToRespond(
  AResponseStatus: TWebMockResponseStatus = nil): IWebMockResponseBuilder;
begin
  if Assigned(AResponseStatus) then
    Response.Status := AResponseStatus;

  Result := Response as IWebMockResponseBuilder;
end;

procedure TWebMockStaticRequestStub.ToRespondWith(
  const AProc: TWebMockDynamicResponse);
begin
  Responder := TWebMockDynamicResponder.Create(AProc);
end;

function TWebMockStaticRequestStub.ToString: string;
begin
  Result := Format('%s' + ^I + '%s', [Matcher.ToString, Response.ToString]);
end;

function TWebMockStaticRequestStub.WithHeader(AName, AValue: string): TWebMockStaticRequestStub;
begin
  Matcher.Headers.AddOrSetValue(
    AName,
    TWebMockStringWildcardMatcher.Create(AValue)
  );

  Result := Self;
end;

function TWebMockStaticRequestStub.WithBody(
  const AContent: string): TWebMockStaticRequestStub;
begin
  Matcher.Body := TWebMockStringWildcardMatcher.Create(AContent);

  Result := Self;
end;

function TWebMockStaticRequestStub.WithBody(
  const APattern: TRegEx): TWebMockStaticRequestStub;
begin
  Matcher.Body := TWebMockStringRegExMatcher.Create(APattern);

  Result := Self;
end;

function TWebMockStaticRequestStub.WithHeader(AName: string;
  APattern: TRegEx): TWebMockStaticRequestStub;
begin
  Matcher.Headers.AddOrSetValue(
    AName,
    TWebMockStringRegExMatcher.Create(APattern)
  );

  Result := Self;
end;

function TWebMockStaticRequestStub.WithHeaders(AHeaders: TStringList): TWebMockStaticRequestStub;
var
  I: Integer;
begin
  for I := 0 to AHeaders.Count - 1 do
    WithHeader(AHeaders.Names[I], AHeaders.ValueFromIndex[I]);

  Result := Self;
end;

end.
