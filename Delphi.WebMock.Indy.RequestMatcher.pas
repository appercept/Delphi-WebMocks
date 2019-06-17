unit Delphi.WebMock.Indy.RequestMatcher;

interface

uses
  IdCustomHTTPServer;

type
  TWebMockIndyRequestMatcher = class(TObject)
  private
    FHTTPMethod: string;
    FURI: string;
    function HTTPMethodMatches(AHTTPMethod: string): Boolean;
    function URIMatches(AURI: string): Boolean;
  public
    constructor Create(AHTTPMethod: string = 'GET'; AURI: string = '*');
    function IsMatch(AHTTPRequestInfo: TIdHTTPRequestInfo): Boolean;
    function ToString: string; override;
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
  FHTTPMethod := AHTTPMethod;
  FURI := AURI;
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
    URIMatches(AHTTPRequestInfo.Document);
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
