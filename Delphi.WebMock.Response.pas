unit Delphi.WebMock.Response;

interface

uses Delphi.WebMock.ResponseContentSource, Delphi.WebMock.ResponseStatus;

type
  TWebMockResponse = class(TObject)
  private
    FStatus: TWebMockResponseStatus;
    FContentSource: IWebMockResponseContentSource;
  public
    constructor Create(const AStatus: TWebMockResponseStatus = nil);
    destructor Destroy; override;
    function ToString: string; override;
    function WithContent(const AContent: string;
      const AContentType: string = 'text/plain; charset=utf-8'): TWebMockResponse;
    function WithContentFile(const AFileName: string;
      const AContentType: string = ''): TWebMockResponse;
    property Status: TWebMockResponseStatus read FStatus write FStatus;
    property ContentSource: IWebMockResponseContentSource read FContentSource write FContentSource;
  end;

implementation

{ TWebMockResponse }

uses
  Delphi.WebMock.ResponseContentFile, Delphi.WebMock.ResponseContentString,
  System.SysUtils;

constructor TWebMockResponse.Create(const AStatus
  : TWebMockResponseStatus = nil);
begin
  inherited Create;
  if Assigned(AStatus) then
    FStatus := AStatus
  else
    FStatus := TWebMockResponseStatus.OK;
  FContentSource := TWebMockResponseContentString.Create;
end;

destructor TWebMockResponse.Destroy;
begin
  FStatus.Free;
  inherited;
end;

function TWebMockResponse.ToString: string;
begin
  Result := Format('%s', [Status.ToString]);
end;

function TWebMockResponse.WithContent(const AContent: string;
  const AContentType: string = 'text/plain; charset=utf-8'): TWebMockResponse;
begin
  ContentSource := TWebMockResponseContentString.Create(AContent, AContentType);

  Result := Self;
end;

function TWebMockResponse.WithContentFile(const AFileName: string;
  const AContentType: string = ''): TWebMockResponse;
begin
  ContentSource := TWebMockResponseContentFile.Create(AFileName, AContentType);

  Result := Self;
end;

end.
