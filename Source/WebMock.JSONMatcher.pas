{******************************************************************************}
{                                                                              }
{           Delphi-WebMocks                                                    }
{                                                                              }
{           Copyright (c) 2021 Richard Hatherall                               }
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

unit WebMock.JSONMatcher;

interface

uses
  System.Classes,
  System.JSON,
  WebMock.StringMatcher;

type
  IWebMockJSONValueMatcher = interface(IInterface)
    ['{3B642735-9B0B-4923-A79B-51A04F284B6C}']
    function IsMatch(const AJSON: TJSONValue): Boolean;
  end;

  TWebMockJSONValueMatcher<T> = class(TInterfacedObject, IWebMockJSONValueMatcher)
  private
    FPath: string;
    FValue: T;
  public
    constructor Create(const APath: string; const AValue: T);
    property Path: string read FPath;
    property Value: T read FValue;

    { IWebMockJSONValueMatcher }
    function IsMatch(const AJSON: TJSONValue): Boolean;
  end;

  TWebMockJSONMatcher = class(TInterfacedObject, IStringMatcher)
  private
    FValueMatchers: TInterfaceList; // IWebMockJSONValueMatcher
    function GetValueMatchers: TInterfaceList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add<T>(const APath: string; const AValue: T);
    property ValueMatchers: TInterfaceList read GetValueMatchers;

    { IStringMatcher }
    function IsMatch(AValue: string): Boolean;
    function ToString: string; override;
  end;

implementation

uses
  System.Generics.Defaults;

{ TWebMockJSONMatcher }

procedure TWebMockJSONMatcher.Add<T>(const APath: string; const AValue: T);
var
  LMatcher: IWebMockJSONValueMatcher;
begin
  LMatcher := TWebMockJSONValueMatcher<T>.Create(APath, AValue);
  ValueMatchers.Add(LMatcher);
end;

constructor TWebMockJSONMatcher.Create;
begin
  inherited;
  FValueMatchers := TInterfaceList.Create;
end;

destructor TWebMockJSONMatcher.Destroy;
begin
  FValueMatchers.Free;
  inherited;
end;

function TWebMockJSONMatcher.GetValueMatchers: TInterfaceList;
begin
  Result := FValueMatchers;
end;

function TWebMockJSONMatcher.IsMatch(AValue: string): Boolean;
var
  LJSON: TJSONValue;
  I: Integer;
  LMatcher: IWebMockJSONValueMatcher;
begin
  LJSON := TJSONObject.ParseJSONValue(AValue);
  try
    for I := 0 to ValueMatchers.Count - 1 do
    begin
      LMatcher := ValueMatchers[I] as IWebMockJSONValueMatcher;
      if not LMatcher.IsMatch(LJSON) then
        Exit(False);
    end;
  finally
    LJSON.Free;
  end;

  Result := True;
end;

function TWebMockJSONMatcher.ToString: string;
begin
  Result := '<JSON>';
end;

{ TWebMockJSONValueMatcher<T> }

constructor TWebMockJSONValueMatcher<T>.Create(const APath: string;
  const AValue: T);
begin
  inherited Create;
  FPath := APath;
  FValue := AValue;
end;

function TWebMockJSONValueMatcher<T>.IsMatch(const AJSON: TJSONValue): Boolean;
var
  LValue: T;
begin
  if AJSON.TryGetValue<T>(Path, LValue) then
    Result := TComparer<T>.Default.Compare(LValue, Value) = 0
  else
    Result := False;
end;

end.
