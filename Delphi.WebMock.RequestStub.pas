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
      : TWebMockResponse;
    property Matcher: TWebMockIndyRequestMatcher read FMatcher;
    property Response: TWebMockResponse read FResponse write FResponse;
  end;

implementation

uses
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
  AResponseStatus: TWebMockResponseStatus = nil): TWebMockResponse;
begin
  if Assigned(AResponseStatus) then
    Response.Status := AResponseStatus;

  Result := Response;
end;

function TWebMockRequestStub.ToString: string;
begin
  Result := Format('%s' + ^I + '%s', [Matcher.ToString, Response.ToString]);
end;

end.
