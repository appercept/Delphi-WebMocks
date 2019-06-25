unit Delphi.WebMock.ResponseContentString;

interface

uses Delphi.WebMock.ResponseContentSource, System.Classes;

type
  TWebMockResponseContentString = class(TInterfacedObject,
    IWebMockResponseContentSource)
  private
    FContentStream: TStream;
    FContentString: string;
    FContentType: string;
    procedure SetContentType(const Value: string);
    function GetContentStream: TStream;
  public
    constructor Create(const AContentString: string = '';
      const AContentType: string = 'text/plain; charset=utf-8');
    function GetContentString: string;
    function GetContentType: string;
    property ContentStream: TStream read GetContentStream;
    property ContentString: string read GetContentString write FContentString;
    property ContentType: string read GetContentType write SetContentType;
  end;

implementation

{ TWebMockResponseContentString }

constructor TWebMockResponseContentString.Create(const AContentString
  : string = ''; const AContentType: string = 'text/plain; charset=utf-8');
begin
  inherited Create;
  FContentString := AContentString;
  FContentType := AContentType;
end;

function TWebMockResponseContentString.GetContentType: string;
begin
  Result := FContentType;
end;

procedure TWebMockResponseContentString.SetContentType(const Value: string);
begin
  FContentType := Value;
end;

function TWebMockResponseContentString.GetContentStream: TStream;
begin
  if not Assigned(FContentStream) then
    FContentStream := TStringStream.Create(ContentString);

  Result := FContentStream;
end;

function TWebMockResponseContentString.GetContentString: string;
begin
  Result := FContentString;
end;

end.
