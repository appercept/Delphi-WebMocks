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

unit TestHelpers;

interface

uses
  System.Classes, System.Net.HttpClient, System.Net.URLClient, System.Rtti;

function FixturePath(const AFileName: string): string;
function GetPropertyValue(AObject: TObject; APropertyName: string): TValue;
procedure SetPropertyValue(AObject: TObject; APropertyName: string;
  AValue: TValue);
function NetHeadersToStrings(ANetHeaders: TNetHeaders): TStringList;

var
  WebClient: THTTPClient;

implementation

uses
  System.IOUtils,
  System.SysUtils;

function FixturePath(const AFileName: string): string;
var
  LFixtureDir: string;
begin
  LFixtureDir := TPath.Combine(TDirectory.GetCurrentDirectory, 'Fixtures');
  Result := TPath.Combine(LFixtureDir, AFileName);
end;

function GetPropertyValue(AObject: TObject; APropertyName: string): TValue;
var
  LContext: TRttiContext;
  LType: TRttiType;
  LProperty: TRttiProperty;
begin
  LType := LContext.GetType(AObject.ClassType);
  LProperty := LType.GetProperty(APropertyName);
  Result := LProperty.GetValue(AObject);
end;

procedure SetPropertyValue(AObject: TObject; APropertyName: string;
  AValue: TValue);
var
  LContext: TRttiContext;
  LType: TRttiType;
  LProperty: TRttiProperty;
begin
  LType := LContext.GetType(AObject.ClassType);
  LProperty := LType.GetProperty(APropertyName);
  LProperty.SetValue(AObject, AValue);
end;

function NetHeadersToStrings(ANetHeaders: TNetHeaders): TStringList;
var
  LHeaders: TStringList;
  LHeader: TNetHeader;
begin
  LHeaders := TStringList.Create;
  for LHeader in ANetHeaders do
  begin
    LHeaders.AddPair(LHeader.Name, LHeader.Value);
  end;
  Result := LHeaders;
end;

initialization
  WebClient := THTTPClient.Create;
finalization
  WebClient.Free;
end.
