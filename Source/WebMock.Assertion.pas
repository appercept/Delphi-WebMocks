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

unit WebMock.Assertion;

interface

uses
  DUnitX.TestFramework,
  System.Classes, System.Generics.Collections, System.RegularExpressions,
  WebMock.HTTP.Messages, WebMock.HTTP.RequestMatcher;

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
    function WithQueryParam(const AName, AValue: string): TWebMockAssertion; overload;
    function WithQueryParam(const AName: string; const APattern: TRegEx): TWebMockAssertion; overload;
    procedure WasRequested;
    procedure WasNotRequested;
    property History: TList<IWebMockHTTPRequest> read FHistory;
    property Matcher: TWebMockHTTPRequestMatcher read FMatcher;
  end;

implementation

{ TWebMockAssertion }

uses
  System.SysUtils,
  WebMock.StringRegExMatcher, WebMock.StringWildcardMatcher;

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

function TWebMockAssertion.WithQueryParam(const AName: string;
  const APattern: TRegEx): TWebMockAssertion;
begin
  Matcher.QueryParams.AddOrSetValue(
    AName,
    TWebMockStringRegExMatcher.Create(APattern)
  );

  Result := Self;
end;

function TWebMockAssertion.WithQueryParam(const AName,
  AValue: string): TWebMockAssertion;
begin
  Matcher.QueryParams.AddOrSetValue(
    AName,
    TWebMockStringWildcardMatcher.Create(AValue)
  );

  Result := Self;
end;

end.
