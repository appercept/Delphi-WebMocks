unit Delphi.WebMock.StringAnyMatcher;

interface

uses
  Delphi.WebMock.StringMatcher;

type
  TWebMockStringAnyMatcher = class(TInterfacedObject, IStringMatcher)
  public
    function IsMatch(AValue: string): Boolean;
    function ToString: string; override;
  end;

implementation

{ TWebMockStringAnyMatcher }

function TWebMockStringAnyMatcher.IsMatch(AValue: string): Boolean;
begin
  Result := True;
end;

function TWebMockStringAnyMatcher.ToString: string;
begin
  Result := '*';
end;

end.
