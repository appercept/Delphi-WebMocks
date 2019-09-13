unit Delphi.WebMock.Indy.RequestMatcher;

interface

uses
  Delphi.WebMock.StringMatcher,
  IdCustomHTTPServer, IdHeaderList,
  System.Classes, System.Generics.Collections, System.RegularExpressions;

type
  TWebMockIndyRequestMatcher = class(TObject)
  private
    FContent: IStringMatcher;
    FHeaders: TDictionary<string, IStringMatcher>;
    FHTTPMethod: string;
    FURIMatcher: IStringMatcher;
    function HeadersMatches(AHeaders: TIdHeaderList): Boolean;
    function HTTPMethodMatches(AHTTPMethod: string): Boolean;
    function StreamToString(AStream: TStream): string;
  public
    constructor Create(AURI: string; AHTTPMethod: string = 'GET'); overload;
    constructor Create(AURIPattern: TRegEx; AHTTPMethod: string = 'GET'); overload;
    destructor Destroy; override;
    function IsMatch(AHTTPRequestInfo: TIdHTTPRequestInfo): Boolean;
    function ToString: string; override;
    property Content: IStringMatcher read FContent write FContent;
    property Headers: TDictionary<string, IStringMatcher> read FHeaders;
    property HTTPMethod: string read FHTTPMethod write FHTTPMethod;
    property URIMatcher: IStringMatcher read FURIMatcher;
  end;

implementation

{ TWebMockIndyRequestMatcher }

uses
  Delphi.WebMock.StringWildcardMatcher, Delphi.WebMock.StringAnyMatcher,
  Delphi.WebMock.StringRegExMatcher,
  System.SysUtils;

constructor TWebMockIndyRequestMatcher.Create(AURI: string;
  AHTTPMethod: string = 'GET');
begin
  inherited Create;
  FContent := TWebMockStringAnyMatcher.Create;
  FHeaders := TDictionary<string, IStringMatcher>.Create;
  FURIMatcher := TWebMockStringWildcardMatcher.Create(AURI);
  FHTTPMethod := AHTTPMethod;
end;

constructor TWebMockIndyRequestMatcher.Create(AURIPattern: TRegEx;
  AHTTPMethod: string = 'GET');
begin
  inherited Create;
  FContent := TWebMockStringAnyMatcher.Create;
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
    HeadersMatches(AHTTPRequestInfo.RawHeaders) and
    Content.IsMatch(StreamToString(AHTTPRequestInfo.PostStream));
end;

function TWebMockIndyRequestMatcher.StreamToString(AStream: TStream): string;
var
  LStringStream: TStringStream;
begin
  if not Assigned(AStream) then
  begin
    Result := '';
    Exit;
  end;

  LStringStream := TStringStream.Create;
  try
    LStringStream.CopyFrom(AStream, AStream.Size);
    Result := LStringStream.DataString;
  finally
    LStringStream.Free;
  end;
end;

function TWebMockIndyRequestMatcher.ToString: string;
begin
  Result := Format('%s' + ^I + '%s', [HTTPMethod, URIMatcher]);
end;

end.
