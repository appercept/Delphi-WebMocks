unit Delphi.WebMock.RequestStub;

interface

uses
  Delphi.WebMock.Indy.RequestMatcher,
  Delphi.WebMock.Response,
  Delphi.WebMock.ResponseStatus,
  IdCustomHTTPServer,
  System.Generics.Collections;

type
  TWebMockRequestStub = class(TObject)
  private
    FMatcher: TWebMockIndyRequestMatcher;
    FResponse: TWebMockResponse;
  public
    constructor Create(AMatcher: TWebMockIndyRequestMatcher);
    destructor Destroy; override;
    function ToString: string; override;
    function ToReturn(AResponseStatus: TWebMockResponseStatus = nil)
      : TWebMockRequestStub;
    function WithContent(const AContent: string;
      const AContentType: string = 'text/plain; charset=utf-8'): TWebMockRequestStub;
    function WithContentFile(const AFileName: string;
      const AContentType: string = ''): TWebMockRequestStub;
    property Matcher: TWebMockIndyRequestMatcher read FMatcher;
    property Response: TWebMockResponse read FResponse write FResponse;
  end;

implementation

uses
  Delphi.WebMock.ResponseContentFile, Delphi.WebMock.ResponseContentString,
  System.SysUtils;

{ TWebMockRequestStub }

constructor TWebMockRequestStub.Create(AMatcher: TWebMockIndyRequestMatcher);
begin
  inherited Create;
  FMatcher := AMatcher;
  FResponse := TWebMockResponse.Create;
end;

destructor TWebMockRequestStub.Destroy;

begin
  FResponse.Free;
  FMatcher.Free;
  inherited;
end;

function TWebMockRequestStub.ToReturn(
  AResponseStatus: TWebMockResponseStatus = nil): TWebMockRequestStub;
begin
  if Assigned(AResponseStatus) then
    Response.Status := AResponseStatus;

  Result := Self;
end;

function TWebMockRequestStub.ToString: string;
begin
  Result := Format('%s' + ^I + '%s', [Matcher.ToString, Response.ToString]);
end;

function TWebMockRequestStub.WithContent(const AContent: string;
  const AContentType: string = 'text/plain; charset=utf-8'): TWebMockRequestStub;
begin
  Response.ContentSource := TWebMockResponseContentString.Create(AContent, AContentType);

  Result := Self;
end;

function TWebMockRequestStub.WithContentFile(
  const AFileName: string; const AContentType: string = ''): TWebMockRequestStub;
begin
  Response.ContentSource := TWebMockResponseContentFile.Create(AFileName, AContentType);

  Result := Self;
end;

end.
