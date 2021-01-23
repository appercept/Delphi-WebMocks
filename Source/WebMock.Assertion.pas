{******************************************************************************}
{                                                                              }
{           Delphi-WebMocks                                                    }
{                                                                              }
{           Copyright (c) 2019-2021 Richard Hatherall                          }
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
  System.Classes,
  System.RegularExpressions,
  System.Rtti,
  WebMock.HTTP.Messages,
  WebMock.HTTP.RequestMatcher;

type
  TWebMockAssertion = class(TObject)
  private
    FMatcher: IWebMockHTTPRequestMatcher;
    FHistory: IInterfaceList;
    function MatchesHistory: Boolean;
  public
    constructor Create(const AHistory: IInterfaceList);
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
    function WithFormData(const AName, AValue: string): TWebMockAssertion; overload;
    function WithFormData(const AName: string; const APattern: TRegEx): TWebMockAssertion; overload;
    function WithJSON(const APath: string; AValue: Boolean): TWebMockAssertion; overload;
    function WithJSON(const APath: string; AValue: Float64): TWebMockAssertion; overload;
    function WithJSON(const APath: string; AValue: Integer): TWebMockAssertion; overload;
    function WithJSON(const APath: string; AValue: string): TWebMockAssertion; overload;
    procedure WasRequested;
    procedure WasNotRequested;
    property History: IInterfaceList read FHistory;
    property Matcher: IWebMockHTTPRequestMatcher read FMatcher;
  end;

implementation

{ TWebMockAssertion }

uses
  System.SysUtils,
  WebMock.FormDataMatcher,
  WebMock.StringRegExMatcher,
  WebMock.StringWildcardMatcher;

constructor TWebMockAssertion.Create(const AHistory: IInterfaceList);
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
  I: Integer;
  LRequest: IWebMockHTTPRequest;
begin
  Result := False;

  for I := 0 to History.Count - 1 do
  begin
    LRequest := History[I] as IWebMockHTTPRequest;

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
  try
    if MatchesHistory then
      Assert.Fail(Format('Found request matching %s', [Matcher.ToString]))
    else
      Assert.Pass(Format('Did not find request matching %s', [Matcher.ToString]));
  finally
    Free;
  end;
end;

procedure TWebMockAssertion.WasRequested;
begin
  try
    if MatchesHistory then
      Assert.Pass(Format('Found request matching %s', [Matcher.ToString]))
    else
      Assert.Fail(Format('Expected to find request matching %s', [Matcher.ToString]));
  finally
    Free;
  end;
end;

function TWebMockAssertion.WithBody(const APattern: TRegEx): TWebMockAssertion;
begin
  Matcher.Builder.WithBody(APattern);

  Result := Self;
end;

function TWebMockAssertion.WithFormData(const AName: string;
  const APattern: TRegEx): TWebMockAssertion;
begin
  Matcher.Builder.WithFormData(AName, APattern);

  Result := Self;
end;

function TWebMockAssertion.WithFormData(const AName,
  AValue: string): TWebMockAssertion;
begin
  Matcher.Builder.WithFormData(AName, AValue);

  Result := Self;
end;

function TWebMockAssertion.WithHeader(const AName,
  AValue: string): TWebMockAssertion;
begin
  Matcher.Builder.WithHeader(AName, AValue);

  Result := Self;
end;

function TWebMockAssertion.WithBody(const AContent: string): TWebMockAssertion;
begin
  Matcher.Builder.WithBody(AContent);

  Result := Self;
end;

function TWebMockAssertion.WithHeader(const AName: string; const APattern: TRegEx): TWebMockAssertion;
begin
  Matcher.Builder.WithHeader(AName, APattern);

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

function TWebMockAssertion.WithJSON(const APath: string;
  AValue: Boolean): TWebMockAssertion;
begin
  Matcher.Builder.WithJSON(APath, AValue);

  Result := Self;
end;

function TWebMockAssertion.WithJSON(const APath: string;
  AValue: Float64): TWebMockAssertion;
begin
  Matcher.Builder.WithJSON(APath, AValue);

  Result := Self;
end;

function TWebMockAssertion.WithJSON(const APath: string;
  AValue: Integer): TWebMockAssertion;
begin
  Matcher.Builder.WithJSON(APath, AValue);

  Result := Self;
end;

function TWebMockAssertion.WithJSON(const APath: string;
  AValue: string): TWebMockAssertion;
begin
  Matcher.Builder.WithJSON(APath, AValue);

  Result := Self;
end;

function TWebMockAssertion.WithQueryParam(const AName: string;
  const APattern: TRegEx): TWebMockAssertion;
begin
  Matcher.Builder.WithQueryParam(AName, APattern);

  Result := Self;
end;

function TWebMockAssertion.WithQueryParam(const AName,
  AValue: string): TWebMockAssertion;
begin
  Matcher.Builder.WithQueryParam(AName, AValue);

  Result := Self;
end;

end.
