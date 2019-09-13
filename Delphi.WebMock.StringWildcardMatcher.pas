unit Delphi.WebMock.StringWildcardMatcher;

interface

uses
  Delphi.WebMock.StringMatcher;

type
  TWebMockStringWildcardMatcher = class(TInterfacedObject, IStringMatcher)
  private
    FValue: string;
  public
    constructor Create(const AValue: string = '*');
    function IsMatch(AValue: string): Boolean;
    function ToString: string; override;
    property Value: string read FValue;
  end;

implementation

{ TWebMockStringWildcardMatcher }

constructor TWebMockStringWildcardMatcher.Create(const AValue: string = '*');
begin
  inherited Create;
  FValue := AValue;
end;

function TWebMockStringWildcardMatcher.IsMatch(AValue: string): Boolean;
begin
  Result := (Value = '*') or (Value = AValue);
end;

function TWebMockStringWildcardMatcher.ToString: string;
begin
  Result := Value;
end;

end.
