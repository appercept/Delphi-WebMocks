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
    procedure Create_WithNoArguments_StartsListeningOnPort8080;
    [Test]
    procedure Create_WithPort_StartsListeningOnPortPort;
    [Test]
    procedure BaseURL_ByDefault_ReturnsLocalHostURLWithDefaultPort;
    [Test]
    procedure BaseURL_WhenPortIsNotDefault_ReturnsLocalHostURLWithPort;
    [Test]
    procedure Reset_Always_ClearsHistory;
    [Test]
    procedure Reset_Always_ClearsStubRegistry;
    [Test]
    procedure ResetHistory_Always_ClearsHistory;
    [Test]
    procedure RestStubRegistry_Always_ClearsStubRegistry;
    [Test]
    procedure StubRequest_WithStringURI_ReturnsARequestStub;
    [Test]
    procedure StubRequest_WithRegExURI_ReturnsARequestStub;
    [Test]
    procedure Response_WhenRequestStubbed_ReturnsOK;
    [Test]
    procedure Response_WhenRequestIsNotStubbed_ReturnsNotImplemented;
    [Test]
    procedure Response_WhenToReturnSetsStatus_ReturnsSpecifiedStatusCode;
    [Test]
    procedure Response_WhenToReturnSetsStatus_ReturnsSpecifiedStatusText;
    [Test]
    procedure Response_WhenToReturnSetsCustomStatus_ReturnsSpecifiedStatusText;
  end;

implementation

uses
  Delphi.WebMock.RequestStub,
  Delphi.WebMock.ResponseStatus,
  IdGlobal, IdHTTP,
  System.RegularExpressions, System.StrUtils,
  TestHelpers;

procedure TWebMockTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockTests.TearDown;
begin
  WebMock.Free;
end;

procedure TWebMockTests.BaseURL_ByDefault_ReturnsLocalHostURLWithDefaultPort;
begin
  Assert.AreEqual('http://127.0.0.1:8080/', WebMock.BaseURL);
end;

procedure TWebMockTests.BaseURL_WhenPortIsNotDefault_ReturnsLocalHostURLWithPort;
begin
  WebMock.Free;
  WebMock := TWebMock.Create(8088);

  Assert.AreEqual('http://127.0.0.1:8088/', WebMock.BaseURL);
end;

procedure TWebMockTests.Create_WithNoArguments_StartsListeningOnPort8080;
var
  LResponse: TIdHTTPResponse;
begin
  LResponse := WebClient.Get('http://localhost:8080/');

  Assert.AreEqual('Delphi WebMocks', LResponse.Server);
end;

procedure TWebMockTests.Create_WithPort_StartsListeningOnPortPort;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.Free;

  WebMock := TWebMock.Create(8088);
  LResponse := WebClient.Get('http://localhost:8088/');

  Assert.AreEqual('Delphi WebMocks', LResponse.Server);
end;

procedure TWebMockTests.ResetHistory_Always_ClearsHistory;
begin
  WebClient.Get(WebMock.BaseURL + 'history');

  WebMock.ResetHistory;

  Assert.AreEqual(0, WebMock.History.Count);
end;

procedure TWebMockTests.Reset_Always_ClearsHistory;
begin
  WebClient.Get(WebMock.BaseURL + 'history');

  WebMock.Reset;

  Assert.AreEqual(0, WebMock.History.Count);
end;

procedure TWebMockTests.Reset_Always_ClearsStubRegistry;
begin
  WebMock.StubRequest('GET', 'document');

  WebMock.Reset;

  Assert.AreEqual(0, WebMock.StubRegistry.Count);
end;

procedure TWebMockTests.Response_WhenRequestIsNotStubbed_ReturnsNotImplemented;
var
  LResponse: TIdHTTPResponse;
begin
  LResponse := WebClient.Get(WebMock.BaseURL);

  Assert.AreEqual(501, LResponse.ResponseCode);
end;

procedure TWebMockTests.Response_WhenRequestStubbed_ReturnsOK;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest('GET', '/');
  LResponse := WebClient.Get(WebMock.BaseURL);

  Assert.AreEqual(200, LResponse.ResponseCode);
end;

procedure TWebMockTests.Response_WhenToReturnSetsStatus_ReturnsSpecifiedStatusCode;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest('POST', '/response').ToReturn(TWebMockResponseStatus.Created);
  LResponse := WebClient.Post(WebMock.BaseURL + 'response', '');

  Assert.AreEqual(201, LResponse.ResponseCode);
end;

procedure TWebMockTests.Response_WhenToReturnSetsStatus_ReturnsSpecifiedStatusText;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest('POST', '/response').ToReturn(TWebMockResponseStatus.Created);
  LResponse := WebClient.Post(WebMock.BaseURL + 'response', '');

  Assert.IsTrue(EndsStr('Created', LResponse.ResponseText));
end;

procedure TWebMockTests.RestStubRegistry_Always_ClearsStubRegistry;
begin
  WebMock.StubRequest('GET', 'document');

  WebMock.ResetStubRegistry;

  Assert.AreEqual(0, WebMock.StubRegistry.Count);
end;

procedure TWebMockTests.StubRequest_WithRegExURI_ReturnsARequestStub;
begin
  Assert.IsTrue(WebMock.StubRequest('GET', TRegEx.Create('.*')) is TWebMockRequestStub);
end;

procedure TWebMockTests.StubRequest_WithStringURI_ReturnsARequestStub;
begin
  Assert.IsTrue(WebMock.StubRequest('GET', '/') is TWebMockRequestStub);
end;

procedure TWebMockTests.Response_WhenToReturnSetsCustomStatus_ReturnsSpecifiedStatusText;
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
