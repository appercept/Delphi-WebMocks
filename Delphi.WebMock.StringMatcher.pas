unit Delphi.WebMock.StringMatcher;

interface

type
  IStringMatcher = interface
    ['{1D54F796-75BD-4ED1-B0A3-EC567084711A}']
    function IsMatch(AValue: string): Boolean;
    function ToString: string;
  end;

implementation

end.
