unit Delphi.WebMock.HTTP.Messages;

interface

uses
  System.Classes;

type
  IHTTPMessage = interface(IInterface)
    ['{04B4BDFB-761E-4E44-8C08-DADF4138C067}']
    function GetStartLine: string;
    function GetHeaders: TStrings;
    function GetBody: TStream;
    property StartLine: string read GetStartLine;
    property Headers: TStrings read GetHeaders;
    property Body: TStream read GetBody;
  end;

  IHTTPRequest = interface(IHTTPMessage)
    ['{BE50127E-778C-46C8-B866-96C4124B606F}']
    function GetMethod: string;
    function GetRequestURI: string;
    function GetHTTPVersion: string;
    property RequestLine: string read GetStartLine;
    property Method: string read GetMethod;
    property RequestURI: string read GetRequestURI;
    property HTTPVersion: string read GetHTTPVersion;
  end;

  IHTTPResponse = interface(IHTTPMessage)
    ['{C643273B-78EB-4BB8-9DA1-F256FA715BF1}']
    function GetHTTPVersion: string;
    function GetStatusCode: Integer;
    function GetReasonPhrase: string;
    property StatusLine: string read GetStartLine;
    property HTTPVersion: string read GetHTTPVersion;
    property StatusCode: Integer read GetStatusCode;
    property ReasonPhrase: string read GetReasonPhrase;
  end;

implementation

end.
