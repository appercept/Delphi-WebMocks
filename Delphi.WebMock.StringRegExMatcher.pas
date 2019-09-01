unit Delphi.WebMock.StringRegExMatcher;

interface

uses
  Delphi.WebMock.StringMatcher,
  System.RegularExpressions;

type
  TWebMockStringRegExMatcher = class(TInterfacedObject, IStringMatcher)
  private
    FRegEx: TRegEx;
  public
    constructor Create(ARegEx: TRegEx);
    function IsMatch(AValue: string): Boolean;
    function ToString: string;
    property RegEx: TRegEx read FRegEx;
  end;

implementation

{ TWebMockStringRegExMatcher }

constructor TWebMockStringRegExMatcher.Create(ARegEx: TRegEx);
begin
  inherited Create;
  FRegEx := ARegEx;
end;

function TWebMockStringRegExMatcher.IsMatch(AValue: string): Boolean;
begin
  Result := RegEx.IsMatch(AValue);
end;

function TWebMockStringRegExMatcher.ToString: string;
begin
  Result := 'Regular Expression';
end;

end.
