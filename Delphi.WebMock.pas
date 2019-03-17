unit Delphi.WebMock;

interface

uses
  Delphi.WebMock.RequestStub,
  IdGlobal,
  IdHTTP,
  IdHTTPServer,
  IdSocketHandle,
  System.SysUtils;

type
  TWebMock = class(TObject)
  private
    FServer: TIdHTTPServer;
    FBaseURL: string;
    procedure InitializeServer(const APort: TIdPort);
    property Server: TIdHTTPServer read FServer write FServer;
  protected
  public
    constructor Create(const APort: TIdPort = 8080);
    destructor Destroy; override;
    function StubRequest(const AMethod: TIdHTTPMethod; const AURI: string): IWebMockRequestStub;
    property BaseURL: string read FBaseURL;
  end;

implementation

{ TWebMock }

constructor TWebMock.Create(const APort: TIdPort = 8080);
begin
  inherited Create;
  InitializeServer(APort);
end;

destructor TWebMock.Destroy;
begin
  FServer.Free;
  inherited;
end;

procedure TWebMock.InitializeServer(const APort: TIdPort);
var
  LBinding: TIdSocketHandle;
begin
  if Server <> nil then
  begin
    Server.Active := False;
    Server.Free;
  end;

  FServer := TIdHTTPServer.Create;
  Server.ServerSoftware := 'Delphi WebMocks';
  Server.DefaultPort := APort;
  Server.Active := True;
  FBaseURL := Format('http://127.0.0.1:%d/', [Server.DefaultPort]);
end;

function TWebMock.StubRequest(const AMethod: TIdHTTPMethod; const AURI: string): IWebMockRequestStub;
begin

end;

end.
