unit Delphi.WebMock.ResponseContentSource;

interface

uses
  System.Classes;

type
  IWebMockResponseContentSource = interface
    ['{2434A4B9-4745-4656-8055-DA6C77FE5DD2}']
    function GetContentStream: TStream;
    function GetContentType: string;

    property ContentStream: TStream read GetContentStream;
    property ContentType: string read GetContentType;
  end;

implementation

end.
