unit Delphi.WebMock.Assertion;

interface

uses
  Delphi.WebMock.HTTP.Messages, Delphi.WebMock.HTTP.RequestMatcher,
  DUnitX.TestFramework,
  System.Classes, System.Generics.Collections, System.RegularExpressions;

type
  TWebMockAssertion = class(TObject)
  private
    FMatcher: TWebMockHTTPRequestMatcher;
    FHistory: TList<IWebMockHTTPRequest>;
    function MatchesHistory: Boolean;
  public
    constructor Create(AHistory: TList<IWebMockHTTPRequest>);
    function Delete(const AURI: string): TWebMockAssertion;
    function Get(const AURI: string): TWebMockAssertion;
    function Patch(const AURI: string): TWebMockAssertion;
    function Post(const AURI: string): TWebMockAssertion;
    function Put(const AURI: string): TWebMockAssertion;
    function Request(const AMethod, AURI: string): TWebMockAssertion; overload;
    function Request(const AMethod: string; const AURIPattern: TRegEx): TWebMockAssertion; overload;
    function WithBody(const AContent: string): TWebMockAssertion; overload;
    function WithBody(const APattern: TRegEx): TWebMockAssertion; overload;
    function WithHeader(const AName, AValue: string): TWebMockAssertion; overload;
    function WithHeader(const AName: string; const APattern: TRegEx): TWebMockAssertion; overload;
    function WithHeaders(const AHeaders: TStringList): TWebMockAssertion;
    procedure WasRequested;
    procedure WasNotRequested;
    property History: TList<IWebMockHTTPRequest> read FHistory;
    property Matcher: TWebMockHTTPRequestMatcher read FMatcher;
  end;

implementation

{ TWebMockAssertion }

uses
  Delphi.WebMock.StringRegExMatcher, Delphi.WebMock.StringWildcardMatcher,
  System.SysUtils;

constructor TWebMockAssertion.Create(AHistory: TList<IWebMockHTTPRequest>);
begin
  inherited Create;
  FHistory := AHistory;
end;

function TWebMockAssertion.Delete(const AURI: string): TWebMockAssertion;
begin
  Result := Request('DELETE', AURI);
end;

function TWebMockAssertion.Get(const AURI: string): TWebMockAssertion;
begin
  Result := Request('GET', AURI);
end;

function TWebMockAssertion.MatchesHistory: Boolean;
var
  LRequest: IWebMockHTTPRequest;
begin
  Result := False;

  for LRequest in History do
  begin
    if Matcher.IsMatch(LRequest) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

function TWebMockAssertion.Patch(const AURI: string): TWebMockAssertion;
begin
  Result := Request('PATCH', AURI);
end;

function TWebMockAssertion.Post(const AURI: string): TWebMockAssertion;
begin
  Result := Request('POST', AURI);
end;

function TWebMockAssertion.Put(const AURI: string): TWebMockAssertion;
begin
  Result := Request('PUT', AURI);
end;

function TWebMockAssertion.Request(const AMethod: string;
  const AURIPattern: TRegEx): TWebMockAssertion;
begin
  FMatcher := TWebMockHTTPRequestMatcher.Create(AURIPattern, AMethod);

  Result := Self;
end;

function TWebMockAssertion.Request(const AMethod, AURI: string): TWebMockAssertion;
begin
  FMatcher := TWebMockHTTPRequestMatcher.Create(AURI, AMethod);

  Result := Self;
end;

procedure TWebMockAssertion.WasNotRequested;
begin
  if MatchesHistory then
    Assert.Fail(Format('Found request matching %s', [Matcher.ToString]))
  else
    Assert.Pass(Format('Did not find request matching %s', [Matcher.ToString]));
end;

procedure TWebMockAssertion.WasRequested;
begin
  if MatchesHistory then
    Assert.Pass(Format('Found request matching %s', [Matcher.ToString]))
  else
    Assert.Fail(Format('Expected to find request matching %s', [Matcher.ToString]));
end;

function TWebMockAssertion.WithBody(const APattern: TRegEx): TWebMockAssertion;
begin
  Matcher.Body := TWebMockStringRegExMatcher.Create(APattern);

  Result := Self;
end;

function TWebMockAssertion.WithHeader(const AName,
  AValue: string): TWebMockAssertion;
begin
  Matcher.Headers.AddOrSetValue(
    AName,
    TWebMockStringWildcardMatcher.Create(AValue)
  );

  Result := Self;
end;

function TWebMockAssertion.WithBody(const AContent: string): TWebMockAssertion;
begin
  Matcher.Body := TWebMockStringWildcardMatcher.Create(AContent);

  Result := Self;
end;

function TWebMockAssertion.WithHeader(const AName: string; const APattern: TRegEx): TWebMockAssertion;
begin
  Matcher.Headers.AddOrSetValue(
    AName,
    TWebMockStringRegExMatcher.Create(APattern)
  );

  Result := Self;
end;

function TWebMockAssertion.WithHeaders(
  const AHeaders: TStringList): TWebMockAssertion;
var
  I: Integer;
begin
  for I := 0 to AHeaders.Count - 1 do
    WithHeader(AHeaders.Names[I], AHeaders.ValueFromIndex[I]);

  Result := Self;
end;

end.
