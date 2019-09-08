unit Delphi.WebMock.Indy.RequestMatcher;

interface

uses
  IdCustomHTTPServer, IdHeaderList,
  System.Generics.Collections, System.RegularExpressions,
  Delphi.WebMock.StringMatcher;

type
  TWebMockIndyRequestMatcher = class(TObject)
  private
    FHeaders: TDictionary<string, IStringMatcher>;
    FHTTPMethod: string;
    FURIMatcher: IStringMatcher;
    function HeadersMatches(AHeaders: TIdHeaderList): Boolean;
    function HTTPMethodMatches(AHTTPMethod: string): Boolean;
  public
    constructor Create(AURI: string; AHTTPMethod: string = 'GET'); overload;
    constructor Create(AURIPattern: TRegEx; AHTTPMethod: string = 'GET'); overload;
    destructor Destroy; override;
    function IsMatch(AHTTPRequestInfo: TIdHTTPRequestInfo): Boolean;
    function ToString: string; override;
    property Headers: TDictionary<string, IStringMatcher> read FHeaders;
    property HTTPMethod: string read FHTTPMethod write FHTTPMethod;
    property URIMatcher: IStringMatcher read FURIMatcher;
  end;

implementation

{ TWebMockIndyRequestMatcher }

uses
  Delphi.WebMock.StringWildcardMatcher, Delphi.WebMock.StringRegExMatcher,
  System.SysUtils;

constructor TWebMockIndyRequestMatcher.Create(AURI: string;
  AHTTPMethod: string = 'GET');
begin
  inherited Create;
  FHeaders := TDictionary<string, IStringMatcher>.Create;
  FURIMatcher := TWebMockStringWildcardMatcher.Create(AURI);
  FHTTPMethod := AHTTPMethod;
end;

constructor TWebMockIndyRequestMatcher.Create(AURIPattern: TRegEx;
  AHTTPMethod: string = 'GET');
begin
  inherited Create;
  FHeaders := TDictionary<string, IStringMatcher>.Create;
  FURIMatcher := TWebMockStringRegExMatcher.Create(AURIPattern);
  FHTTPMethod := AHTTPMethod;
end;

destructor TWebMockIndyRequestMatcher.Destroy;
begin
  FHeaders.Free;
  inherited;
end;

function TWebMockIndyRequestMatcher.HeadersMatches(
  AHeaders: TIdHeaderList): Boolean;
var
  LHeader: TPair<string, IStringMatcher>;
begin
  for LHeader in Headers do
  begin
    if not LHeader.Value.IsMatch(AHeaders.Values[LHeader.Key]) then
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
    URIMatcher.IsMatch(AHTTPRequestInfo.Document) and
    HeadersMatches(AHTTPRequestInfo.RawHeaders);
end;

function TWebMockIndyRequestMatcher.ToString: string;
begin
  Result := Format('%s' + ^I + '%s', [HTTPMethod, URIMatcher]);
end;

end.
