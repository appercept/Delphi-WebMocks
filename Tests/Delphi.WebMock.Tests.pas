unit Delphi.WebMock.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock;

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
  end;

implementation

uses
  Delphi.WebMock.RequestStub,
  Delphi.WebMock.ResponseStatus,
  IdHTTP,
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
  LResponse := Get('http://localhost:8080/');

  Assert.AreEqual('Delphi WebMocks', LResponse.Server);
end;

procedure TWebMockTests.Test_Create_WithPort_StartsListeningOnPortPort;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.Free;

  WebMock := TWebMock.Create(8088);
  LResponse := Get('http://localhost:8088/');

  Assert.AreEqual('Delphi WebMocks', LResponse.Server);
end;

procedure TWebMockTests.Test_Response_WhenRequestIsNotStubbed_ReturnsNotImplemented;
var
  LResponse: TIdHTTPResponse;
begin
  LResponse := Get(WebMock.BaseURL);

  Assert.AreEqual(501, LResponse.ResponseCode);
end;

procedure TWebMockTests.Test_Response_WhenRequestStubbed_ReturnsOK;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest('GET', '/');
  LResponse := Get(WebMock.BaseURL);

  Assert.AreEqual(200, LResponse.ResponseCode);
end;

procedure TWebMockTests.Test_Response_WhenToReturnSetsStatus_ReturnsSpecifiedStatusCode;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest('POST', '/response').ToReturn(TWebMockResponseStatus.Created);
  LResponse := Post(WebMock.BaseURL + 'response', '');

  Assert.AreEqual(201, LResponse.ResponseCode);
end;

procedure TWebMockTests.Test_Response_WhenToReturnSetsStatus_ReturnsSpecifiedStatusText;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest('POST', '/response').ToReturn(TWebMockResponseStatus.Created);
  LResponse := Post(WebMock.BaseURL + 'response', '');

  Assert.IsTrue(EndsStr('Created', LResponse.ResponseText));
end;

procedure TWebMockTests.Test_Response_WhenToReturnSetsCustomStatus_ReturnsSpecifiedStatusText;
var
  LExpectedStatus: TWebMockResponseStatus;
  LResponse: TIdHTTPResponse;
begin
  LExpectedStatus := TWebMockResponseStatus.Create(999, 'My Status');

  WebMock.StubRequest('POST', '/response').ToReturn(LExpectedStatus);
  LResponse := Post(WebMock.BaseURL + 'response', '');

  Assert.IsTrue(EndsStr('My Status', LResponse.ResponseText));
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockTests);
end.
