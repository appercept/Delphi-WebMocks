unit Delphi.WebMock.ResponsesWithBody.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock,
  System.Classes,
  System.SysUtils;

type

  [TestFixture]
  TWebMockResponsesWithBodyTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Response_WhenWithBodyIsAStringWithoutContentType_SetsContentTypeToPlainText;
    [Test]
    procedure Response_WhenWithBodyIsAStringWithContentType_SetsContentType;
    [Test]
    procedure Response_WhenWithBodyIsAString_ReturnsStringAsContent;
    [Test]
    procedure Response_WhenWithBodyIsString_ReturnsUTF8CharSet;
    [Test]
    procedure Response_WhenWithBodyFileWithoutContentType_SetsContentTypeToInferedType;
    [Test]
    procedure Response_WhenWithBodyFileWithContentType_SetsContentType;
  end;

implementation

{ TWebMockResponsesWithBodyTests }

uses
  IdGlobal,
  System.Net.HttpClient,
  TestHelpers;

procedure TWebMockResponsesWithBodyTests.Response_WhenWithBodyFileWithContentType_SetsContentType;
var
  LExpected: string;
  LResponse: IHTTPResponse;
begin
  LExpected := 'application/xml';

  WebMock.StubRequest('GET', '/json').ToRespond.WithBodyFile(FixturePath('Response.json'), LExpected);
  LResponse := WebClient.Get(WebMock.URLFor('json'));

  Assert.AreEqual(LExpected, LResponse.HeaderValue['Content-Type']);
end;

procedure TWebMockResponsesWithBodyTests.Response_WhenWithBodyFileWithoutContentType_SetsContentTypeToInferedType;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/json').ToRespond.WithBodyFile(FixturePath('Response.json'));
  LResponse := WebClient.Get(WebMock.URLFor('json'));

  Assert.AreEqual('application/json', LResponse.HeaderValue['Content-Type']);
end;

procedure TWebMockResponsesWithBodyTests.Response_WhenWithBodyIsAStringWithContentType_SetsContentType;
var
  LExpected: string;
  LResponse: IHTTPResponse;
begin
  LExpected := 'text/rtf';

  WebMock.StubRequest('GET', '/text').ToRespond.WithBody('Text', LExpected);
  LResponse := WebClient.Get(WebMock.URLFor('text'));

  Assert.StartsWith(LExpected, LResponse.HeaderValue['Content-Type']);
end;

procedure TWebMockResponsesWithBodyTests.Response_WhenWithBodyIsAStringWithoutContentType_SetsContentTypeToPlainText;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/text').ToRespond.WithBody('Text');
  LResponse := WebClient.Get(WebMock.URLFor('text'));

  Assert.StartsWith('text/plain', LResponse.HeaderValue['Content-Type']);
end;

procedure TWebMockResponsesWithBodyTests.Response_WhenWithBodyIsAString_ReturnsStringAsContent;
var
  LExpectedContent: string;
  LResponse: IHTTPResponse;
  LHeader: string;
  LContentText: string;
begin
  LExpectedContent := 'Body Text';

  WebMock.StubRequest('GET', '/text').ToRespond.WithBody(LExpectedContent);
  LResponse := WebClient.Get(WebMock.URLFor('text'));

  LContentText := ReadStringFromStream(LResponse.ContentStream);
  Assert.AreEqual(LExpectedContent, LContentText);
end;

procedure TWebMockResponsesWithBodyTests.Response_WhenWithBodyIsString_ReturnsUTF8CharSet;
var
  LResponse: IHTTPResponse;
  LHeader: string;
begin
  WebMock.StubRequest('GET', '/text').ToRespond.WithBody('UTF-8 Text');
  LResponse := WebClient.Get(WebMock.URLFor('text'));

  Assert.EndsWith('utf-8', LResponse.HeaderValue['Content-Type']);
end;

procedure TWebMockResponsesWithBodyTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockResponsesWithBodyTests.TearDown;
begin
  WebMock.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockResponsesWithBodyTests);
end.
