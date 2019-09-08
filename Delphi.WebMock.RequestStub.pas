unit Delphi.WebMock.RequestStub;

interface

uses
  Delphi.WebMock.Indy.RequestMatcher, Delphi.WebMock.Response,
  Delphi.WebMock.ResponseStatus,
  IdCustomHTTPServer,
  System.Classes, System.Generics.Collections, System.RegularExpressions;

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
    function WithHeader(AName, AValue: string): TWebMockRequestStub; overload;
    function WithHeader(AName: string; APattern: TRegEx)
      : TWebMockRequestStub; overload;
    function WithHeaders(AHeaders: TStringList): TWebMockRequestStub;
    property Matcher: TWebMockIndyRequestMatcher read FMatcher;
    property Response: TWebMockResponse read FResponse write FResponse;
  end;

implementation

uses
  Delphi.WebMock.StringWildcardMatcher, Delphi.WebMock.StringRegExMatcher,
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

function TWebMockRequestStub.WithHeader(AName, AValue: string): TWebMockRequestStub;
begin
  Matcher.Headers.AddOrSetValue(
    AName,
    TWebMockStringWildcardMatcher.Create(AValue)
  );

  Result := Self;
end;

function TWebMockRequestStub.WithHeader(AName: string;
  APattern: TRegEx): TWebMockRequestStub;
begin
  Matcher.Headers.AddOrSetValue(
    AName,
    TWebMockStringRegExMatcher.Create(APattern)
  );

  Result := Self;
end;

function TWebMockRequestStub.WithHeaders(AHeaders: TStringList): TWebMockRequestStub;
var
  I: Integer;
begin
  for I := 0 to AHeaders.Count - 1 do
    WithHeader(AHeaders.Names[I], AHeaders.ValueFromIndex[I]);

  Result := Self;
end;

end.
