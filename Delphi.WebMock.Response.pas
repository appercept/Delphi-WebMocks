unit Delphi.WebMock.Response;

interface

uses
  Delphi.WebMock.ResponseContentSource, Delphi.WebMock.ResponseStatus,
  System.Classes;

type
  TWebMockResponse = class(TObject)
  private
    FContentSource: IWebMockResponseContentSource;
    FHeaders: TStringList;
    FStatus: TWebMockResponseStatus;
  public
    constructor Create(const AStatus: TWebMockResponseStatus = nil);
    destructor Destroy; override;
    function ToString: string; override;
    function WithContent(const AContent: string;
      const AContentType: string = 'text/plain; charset=utf-8'): TWebMockResponse;
    function WithContentFile(const AFileName: string;
      const AContentType: string = ''): TWebMockResponse;
    function WithHeader(AHeaderName, AHeaderValue: string): TWebMockResponse;
    function WithHeaders(AHeaders: TStrings): TWebMockResponse;
    property ContentSource: IWebMockResponseContentSource read FContentSource write FContentSource;
    property Headers: TStringList read FHeaders write FHeaders;
    property Status: TWebMockResponseStatus read FStatus write FStatus;
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
  FContentSource := TWebMockResponseContentString.Create;
  FHeaders := TStringList.Create;
  if Assigned(AStatus) then
    FStatus := AStatus
  else
    FStatus := TWebMockResponseStatus.OK;
end;

destructor TWebMockResponse.Destroy;
begin
  FHeaders.Free;
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

function TWebMockResponse.WithHeader(AHeaderName,
  AHeaderValue: string): TWebMockResponse;
begin
  Headers.Values[AHeaderName] := AHeaderValue;

  Result := Self;
end;

function TWebMockResponse.WithHeaders(AHeaders: TStrings): TWebMockResponse;
begin
  Headers.AddStrings(AHeaders);

  Result := Self;
end;

end.
