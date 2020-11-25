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

unit WebMock;

interface

uses
  IdContext,
  IdCustomHTTPServer,
  IdGlobal,
  IdHTTPServer,
  System.Classes,
  System.Generics.Collections,
  System.RegularExpressions,
  System.SysUtils,
  WebMock.Assertion,
  WebMock.HTTP.Messages,
  WebMock.RequestStub,
  WebMock.Static.RequestStub,
  WebMock.Dynamic.RequestStub,
  WebMock.Response,
  WebMock.ResponseBodySource,
  WebMock.ResponseStatus;

type
  EWebMockError = class(Exception);
  EWebMockExceededBindAttempts = class(EWebMockError);

  TWebWockPort = TIdPort;

  TWebMock = class(TObject)
  class var NextPort: Integer;
  private
    FServer: TIdHTTPServer;
    FBaseURL: string;
    FStubRegistry: TList<IWebMockRequestStub>;
    FHistory: TList<IWebMockHTTPRequest>;
    procedure InitializeServer(const APort: TWebWockPort);
    procedure StartServer(const APort: TWebWockPort);
    procedure OnServerRequest(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure AllowAnyAuth(AContext: TIdContext;
      const AAuthType, AAuthData: String; var VUsername, VPassword: String;
      var VHandled: Boolean);
    function GetRequestStub(ARequestInfo: IWebMockHTTPRequest) : IWebMockRequestStub;
    procedure RespondWith(AResponse: TWebMockResponse;
      AResponseInfo: TIdHTTPResponseInfo);
    procedure SetResponseContent(AResponseInfo: TIdHTTPResponseInfo;
      const AResponseContent: IWebMockResponseBodySource);
    procedure SetResponseHeaders(AResponseInfo: TIdHTTPResponseInfo;
      const AResponseHeaders: TStrings);
    procedure SetResponseStatus(AResponseInfo: TIdHTTPResponseInfo;
      const AResponseStatus: TWebMockResponseStatus);
    function GetNextPort: Integer;
    function GetPort: Integer;
    property Server: TIdHTTPServer read FServer write FServer;
  public
    constructor Create(const APort: TWebWockPort = 0);
    destructor Destroy; override;
    function Assert: TWebMockAssertion;
    procedure PrintStubRegistry;
    procedure Reset;
    procedure ResetHistory;
    procedure ResetStubRegistry;
    function StubRequest(const AMethod: string; const AURI: string)
      : TWebMockStaticRequestStub; overload;
    function StubRequest(const AMethod: string; const AURIPattern: TRegEx)
      : TWebMockStaticRequestStub; overload;
    function StubRequest(const AMatcher: TWebMockDynamicRequestMatcher)
      : TWebMockDynamicRequestStub; overload;
    function URLFor(AURI: string): string;
    property BaseURL: string read FBaseURL;
    property History: TList<IWebMockHTTPRequest> read FHistory;
    property StubRegistry: TList<IWebMockRequestStub> read FStubRegistry;
    property Port: Integer read GetPort;
  end;

implementation

uses
  WebMock.HTTP.Request,
  WebMock.HTTP.RequestMatcher,
  IdException,
  IdHTTP,
  IdSocketHandle,
  IdStack;

{ TWebMock }

procedure TWebMock.AllowAnyAuth(AContext: TIdContext; const AAuthType,
  AAuthData: String; var VUsername, VPassword: String; var VHandled: Boolean);
begin
  VHandled := True;
end;

function TWebMock.Assert: TWebMockAssertion;
begin
  Result := TWebMockAssertion.Create(History);
end;

constructor TWebMock.Create(const APort: TWebWockPort = 0);
begin
  inherited Create;
  FStubRegistry := TList<IWebMockRequestStub>.Create;
  FHistory := TList<IWebMockHTTPRequest>.Create;
  InitializeServer(APort);
end;

destructor TWebMock.Destroy;
begin
  FHistory.Free;
  FStubRegistry.Free;
  FServer.Free;
  inherited;
end;

function TWebMock.GetNextPort: Integer;
var
  FIsInitial: Boolean;
begin
  AtomicCmpExchange(NextPort, 8080, 0, FIsInitial);
  if FIsInitial then
    Exit(NextPort);

  Result := AtomicIncrement(NextPort);
end;

function TWebMock.GetPort: Integer;
begin
  Result := Server.Bindings.Items[0].Port;
end;

function TWebMock.GetRequestStub(ARequestInfo: IWebMockHTTPRequest) : IWebMockRequestStub;
var
  LRequestStub: IWebMockRequestStub;
begin
  for LRequestStub in StubRegistry do
  begin
    if LRequestStub.IsMatch(ARequestInfo) then
      Exit(LRequestStub);
  end;
  Result := nil;
end;

procedure TWebMock.InitializeServer(const APort: TWebWockPort);
begin
  if Server <> nil then
  begin
    Server.Active := False;
    Server.Free;
  end;

  FServer := TIdHTTPServer.Create;
  Server.ServerSoftware := 'Delphi WebMocks';
  Server.OnCommandGet := OnServerRequest;
  Server.OnCommandOther := OnServerRequest;
  Server.OnParseAuthentication := AllowAnyAuth;
  StartServer(APort);
end;

procedure TWebMock.OnServerRequest(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  LRequest: IWebMockHTTPRequest;
  LRequestStub: IWebMockRequestStub;
begin
  LRequest := TWebMockHTTPRequest.Create(ARequestInfo);
  History.Add(LRequest);
  LRequestStub := GetRequestStub(LRequest);
  if Assigned(LRequestStub) then
    RespondWith(
      LRequestStub.Responder.GetResponseTo(LRequest),
      AResponseInfo
    )
  else
    SetResponseStatus(AResponseInfo, TWebMockResponseStatus.NotImplemented);
end;

procedure TWebMock.PrintStubRegistry;
var
  LRequestStub: IWebMockRequestStub;
begin
  System.Writeln;
  System.Writeln('Registered Request Stubs');
  for LRequestStub in StubRegistry do
    System.Writeln(LRequestStub.ToString);
end;

procedure TWebMock.Reset;
begin
  ResetHistory;
  ResetStubRegistry;
end;

procedure TWebMock.ResetHistory;
begin
  History.Clear;
end;

procedure TWebMock.ResetStubRegistry;
begin
  StubRegistry.Clear;
end;

procedure TWebMock.RespondWith(AResponse: TWebMockResponse;
  AResponseInfo: TIdHTTPResponseInfo);
begin
  SetResponseStatus(AResponseInfo, AResponse.Status);
  SetResponseHeaders(AResponseInfo, AResponse.Headers);
  SetResponseContent(AResponseInfo, AResponse.BodySource);
end;

procedure TWebMock.SetResponseContent(AResponseInfo: TIdHTTPResponseInfo;
      const AResponseContent: IWebMockResponseBodySource);
begin
  AResponseInfo.ContentType := AResponseContent.ContentType;
  AResponseInfo.ContentStream := AResponseContent.ContentStream;
  AResponseInfo.FreeContentStream := True;
end;

procedure TWebMock.SetResponseHeaders(AResponseInfo: TIdHTTPResponseInfo;
  const AResponseHeaders: TStrings);
begin
  AResponseInfo.CustomHeaders.AddStrings(AResponseHeaders);
end;

procedure TWebMock.SetResponseStatus(AResponseInfo: TIdHTTPResponseInfo;
  const AResponseStatus: TWebMockResponseStatus);
begin
  AResponseInfo.ResponseNo := AResponseStatus.Code;
  if not AResponseStatus.Text.IsEmpty then
    AResponseInfo.ResponseText := AResponseStatus.Text;
end;

procedure TWebMock.StartServer(const APort: TWebWockPort);
var
  LAttempt, LMaxAttempts: Integer;
  LPort: Integer;
  LSocketHandle: TIdSocketHandle;
begin
  LAttempt := 0;
  LMaxAttempts := 3;
  while not Server.Active do
  begin
    Inc(LAttempt);
    if LAttempt >= LMaxAttempts then
      raise EWebMockExceededBindAttempts.Create('Exceeded attempts to bind port.');
    if APort > 0 then
      LPort := APort
    else
      LPort := GetNextPort;
    Server.Bindings.Clear;
    LSocketHandle := Server.Bindings.Add;
    LSocketHandle.Port := LPort;
    try
      Server.Active := True;
      FBaseURL := Format('http://127.0.0.1:%d/', [LSocketHandle.Port]);
    except
      on E: EIdCouldNotBindSocket do
      begin
        Server.Active := False;
        StartServer(APort);
      end;
      on E: EIdSocketError do
      begin
        Server.Active := False;
        StartServer(APort);
      end;
    end;
  end;
end;

function TWebMock.StubRequest(
  const AMatcher: TWebMockDynamicRequestMatcher): TWebMockDynamicRequestStub;
var
  LRequestStub: TWebMockDynamicRequestStub;
begin
  LRequestStub := TWebMockDynamicRequestStub.Create(AMatcher);
  StubRegistry.Add(LRequestStub);

  Result := LRequestStub;
end;

function TWebMock.StubRequest(const AMethod: string;
  const AURIPattern: TRegEx): TWebMockStaticRequestStub;
var
  LMatcher: TWebMockHTTPRequestMatcher;
  LRequestStub: TWebMockStaticRequestStub;
begin
  LMatcher := TWebMockHTTPRequestMatcher.Create(AURIPattern, AMethod);
  LRequestStub := TWebMockStaticRequestStub.Create(LMatcher);
  StubRegistry.Add(LRequestStub);

  Result := LRequestStub;
end;

function TWebMock.URLFor(AURI: string): string;
var
  LURI: string;
begin
  if AURI.StartsWith('/') then
    LURI := AURI.Substring(1)
  else
    LURI := AURI;

  Result := BaseURL + LURI;
end;

function TWebMock.StubRequest(const AMethod: string; const AURI: string)
  : TWebMockStaticRequestStub;
var
  LMatcher: TWebMockHTTPRequestMatcher;
  LRequestStub: TWebMockStaticRequestStub;
begin
  LMatcher := TWebMockHTTPRequestMatcher.Create(AURI, AMethod);
  LRequestStub := TWebMockStaticRequestStub.Create(LMatcher);
  StubRegistry.Add(LRequestStub);

  Result := LRequestStub;
end;

end.
