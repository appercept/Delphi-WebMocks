unit TestHelpers;

interface

uses
  IdHTTP,
  IdLogDebug;

function Get(const AURL: string): TIdHTTPResponse;

implementation

function Get(const AURL: string): TIdHTTPResponse;
var
  LClient: TIdHTTP;
begin
  LClient := TIdHTTP.Create;
  LClient.Get(AURL);
  Result := LClient.Response;
end;

end.
