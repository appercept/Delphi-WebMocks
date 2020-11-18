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

unit WebMock.StringWildcardMatcher;

interface

uses
  WebMock.StringMatcher;

type
  TWebMockStringWildcardMatcher = class(TInterfacedObject, IStringMatcher)
  private
    FValue: string;
  public
    constructor Create(const AValue: string = '*');
    function IsMatch(AValue: string): Boolean;
    function ToString: string; override;
    property Value: string read FValue;
  end;

implementation

{ TWebMockStringWildcardMatcher }

constructor TWebMockStringWildcardMatcher.Create(const AValue: string = '*');
begin
  inherited Create;
  FValue := AValue;
end;

function TWebMockStringWildcardMatcher.IsMatch(AValue: string): Boolean;
begin
  Result := (Value = '*') or (Value = AValue);
end;

function TWebMockStringWildcardMatcher.ToString: string;
begin
  Result := Value;
end;

end.
