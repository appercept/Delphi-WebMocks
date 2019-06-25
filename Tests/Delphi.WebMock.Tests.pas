unit Delphi.WebMock.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock,
  System.Classes,
  System.SysUtils;

type

  [TestFixture]
  TWebMockTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Test_Create_WithNoArguments_StartsListeningOnPort8080;
    [Test]
    procedure Test_Create_WithPort_StartsListeningOnPortPort;
    [Test]
    procedure Test_BaseURL_ByDefault_ReturnsLocalHostURLWithDefaultPort;
    [Test]
    procedure Test_BaseURL_WhenPortIsNotDefault_ReturnsLocalHostURLWithPort;
    [Test]
    procedure Test_Response_WhenRequestStubbed_ReturnsOK;
    [Test]
    procedure Test_Response_WhenRequestIsNotStubbed_ReturnsNotImplemented;
    [Test]
    procedure Test_Response_WhenToReturnSetsStatus_ReturnsSpecifiedStatusCode;
    [Test]
    procedure Test_Response_WhenToReturnSetsStatus_ReturnsSpecifiedStatusText;
    [Test]
    procedure Test_Response_WhenToReturnSetsCustomStatus_ReturnsSpecifiedStatusText;
    [Test]
    procedure Test_Response_WhenWithContentIsAStringWithoutContentType_SetsContentTypeToPlainText;
    [Test]
    procedure Test_Response_WhenWithContentIsAStringWithContentType_SetsContentType;
    [Test]
    procedure Test_Response_WhenWithContentIsAString_ReturnsStringAsContent;
    [Test]
    procedure Test_Response_WhenWithContentIsString_ReturnsUTF8CharSet;
    [Test]
    procedure Test_Response_WhenWithContentFileWithoutContentType_SetsContentTypeToInferedType;
    [Test]
    procedure Test_Response_WhenWithContentFileWithContentType_SetsContentType;
  end;

implementation

uses
  Delphi.WebMock.RequestStub,
  Delphi.WebMock.ResponseStatus,
  IdGlobal, IdHTTP,
  System.StrUtils,
  TestHelpers;

procedure TWebMockTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockTests.TearDown;
begin
  WebMock.Free;
end;

procedure TWebMockTests.Test_BaseURL_ByDefault_ReturnsLocalHostURLWithDefaultPort;
begin
  Assert.AreEqual('http://127.0.0.1:8080/', WebMock.BaseURL);
end;

procedure TWebMockTests.Test_BaseURL_WhenPortIsNotDefault_ReturnsLocalHostURLWithPort;
begin
  WebMock.Free;
  WebMock := TWebMock.Create(8088);

  Assert.AreEqual('http://127.0.0.1:8088/', WebMock.BaseURL);
end;

procedure TWebMockTests.Test_Create_WithNoArguments_StartsListeningOnPort8080;
var
  LResponse: TIdHTTPResponse;
begin
  LResponse := WebClient.Get('http://localhost:8080/');

  Assert.AreEqual('Delphi WebMocks', LResponse.Server);
end;

procedure TWebMockTests.Test_Create_WithPort_StartsListeningOnPortPort;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.Free;

  WebMock := TWebMock.Create(8088);
  LResponse := WebClient.Get('http://localhost:8088/');

  Assert.AreEqual('Delphi WebMocks', LResponse.Server);
end;

procedure TWebMockTests.Test_Response_WhenRequestIsNotStubbed_ReturnsNotImplemented;
var
  LResponse: TIdHTTPResponse;
begin
  LResponse := WebClient.Get(WebMock.BaseURL);

  Assert.AreEqual(501, LResponse.ResponseCode);
end;

procedure TWebMockTests.Test_Response_WhenRequestStubbed_ReturnsOK;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest('GET', '/');
  LResponse := WebClient.Get(WebMock.BaseURL);

  Assert.AreEqual(200, LResponse.ResponseCode);
end;

procedure TWebMockTests.Test_Response_WhenToReturnSetsStatus_ReturnsSpecifiedStatusCode;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest('POST', '/response').ToReturn(TWebMockResponseStatus.Created);
  LResponse := WebClient.Post(WebMock.BaseURL + 'response', '');

  Assert.AreEqual(201, LResponse.ResponseCode);
end;

procedure TWebMockTests.Test_Response_WhenToReturnSetsStatus_ReturnsSpecifiedStatusText;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest('POST', '/response').ToReturn(TWebMockResponseStatus.Created);
  LResponse := WebClient.Post(WebMock.BaseURL + 'response', '');

  Assert.IsTrue(EndsStr('Created', LResponse.ResponseText));
end;

procedure TWebMockTests.Test_Response_WhenWithContentIsAString_ReturnsStringAsContent;
var
  LExpectedContent: string;
  LResponse: TIdHTTPResponse;
  LHeader: string;
  LContentText: string;
begin
  LExpectedContent := 'Body Text';

  WebMock.StubRequest('GET', '/text').ToReturn.WithContent(LExpectedContent);
  LResponse := WebClient.Get(WebMock.BaseURL + 'text');

  LContentText := ReadStringFromStream(LResponse.ContentStream);
  Assert.AreEqual(LExpectedContent, LContentText);
end;

procedure TWebMockTests.Test_Response_WhenWithContentIsString_ReturnsUTF8CharSet;
var
  LResponse: TIdHTTPResponse;
  LHeader: string;
begin
  WebMock.StubRequest('GET', '/text').ToReturn.WithContent('UTF-8 Text');
  LResponse := WebClient.Get(WebMock.BaseURL + 'text');

  Assert.AreEqual('UTF-8', LResponse.CharSet);
end;

procedure TWebMockTests.Test_Response_WhenWithContentFileWithContentType_SetsContentType;
var
  LExpected: string;
  LResponse: TIdHTTPResponse;
begin
  LExpected := 'application/xml';

  WebMock.StubRequest('GET', '/json').ToReturn.WithContentFile(FixturePath('Response.json'), LExpected);
  LResponse := WebClient.Get(WebMock.BaseURL + 'json');

  Assert.AreEqual(LExpected, LResponse.ContentType);
end;

procedure TWebMockTests.Test_Response_WhenWithContentFileWithoutContentType_SetsContentTypeToInferedType;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest('GET', '/json').ToReturn.WithContentFile(FixturePath('Response.json'));
  LResponse := WebClient.Get(WebMock.BaseURL + 'json');

  Assert.AreEqual('application/json', LResponse.ContentType);
end;

procedure TWebMockTests.Test_Response_WhenWithContentIsAStringWithContentType_SetsContentType;
var
  LExpected: string;
  LResponse: TIdHTTPResponse;
begin
  LExpected := 'text/rtf';

  WebMock.StubRequest('GET', '/text').ToReturn.WithContent('Text', LExpected);
  LResponse := WebClient.Get(WebMock.BaseURL + 'text');

  Assert.AreEqual(LExpected, LResponse.ContentType);
end;

procedure TWebMockTests.Test_Response_WhenWithContentIsAStringWithoutContentType_SetsContentTypeToPlainText;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest('GET', '/text').ToReturn.WithContent('Text');
  LResponse := WebClient.Get(WebMock.BaseURL + 'text');

  Assert.AreEqual('text/plain', LResponse.ContentType);
end;

procedure TWebMockTests.Test_Response_WhenToReturnSetsCustomStatus_ReturnsSpecifiedStatusText;
var
  LExpectedStatus: TWebMockResponseStatus;
  LResponse: TIdHTTPResponse;
begin
  LExpectedStatus := TWebMockResponseStatus.Create(999, 'My Status');

  WebMock.StubRequest('POST', '/response').ToReturn(LExpectedStatus);
  LResponse := WebClient.Post(WebMock.BaseURL + 'response', '');

  Assert.IsTrue(EndsStr('My Status', LResponse.ResponseText));
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockTests);
end.
