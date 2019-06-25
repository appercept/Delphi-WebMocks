unit TestHelpers;

interface

uses
  Delphi.WebMock.Tests.Client,
  System.Rtti;

type
  WebClient = TWebMockTestsClient;

function FixturePath(const AFileName: string): string;
function GetPropertyValue(AObject: TObject; APropertyName: string): TValue;
procedure SetPropertyValue(AObject: TObject; APropertyName: string;
  AValue: TValue);

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

end.
