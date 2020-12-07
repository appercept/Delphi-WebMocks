{******************************************************************************}
{                                                                              }
{           Delphi-WebMocks                                                    }
{                                                                              }
{           Copyright (c) 2019-2020 Richard Hatherall                          }
{                                                                              }
{           richard@appercept.com                                              }
{           https://appercept.com                                              }
{                                                                              }
{******************************************************************************}
{                                                                              }
{   Licensed under the Apache License, Version 2.0 (the "License");            }
{   you may not use this file except in compliance with the License.           }
{   You may obtain a copy of the License at                                    }
{                                                                              }
{       http://www.apache.org/licenses/LICENSE-2.0                             }
{                                                                              }
{   Unless required by applicable law or agreed to in writing, software        }
{   distributed under the License is distributed on an "AS IS" BASIS,          }
{   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   }
{   See the License for the specific language governing permissions and        }
{   limitations under the License.                                             }
{                                                                              }
{******************************************************************************}

unit WebMock.HTTP.RequestMatcher;

interface

uses
  IdCustomHTTPServer,
  IdHeaderList,
  System.Classes,
  System.Generics.Collections,
  System.RegularExpressions,
  WebMock.HTTP.Messages,
  WebMock.StringMatcher;

type
  IWebMockHTTPRequestMatcherBuilder = interface(IInterface)
    ['{47AE1CA8-9395-4B80-AD6F-5F0A7017ED7D}']
    function WithBody(const AContent: string): IWebMockHTTPRequestMatcherBuilder; overload;
    function WithBody(const APattern: TRegEx): IWebMockHTTPRequestMatcherBuilder; overload;
    function WithHeader(const AName, AValue: string): IWebMockHTTPRequestMatcherBuilder; overload;
    function WithHeader(const AName: string; APattern: TRegEx): IWebMockHTTPRequestMatcherBuilder; overload;
    function WithHeaders(const AHeaders: TStrings): IWebMockHTTPRequestMatcherBuilder;
    function WithQueryParam(const AName, AValue: string): IWebMockHTTPRequestMatcherBuilder;
  end;

  TWebMockHTTPRequestMatcher = class(TInterfacedObject, IWebMockHTTPRequestMatcherBuilder)
  public type

    TBuilder = class(TInterfacedObject, IWebMockHTTPRequestMatcherBuilder)
    private
      FMatcher: TWebMockHTTPRequestMatcher;
      property Matcher: TWebMockHTTPRequestMatcher read FMatcher;
    public
      constructor Create(const AMatcher: TWebMockHTTPRequestMatcher);

      { IWebMockHTTPRequestMatcherBuilder }
      function WithBody(const AContent: string): IWebMockHTTPRequestMatcherBuilder; overload;
      function WithBody(const APattern: TRegEx): IWebMockHTTPRequestMatcherBuilder; overload;
      function WithHeader(const AName, AValue: string): IWebMockHTTPRequestMatcherBuilder; overload;
      function WithHeader(const AName: string; APattern: TRegEx): IWebMockHTTPRequestMatcherBuilder; overload;
      function WithHeaders(const AHeaders: TStrings): IWebMockHTTPRequestMatcherBuilder;
      function WithQueryParam(const AName, AValue: string): IWebMockHTTPRequestMatcherBuilder;
    end;

  private
    FContent: IStringMatcher;
    FHeaders: TDictionary<string, IStringMatcher>;
    FQueryParams: TDictionary<string, IStringMatcher>;
    FHTTPMethod: string;
    FURIMatcher: IStringMatcher;
    FBuilder: TBuilder;
    function ExtractDocumentPath(const AURI: string): string;
    function ExtractURIQueryParams(const AURI: string): TDictionary<string, string>;
    function DocumentMatches(const AURI: string): Boolean;
    function HeadersMatches(AHeaders: TStrings): Boolean;
    function QueryParamsMatches(const AURI: string): Boolean;
    function HTTPMethodMatches(AHTTPMethod: string): Boolean;
    function StreamToString(AStream: TStream): string;
  public
    constructor Create(AURI: string; AHTTPMethod: string = 'GET'); overload;
    constructor Create(AURIPattern: TRegEx; AHTTPMethod: string = 'GET'); overload;
    destructor Destroy; override;
    function IsMatch(ARequest: IWebMockHTTPRequest): Boolean;
    function ToString: string; override;
    property Body: IStringMatcher read FContent write FContent;
    property Builder: TBuilder read FBuilder implements IWebMockHTTPRequestMatcherBuilder;
    property Headers: TDictionary<string, IStringMatcher> read FHeaders;
    property QueryParams: TDictionary<string, IStringMatcher> read FQueryParams;
    property HTTPMethod: string read FHTTPMethod write FHTTPMethod;
    property URIMatcher: IStringMatcher read FURIMatcher;
  end;

implementation

{ TWebMockHTTPRequestMatcher }

uses
  System.NetEncoding,
  System.SysUtils,
  WebMock.StringWildcardMatcher,
  WebMock.StringAnyMatcher,
  WebMock.StringRegExMatcher;

constructor TWebMockHTTPRequestMatcher.Create(AURI: string;
  AHTTPMethod: string = 'GET');
begin
  inherited Create;
  FBuilder := TBuilder.Create(Self);
  FContent := TWebMockStringAnyMatcher.Create;
  FHeaders := TDictionary<string, IStringMatcher>.Create;
  FQueryParams := TDictionary<string, IStringMatcher>.Create;
  FURIMatcher := TWebMockStringWildcardMatcher.Create(AURI);
  FHTTPMethod := AHTTPMethod;
end;

constructor TWebMockHTTPRequestMatcher.Create(AURIPattern: TRegEx;
  AHTTPMethod: string = 'GET');
begin
  inherited Create;
  FBuilder := TBuilder.Create(Self);
  FContent := TWebMockStringAnyMatcher.Create;
  FHeaders := TDictionary<string, IStringMatcher>.Create;
  FQueryParams := TDictionary<string, IStringMatcher>.Create;
  FURIMatcher := TWebMockStringRegExMatcher.Create(AURIPattern);
  FHTTPMethod := AHTTPMethod;
end;

destructor TWebMockHTTPRequestMatcher.Destroy;
begin
  FQueryParams.Free;
  FHeaders.Free;
  inherited;
end;

function TWebMockHTTPRequestMatcher.DocumentMatches(
  const AURI: string): Boolean;
begin
  Result := URIMatcher.IsMatch(ExtractDocumentPath(AURI));
end;

function TWebMockHTTPRequestMatcher.ExtractDocumentPath(
  const AURI: string): string;
var
  LQuestionPos: Integer;
begin
  LQuestionPos := AURI.IndexOf('?');
  if LQuestionPos > 0 then
    Result := AURI.Substring(0, LQuestionPos)
  else
    Result := AURI;
end;

function TWebMockHTTPRequestMatcher.ExtractURIQueryParams(const AURI: string): TDictionary<string, string>;
var
  LQuestionPos: Integer;
  LQueryString, LQueryPair: string;
  LQueryPairs, LQueryParts: TArray<string>;
begin
  Result := TDictionary<string, string>.Create;

  LQuestionPos := AURI.IndexOf('?');
  if LQuestionPos > 0 then
  begin
    LQueryString := AURI.Substring(LQuestionPos + 1, AURI.Length - 1);
    LQueryPairs := LQueryString.Split(['&']);
    for LQueryPair in LQueryPairs do
    begin
      LQueryParts := LQueryPair.Split(['='], 2);
      Result.Add(TNetEncoding.URL.Decode(LQueryParts[0]), TNetEncoding.URL.Decode(LQueryParts[1]));
    end;
  end
end;

function TWebMockHTTPRequestMatcher.HeadersMatches(
  AHeaders: TStrings): Boolean;
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

function TWebMockHTTPRequestMatcher.HTTPMethodMatches
  (AHTTPMethod: string): Boolean;
begin
  Result := (HTTPMethod = '*') or (AHTTPMethod = HTTPMethod);
end;

function TWebMockHTTPRequestMatcher.IsMatch(ARequest: IWebMockHTTPRequest): Boolean;
begin
  Result := HTTPMethodMatches(ARequest.Method) and
    DocumentMatches(ARequest.RequestURI) and
    QueryParamsMatches(ARequest.RequestURI) and
    HeadersMatches(ARequest.Headers) and
    Body.IsMatch(StreamToString(ARequest.Body));
end;

function TWebMockHTTPRequestMatcher.QueryParamsMatches(
  const AURI: string): Boolean;
var
  LParam: TPair<string, IStringMatcher>;
  LExtractedParams: TDictionary<string, string>;
begin
  if QueryParams.Count = 0 then
    Exit(True);

  LExtractedParams := ExtractURIQueryParams(AURI);
  for LParam in QueryParams do
  begin
    if not LExtractedParams.ContainsKey(LParam.Key) then
      Exit(False);

    if not LParam.Value.IsMatch(LExtractedParams[LParam.Key]) then
      Exit(False);
  end;

  Result := True;
end;

function TWebMockHTTPRequestMatcher.StreamToString(AStream: TStream): string;
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
    LStringStream.CopyFrom(AStream, 0);
    Result := LStringStream.DataString;
  finally
    LStringStream.Free;
  end;
end;

function TWebMockHTTPRequestMatcher.ToString: string;
begin
  Result := Format('%s' + ^I + '%s', [HTTPMethod, URIMatcher.ToString]);
end;

{ TWebMockHTTPRequestMatcher.TBuilder }

function TWebMockHTTPRequestMatcher.TBuilder.WithBody(
  const AContent: string): IWebMockHTTPRequestMatcherBuilder;
begin
  Matcher.Body := TWebMockStringWildcardMatcher.Create(AContent);

  Result := Self;
end;

constructor TWebMockHTTPRequestMatcher.TBuilder.Create(
  const AMatcher: TWebMockHTTPRequestMatcher);
begin
  inherited Create;
  FMatcher := AMatcher;
end;

function TWebMockHTTPRequestMatcher.TBuilder.WithBody(
  const APattern: TRegEx): IWebMockHTTPRequestMatcherBuilder;
begin
  Matcher.Body := TWebMockStringRegExMatcher.Create(APattern);

  Result := Self;
end;

function TWebMockHTTPRequestMatcher.TBuilder.WithHeader(const AName,
  AValue: string): IWebMockHTTPRequestMatcherBuilder;
begin
  Matcher.Headers.AddOrSetValue(
    AName,
    TWebMockStringWildcardMatcher.Create(AValue)
  );

  Result := Self;
end;

function TWebMockHTTPRequestMatcher.TBuilder.WithHeader(const AName: string;
  APattern: TRegEx): IWebMockHTTPRequestMatcherBuilder;
begin
  Matcher.Headers.AddOrSetValue(
    AName,
    TWebMockStringRegExMatcher.Create(APattern)
  );

  Result := Self;
end;


function TWebMockHTTPRequestMatcher.TBuilder.WithHeaders(
  const AHeaders: TStrings): IWebMockHTTPRequestMatcherBuilder;
var
  I: Integer;
begin
  for I := 0 to AHeaders.Count - 1 do
    WithHeader(AHeaders.Names[I], AHeaders.ValueFromIndex[I]);

  Result := Self;
end;

function TWebMockHTTPRequestMatcher.TBuilder.WithQueryParam(const AName,
  AValue: string): IWebMockHTTPRequestMatcherBuilder;
begin
  Matcher.QueryParams.AddOrSetValue(
    AName,
    TWebMockStringWildcardMatcher.Create(AValue)
  );

  Result := Self;
end;

end.
