{******************************************************************************}
{                                                                              }
{           Delphi-WebMocks                                                    }
{                                                                              }
{           Copyright (c) 2019-2021 Richard Hatherall                          }
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
    FResponse: IWebMockResponse;
    property Response: IWebMockResponse read FResponse;
  public
    constructor Create(AMatcher: TWebMockHTTPRequestMatcher);
    destructor Destroy; override;
    function ToRespond: IWebMockResponseBuilder; overload;
    function ToRespond(AResponseStatus: TWebMockResponseStatus)
      : IWebMockResponseBuilder; overload;
    procedure ToRespondWith(const AProc: TWebMockDynamicResponse);

    function WithBody(const AContent: string): TWebMockStaticRequestStub; overload;
    function WithBody(const APattern: TRegEx): TWebMockStaticRequestStub; overload;
    function WithFormData(const AName, AValue: string): TWebMockStaticRequestStub; overload;
    function WithFormData(const AName: string; const APattern: TRegEx): TWebMockStaticRequestStub; overload;
    function WithHeader(AName, AValue: string): TWebMockStaticRequestStub; overload;
    function WithHeader(AName: string; APattern: TRegEx)
      : TWebMockStaticRequestStub; overload;
    function WithHeaders(AHeaders: TStringList): TWebMockStaticRequestStub;
    function WithJSON(const APath: string; const AValue: Boolean): TWebMockStaticRequestStub; overload;
    function WithJSON(const APath: string; const AValue: Float64): TWebMockStaticRequestStub; overload;
    function WithJSON(const APath: string; const AValue: Integer): TWebMockStaticRequestStub; overload;
    function WithJSON(const APath: string; const AValue: string): TWebMockStaticRequestStub; overload;

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
  WebMock.FormDataMatcher,
  WebMock.JSONMatcher,
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
  Matcher.Free;
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
  AResponseStatus: TWebMockResponseStatus): IWebMockResponseBuilder;
begin
  Result := Response.Builder.WithStatus(AResponseStatus);
end;

procedure TWebMockStaticRequestStub.ToRespondWith(
  const AProc: TWebMockDynamicResponse);
begin
  Responder := TWebMockDynamicResponder.Create(AProc);
end;

function TWebMockStaticRequestStub.ToRespond: IWebMockResponseBuilder;
begin
  Result := Response as IWebMockResponseBuilder;
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

function TWebMockStaticRequestStub.WithFormData(const AName: string;
  const APattern: TRegEx): TWebMockStaticRequestStub;
begin
  if not (Matcher.Body is TWebMockFormDataMatcher) then
    Matcher.Body := TWebMockFormDataMatcher.Create;

  (Matcher.Body as TWebMockFormDataMatcher).Add(AName, APattern);

  Result := Self;
end;

function TWebMockStaticRequestStub.WithFormData(const AName,
  AValue: string): TWebMockStaticRequestStub;
begin
  if not (Matcher.Body is TWebMockFormDataMatcher) then
    Matcher.Body := TWebMockFormDataMatcher.Create;

  (Matcher.Body as TWebMockFormDataMatcher).Add(AName, AValue);

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

function TWebMockStaticRequestStub.WithJSON(const APath: string;
  const AValue: Integer): TWebMockStaticRequestStub;
begin
  if not (Matcher.Body is TWebMockJSONMatcher) then
    Matcher.Body := TWebMockJSONMatcher.Create;

  (Matcher.Body as TWebMockJSONMatcher).Add<Integer>(APath, AValue);

  Result := Self;
end;

function TWebMockStaticRequestStub.WithJSON(const APath: string;
  const AValue: Float64): TWebMockStaticRequestStub;
begin
  if not (Matcher.Body is TWebMockJSONMatcher) then
    Matcher.Body := TWebMockJSONMatcher.Create;

  (Matcher.Body as TWebMockJSONMatcher).Add<Float64>(APath, AValue);

  Result := Self;
end;

function TWebMockStaticRequestStub.WithJSON(const APath,
  AValue: string): TWebMockStaticRequestStub;
begin
  if not (Matcher.Body is TWebMockJSONMatcher) then
    Matcher.Body := TWebMockJSONMatcher.Create;

  (Matcher.Body as TWebMockJSONMatcher).Add<string>(APath, AValue);

  Result := Self;
end;

function TWebMockStaticRequestStub.WithJSON(const APath: string;
  const AValue: Boolean): TWebMockStaticRequestStub;
begin
  if not (Matcher.Body is TWebMockJSONMatcher) then
    Matcher.Body := TWebMockJSONMatcher.Create;

  (Matcher.Body as TWebMockJSONMatcher).Add<Boolean>(APath, AValue);

  Result := Self;
end;

end.
