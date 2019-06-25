unit Delphi.WebMock;

interface

uses
  Delphi.WebMock.RequestStub, Delphi.WebMock.Response,
  Delphi.WebMock.ResponseContentSource, Delphi.WebMock.ResponseStatus,
  IdContext, IdCustomHTTPServer, IdGlobal, IdHTTPServer,
  System.Generics.Collections;

type
  TWebWockPort = TIdPort;

  TWebMock = class(TObject)
  private
    FServer: TIdHTTPServer;
    FBaseURL: string;
    FStubRegistry: TObjectList<TWebMockRequestStub>;
    procedure InitializeServer(const APort: TWebWockPort);
    procedure OnServerRequest(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    function GetRequestStub(const ARequestInfo: TIdHTTPRequestInfo)
      : TWebMockRequestStub;
    procedure RespondWith(AResponse: TWebMockResponse;
      AResponseInfo: TIdHTTPResponseInfo);
    procedure SetResponseStatus(AResponseInfo: TIdHTTPResponseInfo;
      const AResponseStatus: TWebMockResponseStatus);
    procedure SetResponseContent(AResponseInfo: TIdHTTPResponseInfo;
      const AResponseContent: IWebMockResponseContentSource);
    property Server: TIdHTTPServer read FServer write FServer;
    property StubRegistry: TObjectList<TWebMockRequestStub> read FStubRegistry;
  public
    constructor Create(const APort: TWebWockPort = 8080);
    destructor Destroy; override;
    procedure PrintStubRegistry;
    function StubRequest(const AMethod: string; const AURI: string)
      : TWebMockRequestStub;
    property BaseURL: string read FBaseURL;
  end;

implementation

uses
  Delphi.WebMock.Indy.RequestMatcher,
  IdHTTP,
  IdSocketHandle,
  System.Classes,
  System.SysUtils;

{ TWebMock }

constructor TWebMock.Create(const APort: TWebWockPort = 8080);
begin
  inherited Create;
  FStubRegistry := TObjectList<TWebMockRequestStub>.Create;
  InitializeServer(APort);
end;

destructor TWebMock.Destroy;
begin
  FStubRegistry.Free;
  FServer.Free;
  inherited;
end;

function TWebMock.GetRequestStub(const ARequestInfo: TIdHTTPRequestInfo)
  : TWebMockRequestStub;
var
  LRequestStub: TWebMockRequestStub;
begin
  for LRequestStub in StubRegistry do
  begin
    if LRequestStub.Matcher.IsMatch(ARequestInfo) then
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
  Server.DefaultPort := APort;
  Server.OnCommandGet := OnServerRequest;
  Server.Active := True;
  FBaseURL := Format('http://127.0.0.1:%d/', [Server.DefaultPort]);
end;

procedure TWebMock.OnServerRequest(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  LRequestStub: TWebMockRequestStub;
begin
  LRequestStub := GetRequestStub(ARequestInfo);
  if Assigned(LRequestStub) then
    RespondWith(LRequestStub.Response, AResponseInfo)
  else
    SetResponseStatus(AResponseInfo, TWebMockResponseStatus.NotImplemented);
end;

procedure TWebMock.PrintStubRegistry;
var
  LRequestStub: TWebMockRequestStub;
begin
  System.Writeln;
  System.Writeln('Registered Request Stubs');
  for LRequestStub in StubRegistry do
    System.Writeln(LRequestStub.ToString);
end;

procedure TWebMock.RespondWith(AResponse: TWebMockResponse;
  AResponseInfo: TIdHTTPResponseInfo);
begin
  SetResponseStatus(AResponseInfo, AResponse.Status);
  SetResponseContent(AResponseInfo, AResponse.ContentSource);
end;

procedure TWebMock.SetResponseContent(AResponseInfo: TIdHTTPResponseInfo;
      const AResponseContent: IWebMockResponseContentSource);
begin
  AResponseInfo.ContentType := AResponseContent.ContentType;
  AResponseInfo.ContentStream := AResponseContent.ContentStream;
  AResponseInfo.FreeContentStream := True;
end;

procedure TWebMock.SetResponseStatus(AResponseInfo: TIdHTTPResponseInfo;
  const AResponseStatus: TWebMockResponseStatus);
begin
  AResponseInfo.ResponseNo := AResponseStatus.Code;
  if not AResponseStatus.Text.IsEmpty then
    AResponseInfo.ResponseText := AResponseStatus.Text;
end;

function TWebMock.StubRequest(const AMethod: string; const AURI: string)
  : TWebMockRequestStub;
var
  LMatcher: TWebMockIndyRequestMatcher;
  LRequestStub: TWebMockRequestStub;
begin
  LMatcher := TWebMockIndyRequestMatcher.Create(AMethod, AURI);
  LRequestStub := TWebMockRequestStub.Create(LMatcher);
  StubRegistry.Add(LRequestStub);

  Result := LRequestStub;
end;

end.
