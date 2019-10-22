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
  System.SysUtils;

function FixturePath(const AFileName: string): string;
begin
  Result := Format('../../Fixtures/%s', [AFileName]);
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
