unit Delphi.WebMock.Response;

interface

uses Delphi.WebMock.ResponseStatus;

type
  TWebMockResponse = class(TObject)
  private
    FStatus: TWebMockResponseStatus;
  public
    constructor Create(const AStatus: TWebMockResponseStatus = nil);
    destructor Destroy; override;
    function ToString: string; override;
    property Status: TWebMockResponseStatus read FStatus write FStatus;
  end;

implementation

{ TWebMockResponse }

uses
  System.SysUtils;

constructor TWebMockResponse.Create(const AStatus
  : TWebMockResponseStatus = nil);
begin
  inherited Create;
  if Assigned(AStatus) then
    FStatus := AStatus
  else
    FStatus := TWebMockResponseStatus.OK;
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

end.
