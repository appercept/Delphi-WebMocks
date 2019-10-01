unit Mock.Indy.HTTPRequestInfo;

interface

uses
  IdCustomHTTPServer;

type
  TMockIdHTTPRequestInfo = class(TIdHTTPRequestInfo)
  public
    constructor Mock(ACommand: string = 'GET'; AURI: string = '*');
    property RawHeaders;
    property RawHTTPCommand: string read FRawHTTPCommand write FRawHTTPCommand;
  end;

implementation

{ TMockIdHTTPRequestInfo }

uses
  System.SysUtils;

constructor TMockIdHTTPRequestInfo.Mock(ACommand: string = 'GET';
  AURI: string = '*');
begin
  inherited Create(nil);
  FCommand := ACommand;
  FDocument := AURI;
  FVersion := 'HTTP/1.1';
  FRawHTTPCommand := Format('%s %s HTTP/1.1', [Command, Document]);
  FURI := AURI;
end;

end.
