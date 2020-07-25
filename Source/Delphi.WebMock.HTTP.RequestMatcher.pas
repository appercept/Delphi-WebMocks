{******************************************************************************}
{                                                                              }
{           Delphi-WebMocks                                                    }
{                                                                              }
{           Copyright (c) 2019 Richard Hatherall                               }
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

unit Delphi.WebMock.HTTP.RequestMatcher;

interface

uses
  Delphi.WebMock.HTTP.Messages, Delphi.WebMock.StringMatcher,
  IdCustomHTTPServer, IdHeaderList,
  System.Classes, System.Generics.Collections, System.RegularExpressions;

type
  TWebMockHTTPRequestMatcher = class(TObject)
  private
    FContent: IStringMatcher;
    FHeaders: TDictionary<string, IStringMatcher>;
    FHTTPMethod: string;
    FURIMatcher: IStringMatcher;
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
    property Headers: TDictionary<string, IStringMatcher> read FHeaders;
    property HTTPMethod: string read FHTTPMethod write FHTTPMethod;
    property URIMatcher: IStringMatcher read FURIMatcher;
  end;

implementation

{ TWebMockHTTPRequestMatcher }

uses
  Delphi.WebMock.StringWildcardMatcher, Delphi.WebMock.StringAnyMatcher,
  Delphi.WebMock.StringRegExMatcher,
  System.SysUtils;

constructor TWebMockHTTPRequestMatcher.Create(AURI: string;
  AHTTPMethod: string = 'GET');
begin
  inherited Create;
  FContent := TWebMockStringAnyMatcher.Create;
  FHeaders := TDictionary<string, IStringMatcher>.Create;
  FURIMatcher := TWebMockStringWildcardMatcher.Create(AURI);
  FHTTPMethod := AHTTPMethod;
end;

constructor TWebMockHTTPRequestMatcher.Create(AURIPattern: TRegEx;
  AHTTPMethod: string = 'GET');
begin
  inherited Create;
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

end.
