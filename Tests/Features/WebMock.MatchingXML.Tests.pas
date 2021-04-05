unit WebMock.MatchingXML.Tests;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  WebMock;

type
  [TestFixture]
  TWebMockMatchingXMLTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Request_MatchingXMLContent_RespondsOK;
    [Test]
    procedure Request_NotMatchingXMLContent_RespondsNotImplemented;
    [Test]
    procedure Request_MatchingXMLContentByRegEx_RespondsOK;
  end;

implementation

uses
  System.Net.HttpClient,
  System.Net.URLClient,
  System.RegularExpressions,
  TestHelpers;

{ TWebMockMatchingXMLTests }

procedure TWebMockMatchingXMLTests.Request_MatchingXMLContentByRegEx_RespondsOK;
var
  LContent: string;
  LContentStream: TStringStream;
  LHeaders: TNetHeaders;
  LResponse: IHTTPResponse;
begin
  LContent := '<Key>123</Key>';
  LContentStream := TStringStream.Create(LContent);
  LHeaders := TNetHeaders.Create(
    TNetHeader.Create('content-type', 'text/xml')
  );

  WebMock.StubRequest('*', '*').WithXML('/Key', TRegEx.Create('\d+'));
  LResponse := WebClient.Post(WebMock.BaseURL, LContentStream, nil, LHeaders);

  Assert.AreEqual(200, LResponse.StatusCode);

  LContentStream.Free;
end;

procedure TWebMockMatchingXMLTests.Request_MatchingXMLContent_RespondsOK;
var
  LContent: string;
  LContentStream: TStringStream;
  LHeaders: TNetHeaders;
  LResponse: IHTTPResponse;
begin
  LContent := '<Key>Value</Key>';
  LContentStream := TStringStream.Create(LContent);
  LHeaders := TNetHeaders.Create(
    TNetHeader.Create('content-type', 'text/xml')
  );

  WebMock.StubRequest('*', '*').WithXML('/Key', 'Value');
  LResponse := WebClient.Post(WebMock.BaseURL, LContentStream, nil, LHeaders);

  Assert.AreEqual(200, LResponse.StatusCode);

  LContentStream.Free;
end;

procedure TWebMockMatchingXMLTests.Request_NotMatchingXMLContent_RespondsNotImplemented;
var
  LContent: string;
  LContentStream: TStringStream;
  LHeaders: TNetHeaders;
  LResponse: IHTTPResponse;
begin
  LContent := '<Key>Value</Key>';
  LContentStream := TStringStream.Create(LContent);
  LHeaders := TNetHeaders.Create(
    TNetHeader.Create('content-type', 'text/xml')
  );

  WebMock.StubRequest('*', '*').WithXML('/Key', 'OtherValue');
  LResponse := WebClient.Post(WebMock.BaseURL, LContentStream, nil, LHeaders);

  Assert.AreEqual(501, LResponse.StatusCode);

  LContentStream.Free;
end;

procedure TWebMockMatchingXMLTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockMatchingXMLTests.TearDown;
begin
  WebMock.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockMatchingXMLTests);
end.
