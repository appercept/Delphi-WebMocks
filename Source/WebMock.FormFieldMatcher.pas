{******************************************************************************}
{                                                                              }
{           Delphi-WebMocks                                                    }
{                                                                              }
{           Copyright (c) 2020 Richard Hatherall                               }
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

unit WebMock.FormFieldMatcher;

interface

uses
  System.Classes,
  System.Net.URLClient,
  System.RegularExpressions,
  WebMock.StringMatcher;

type
  TWebMockFormFieldMatcher = class(TInterfacedObject, IStringMatcher)
  private
    FName: string;
    FValueMatcher: IStringMatcher;
    function ParseFormField(const AValue: string): TNameValuePair;
  public
    constructor Create(const AName: string; const AValue: string = '*'); overload;
    constructor Create(const AName: string; const APattern: TRegEx); overload;
    function IsMatch(AValue: string): Boolean;
    function ToString: string; override;
    property Name: string read FName;
    property ValueMatcher: IStringMatcher read FValueMatcher;
  end;

implementation

uses
  System.NetEncoding,
  System.SysUtils,
  WebMock.StringRegExMatcher,
  WebMock.StringWildcardMatcher;

{ TWebMockFormFieldMatcher }

constructor TWebMockFormFieldMatcher.Create(const AName, AValue: string);
begin
  inherited Create;
  FName := AName;
  FValueMatcher := TWebMockStringWildcardMatcher.Create(AValue);
end;

constructor TWebMockFormFieldMatcher.Create(const AName: string;
  const APattern: TRegEx);
begin
  inherited Create;
  FName := AName;
  FValueMatcher := TWebMockStringRegExMatcher.Create(APattern);
end;

function TWebMockFormFieldMatcher.IsMatch(AValue: string): Boolean;
var
  LFormField: TNameValuePair;
begin
  LFormField := ParseFormField(AValue);
  if not Name.Equals(LFormField.Name) then
    Exit(False);

  Result := ValueMatcher.IsMatch(LFormField.Value);
end;

function TWebMockFormFieldMatcher.ParseFormField(
  const AValue: string): TNameValuePair;
var
  LEqualsPos: Integer;
begin
  LEqualsPos := AValue.IndexOf('=');
  if (LEqualsPos > 0) then
  begin
    Result.Name := TNetEncoding.URL.Decode(AValue.Substring(0, LEqualsPos));
    Result.Value := TNetEncoding.URL.Decode(AValue.Substring(LEqualsPos + 1));
  end;
end;

function TWebMockFormFieldMatcher.ToString: string;
begin
  Result := Format('%s=%s', [Name, ValueMatcher.ToString]);
end;

end.
