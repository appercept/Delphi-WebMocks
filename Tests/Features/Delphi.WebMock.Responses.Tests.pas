unit Delphi.WebMock.Responses.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock,
  System.Classes,
  System.SysUtils;

type

  [TestFixture]
  TWebMockResponsesTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Response_WhenRequestStubbed_ReturnsOK;
    [Test]
    procedure Response_WhenRequestIsNotStubbed_ReturnsNotImplemented;
    [Test]
    procedure Response_WhenToRespondSetsStatus_ReturnsSpecifiedStatusCode;
    [Test]
    procedure Response_WhenToRespondSetsStatus_ReturnsSpecifiedStatusText;
    [Test]
    procedure Response_WhenToRespondSetsCustomStatus_ReturnsSpecifiedStatusText;
  end;

implementation

{ TWebMockResponsesTests }

uses
  Delphi.WebMock.ResponseStatus,
  System.Net.HttpClient, System.StrUtils,
  TestHelpers;

procedure TWebMockResponsesTests.Response_WhenRequestIsNotStubbed_ReturnsNotImplemented;
var
  LResponse: IHTTPResponse;
begin
  LResponse := WebClient.Get(WebMock.BaseURL);

  Assert.AreEqual(501, LResponse.StatusCode);
end;

procedure TWebMockResponsesTests.Response_WhenRequestStubbed_ReturnsOK;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('GET', '/');
  LResponse := WebClient.Get(WebMock.BaseURL);

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TWebMockResponsesTests.Response_WhenToRespondSetsCustomStatus_ReturnsSpecifiedStatusText;
var
  LExpectedStatus: TWebMockResponseStatus;
  LResponse: IHTTPResponse;
begin
  LExpectedStatus := TWebMockResponseStatus.Create(999, 'My Status');

  WebMock.StubRequest('POST', '/response').ToRespond(LExpectedStatus);
  LResponse := WebClient.Post(WebMock.URLFor('response'), TStringStream.Create(''));

  Assert.IsTrue(EndsStr('My Status', LResponse.StatusText));
end;

procedure TWebMockResponsesTests.Response_WhenToRespondSetsStatus_ReturnsSpecifiedStatusCode;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('POST', '/response').ToRespond(TWebMockResponseStatus.Created);
  LResponse := WebClient.Post(WebMock.URLFor('response'), TStringStream.Create(''));

  Assert.AreEqual(201, LResponse.StatusCode);
end;

procedure TWebMockResponsesTests.Response_WhenToRespondSetsStatus_ReturnsSpecifiedStatusText;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('POST', '/response').ToRespond(TWebMockResponseStatus.Created);
  LResponse := WebClient.Post(WebMock.URLFor('response'), TStringStream.Create(''));

  Assert.IsTrue(EndsStr('Created', LResponse.StatusText));
end;

procedure TWebMockResponsesTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockResponsesTests.TearDown;
begin
  WebMock.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockResponsesTests);
end.
