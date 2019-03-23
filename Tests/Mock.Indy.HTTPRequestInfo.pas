unit Mock.Indy.HTTPRequestInfo;

interface

uses
  IdCustomHTTPServer;

type
  TMockIdHTTPRequestInfo = class(TIdHTTPRequestInfo)
  public
    constructor Mock(ACommand: string = 'GET'; AURI: string = '*');
  end;

implementation

{ TMockIdHTTPRequestInfo }

constructor TMockIdHTTPRequestInfo.Mock(ACommand: string = 'GET';
  AURI: string = '*');
begin
  inherited Create(nil);
  FCommand := ACommand;
  FDocument := AURI;
end;

end.
