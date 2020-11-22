﻿{******************************************************************************}
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
    end;

  private
    FContent: IStringMatcher;
    FHeaders: TDictionary<string, IStringMatcher>;
    FHTTPMethod: string;
    FURIMatcher: IStringMatcher;
    FBuilder: TBuilder;
    function HeadersMatches(
  AHeaders: TStrings): Boolean;
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
    property HTTPMethod: string read FHTTPMethod write FHTTPMethod;
    property URIMatcher: IStringMatcher read FURIMatcher;
  end;

implementation

{ TWebMockHTTPRequestMatcher }

uses
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
  FURIMatcher := TWebMockStringRegExMatcher.Create(AURIPattern);
  FHTTPMethod := AHTTPMethod;
end;

destructor TWebMockHTTPRequestMatcher.Destroy;
begin
  FHeaders.Free;
  inherited;
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
    URIMatcher.IsMatch(ARequest.RequestURI) and
    HeadersMatches(ARequest.Headers) and
    Body.IsMatch(StreamToString(ARequest.Body));
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

end.
