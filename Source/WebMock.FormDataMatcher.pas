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

unit WebMock.FormDataMatcher;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.RegularExpressions,
  WebMock.StringMatcher;

type
  TWebMockFormDataMatcher = class(TInterfacedObject, IStringMatcher)
  private
    FFieldMatchers: TList<IStringMatcher>;
    function HasMatch(const AFormFields: TArray<string>;
      const AMatcher: IStringMatcher): Boolean;
  public
    constructor Create;
    procedure Add(const AName: string; const AValue: string = '*'); overload;
    procedure Add(const AName: string; const APattern: TRegEx); overload;
    function IsMatch(AValue: string): Boolean;
    function ToString: string; override;
    property FieldMatchers: TList<IStringMatcher> read FFieldMatchers;
  end;

implementation

uses
  System.NetEncoding,
  System.SysUtils,
  WebMock.FormFieldMatcher;

{ TWebMockFormDataMatcher }

procedure TWebMockFormDataMatcher.Add(const AName, AValue: string);
begin
  FieldMatchers.Add(TWebMockFormFieldMatcher.Create(AName, AValue));
end;

procedure TWebMockFormDataMatcher.Add(const AName: string;
  const APattern: TRegEx);
begin
  FieldMatchers.Add(TWebMockFormFieldMatcher.Create(AName, APattern));
end;

constructor TWebMockFormDataMatcher.Create;
begin
  inherited Create;
  FFieldMatchers := TList<IStringMatcher>.Create;
end;

function TWebMockFormDataMatcher.HasMatch(const AFormFields: TArray<string>;
  const AMatcher: IStringMatcher): Boolean;
var
  LField: string;
begin
  for LField in AFormFields do
    if AMatcher.IsMatch(LField) then
      Exit(True);

  Result := False;
end;

function TWebMockFormDataMatcher.IsMatch(AValue: string): Boolean;
var
  LFormFields: TArray<string>;
  LMatcher: IStringMatcher;
begin
  LFormFields := AValue.Split(['&']);
  for LMatcher in FieldMatchers do
    if not HasMatch(LFormFields, LMatcher) then
      Exit(False);

  Result := True;
end;

function TWebMockFormDataMatcher.ToString: string;
var
  LMatcher: IStringMatcher;
begin
  Result := '';
  for LMatcher in FieldMatchers do
  begin
    if Result.Length = 0 then
      Result := LMatcher.ToString
    else
      Result := Result + ' AND ' + LMatcher.ToString;
  end;
end;

end.
