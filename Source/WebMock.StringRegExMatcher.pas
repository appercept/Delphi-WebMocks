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

unit WebMock.StringRegExMatcher;

interface

uses
  System.RegularExpressions,
  WebMock.StringMatcher;

type
  TWebMockStringRegExMatcher = class(TInterfacedObject, IStringMatcher)
  private
    FRegEx: TRegEx;
  public
    constructor Create(ARegEx: TRegEx);
    function IsMatch(AValue: string): Boolean;
    function ToString: string; reintroduce;
    property RegEx: TRegEx read FRegEx;
  end;

implementation

{ TWebMockStringRegExMatcher }

constructor TWebMockStringRegExMatcher.Create(ARegEx: TRegEx);
begin
  inherited Create;
  FRegEx := ARegEx;
end;

function TWebMockStringRegExMatcher.IsMatch(AValue: string): Boolean;
begin
  Result := RegEx.IsMatch(AValue);
end;

function TWebMockStringRegExMatcher.ToString: string;
begin
  Result := 'Regular Expression';
end;

end.
