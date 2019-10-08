unit Delphi.WebMock.ResponseContentFile;

interface

uses Delphi.WebMock.ResponseBodySource, IdCustomHTTPServer, System.Classes;

type
  TWebMockResponseContentFile = class(TInterfacedObject, IWebMockResponseBodySource)
  private
    FContentStream: TStream;
    FContentType: string;

    class var FMIMETable: TIdThreadSafeMimeTable;
    class constructor Create;
    class destructor Destroy;

    function GetContentStream: TStream;
    function GetContentType: string;
    function InferContentType(const AFileName: string): string;
    procedure LoadContentFromFile(const AFileName: string);
  public
    constructor Create(const AFileName: string; const AContentType: string = '');
    property ContentStream: TStream read GetContentStream;
    property ContentType: string read GetContentType;
  end;

implementation

uses
  System.SysUtils;

{ TWebMockResponseContentFile }

constructor TWebMockResponseContentFile.Create(const AFileName: string; const AContentType: string = '');
begin
  inherited Create;
  FContentStream := TMemoryStream.Create;
  LoadContentFromFile(AFileName);
  if AContentType.IsEmpty then
    FContentType := InferContentType(AFileName)
  else
    FContentType := AContentType;
end;

class constructor TWebMockResponseContentFile.Create;
begin
  FMIMETable := TIdThreadSafeMimeTable.Create(False);
end;

class destructor TWebMockResponseContentFile.Destroy;
begin
  FMIMETable.Free;
end;

function TWebMockResponseContentFile.GetContentStream: TStream;
begin
  Result := FContentStream;
end;

function TWebMockResponseContentFile.GetContentType: string;
begin
  Result := FContentType;
end;

function TWebMockResponseContentFile.InferContentType(const AFileName: string): string;
begin
  Result := FMIMETable.GetFileMIMEType(AFileName);
end;

procedure TWebMockResponseContentFile.LoadContentFromFile(
  const AFileName: string);
var
  LFileStream: TFileStream;
begin
  if not FileExists(AFileName) then
    Exit;

  LFileStream := TFileStream.Create(AFileName, fmOpenRead);
  FContentStream.CopyFrom(LFileStream, 0);
  LFileStream.Free;
end;

end.
