unit Delphi.WebMock.Tests.Client;

interface

uses
  IdHTTP;

type
  TWebMockTestsClient = class(TObject)
  public
    class function Get(const AURL: string): TIdHTTPResponse;
    class function Post(const AURL: string; const ARequestContent: string)
      : TIdHTTPResponse;
  end;

implementation

uses
  IdException,
  System.Classes;

{ TWebMockTestsClient }

class function TWebMockTestsClient.Get(const AURL: string): TIdHTTPResponse;
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

class function TWebMockTestsClient.Post(const AURL, ARequestContent: string)
  : TIdHTTPResponse;
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

end.
