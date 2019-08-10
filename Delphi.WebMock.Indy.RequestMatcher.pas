unit Delphi.WebMock.Indy.RequestMatcher;

interface

uses
  IdCustomHTTPServer, IdHeaderList,
  System.Generics.Collections;

type
  TWebMockIndyRequestMatcher = class(TObject)
  private
    FHeaders: TDictionary<string, string>;
    FHTTPMethod: string;
    FURI: string;
    function HeadersMatches(AHeaders: TIdHeaderList): Boolean;
    function HTTPMethodMatches(AHTTPMethod: string): Boolean;
    function URIMatches(AURI: string): Boolean;
  public
    constructor Create(AHTTPMethod: string = 'GET'; AURI: string = '*');
    destructor Destroy; override;
    function IsMatch(AHTTPRequestInfo: TIdHTTPRequestInfo): Boolean;
    function ToString: string; override;
    property Headers: TDictionary<string, string> read FHeaders;
    property HTTPMethod: string read FHTTPMethod write FHTTPMethod;
    property URI: string read FURI write FURI;
  end;

implementation

{ TWebMockIndyRequestMatcher }

uses
  System.SysUtils;

constructor TWebMockIndyRequestMatcher.Create(AHTTPMethod: string = 'GET';
  AURI: string = '*');
begin
  inherited Create;
  FHeaders := TDictionary<string, string>.Create;
  FHTTPMethod := AHTTPMethod;
  FURI := AURI;
end;

destructor TWebMockIndyRequestMatcher.Destroy;
begin
  FHeaders.Free;
  inherited;
end;

function TWebMockIndyRequestMatcher.HeadersMatches(
  AHeaders: TIdHeaderList): Boolean;
var
  LHeader: TPair<string, string>;
begin
  for LHeader in Headers do
  begin
    if AHeaders.Values[LHeader.Key] <> LHeader.Value then
    begin
      Result := False;
      Exit;
    end;
  end;

  Result := True;
end;

function TWebMockIndyRequestMatcher.HTTPMethodMatches
  (AHTTPMethod: string): Boolean;
begin
  Result := (HTTPMethod = '*') or (AHTTPMethod = HTTPMethod);
end;

function TWebMockIndyRequestMatcher.IsMatch(AHTTPRequestInfo
  : TIdHTTPRequestInfo): Boolean;
begin
  Result := HTTPMethodMatches(AHTTPRequestInfo.Command) and
    URIMatches(AHTTPRequestInfo.Document) and
    HeadersMatches(AHTTPRequestInfo.RawHeaders);
end;

function TWebMockIndyRequestMatcher.ToString: string;
begin
  Result := Format('%s' + ^I + '%s', [HTTPMethod, URI]);
end;

function TWebMockIndyRequestMatcher.URIMatches(AURI: string): Boolean;
begin
  Result := (URI = '*') or (URI = AURI);
end;

end.
