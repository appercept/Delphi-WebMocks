unit Delphi.WebMock.ResponsesWithContent.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock,
  System.Classes,
  System.SysUtils;

type

  [TestFixture]
  TWebMockResponsesWithContentTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Response_WhenWithContentIsAStringWithoutContentType_SetsContentTypeToPlainText;
    [Test]
    procedure Response_WhenWithContentIsAStringWithContentType_SetsContentType;
    [Test]
    procedure Response_WhenWithContentIsAString_ReturnsStringAsContent;
    [Test]
    procedure Response_WhenWithContentIsString_ReturnsUTF8CharSet;
    [Test]
    procedure Response_WhenWithContentFileWithoutContentType_SetsContentTypeToInferedType;
    [Test]
    procedure Response_WhenWithContentFileWithContentType_SetsContentType;
  end;

implementation

{ TWebMockResponsesWithContentTests }

uses
  IdGlobal, IdHTTP,
  TestHelpers;

procedure TWebMockResponsesWithContentTests.Response_WhenWithContentFileWithContentType_SetsContentType;
var
  LExpected: string;
  LResponse: TIdHTTPResponse;
begin
  LExpected := 'application/xml';

  WebMock.StubRequest('GET', '/json').ToReturn.WithContentFile(FixturePath('Response.json'), LExpected);
  LResponse := WebClient.Get(WebMock.URLFor('json'));

  Assert.AreEqual(LExpected, LResponse.ContentType);
end;

procedure TWebMockResponsesWithContentTests.Response_WhenWithContentFileWithoutContentType_SetsContentTypeToInferedType;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest('GET', '/json').ToReturn.WithContentFile(FixturePath('Response.json'));
  LResponse := WebClient.Get(WebMock.URLFor('json'));

  Assert.AreEqual('application/json', LResponse.ContentType);
end;

procedure TWebMockResponsesWithContentTests.Response_WhenWithContentIsAStringWithContentType_SetsContentType;
var
  LExpected: string;
  LResponse: TIdHTTPResponse;
begin
  LExpected := 'text/rtf';

  WebMock.StubRequest('GET', '/text').ToReturn.WithContent('Text', LExpected);
  LResponse := WebClient.Get(WebMock.URLFor('text'));

  Assert.AreEqual(LExpected, LResponse.ContentType);
end;

procedure TWebMockResponsesWithContentTests.Response_WhenWithContentIsAStringWithoutContentType_SetsContentTypeToPlainText;
begin

end;

procedure TWebMockResponsesWithContentTests.Response_WhenWithContentIsAString_ReturnsStringAsContent;
var
  LExpectedContent: string;
  LResponse: TIdHTTPResponse;
  LHeader: string;
  LContentText: string;
begin
  LExpectedContent := 'Body Text';

  WebMock.StubRequest('GET', '/text').ToReturn.WithContent(LExpectedContent);
  LResponse := WebClient.Get(WebMock.URLFor('text'));

  LContentText := ReadStringFromStream(LResponse.ContentStream);
  Assert.AreEqual(LExpectedContent, LContentText);
end;

procedure TWebMockResponsesWithContentTests.Response_WhenWithContentIsString_ReturnsUTF8CharSet;
var
  LResponse: TIdHTTPResponse;
  LHeader: string;
begin
  WebMock.StubRequest('GET', '/text').ToReturn.WithContent('UTF-8 Text');
  LResponse := WebClient.Get(WebMock.URLFor('text'));

  Assert.AreEqual('UTF-8', LResponse.CharSet);
end;

procedure TWebMockResponsesWithContentTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockResponsesWithContentTests.TearDown;
begin
  WebMock.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockResponsesWithContentTests);
end.
