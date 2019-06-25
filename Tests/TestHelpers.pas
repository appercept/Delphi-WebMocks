unit TestHelpers;

interface

uses
  IdHTTP,
  IdLogDebug,
  System.Rtti;

function Get(const AURL: string): TIdHTTPResponse;
function Post(const AURL: string; const ARequestContent: string): TIdHTTPResponse;

function GetPropertyValue(AObject: TObject; APropertyName: string): TValue;
procedure SetPropertyValue(AObject: TObject; APropertyName: string;
  AValue: TValue);

implementation

uses
  IdException,
  System.Classes;

function Get(const AURL: string): TIdHTTPResponse;
var
  LClient: TIdHTTP;
  LResponseStream: TStream;
begin
  LClient := TIdHTTP.Create;
  LResponseStream := TMemoryStream.Create;
  try
    LClient.Get(AURL, LResponseStream);
    LClient.Response.ContentStream.Position := 0;
  except
    on E: EIdException do
  end;
  Result := LClient.Response;
end;

function Post(const AURL: string; const ARequestContent: string): TIdHTTPResponse;
var
  LClient: TIdHTTP;
  LResponseStream: TStream;
begin
  LClient := TIdHTTP.Create;
  LResponseStream := TMemoryStream.Create;
  try
    LClient.Post(AURL, TStringStream.Create(ARequestContent), LResponseStream);
    LClient.Response.ContentStream.Position := 0;
  except
    on E: EIdException do
  end;
  Result := LClient.Response;
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
