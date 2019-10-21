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
    procedure ResetStubRegistry_Always_ClearsStubRegistry;
    [Test]
    procedure StubRequest_WithStringURI_ReturnsARequestStub;
    [Test]
    procedure StubRequest_WithRegExURI_ReturnsARequestStub;
    [Test]
    procedure URLFor_GivenEmptyString_ReturnsBaseURL;
    [Test]
    procedure URLFor_GivenStringWithoutLeadingSlash_ReturnsCorrectlyJoinedURL;
    [Test]
    procedure URLFor_GivenStringWithLeadingSlash_ReturnsCorrectlyJoinedURL;
  end;

implementation

uses
  Delphi.WebMock.RequestStub,
  System.Net.HttpClient, System.RegularExpressions, System.StrUtils,
  TestHelpers;

procedure TWebMockTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockTests.TearDown;
begin
  WebMock.Free;
end;

procedure TWebMockTests.URLFor_GivenEmptyString_ReturnsBaseURL;
begin
  Assert.AreEqual(WebMock.BaseURL, WebMock.URLFor(''));
end;

procedure TWebMockTests.URLFor_GivenStringWithLeadingSlash_ReturnsCorrectlyJoinedURL;
begin
  Assert.AreEqual('http://127.0.0.1:8080/file', WebMock.URLFor('/file'));
end;

procedure TWebMockTests.URLFor_GivenStringWithoutLeadingSlash_ReturnsCorrectlyJoinedURL;
begin
  Assert.AreEqual('http://127.0.0.1:8080/file', WebMock.URLFor('file'));
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
  LResponse: IHTTPResponse;
begin
  LResponse := WebClient.Get('http://localhost:8080/');

  Assert.AreEqual('Delphi WebMocks', LResponse.HeaderValue['Server']);
end;

procedure TWebMockTests.Create_WithPort_StartsListeningOnPortPort;
var
  LResponse: IHTTPResponse;
begin
  WebMock.Free;

  WebMock := TWebMock.Create(8088);
  LResponse := WebClient.Get('http://localhost:8088/');

  Assert.AreEqual('Delphi WebMocks', LResponse.HeaderValue['Server']);
end;

procedure TWebMockTests.ResetHistory_Always_ClearsHistory;
begin
  WebClient.Get(WebMock.URLFor('history'));

  WebMock.ResetHistory;

  Assert.AreEqual(0, WebMock.History.Count);
end;

procedure TWebMockTests.Reset_Always_ClearsHistory;
begin
  WebClient.Get(WebMock.URLFor('history'));

  WebMock.Reset;

  Assert.AreEqual(0, WebMock.History.Count);
end;

procedure TWebMockTests.Reset_Always_ClearsStubRegistry;
begin
  WebMock.StubRequest('GET', 'document');

  WebMock.Reset;

  Assert.AreEqual(0, WebMock.StubRegistry.Count);
end;

procedure TWebMockTests.ResetStubRegistry_Always_ClearsStubRegistry;
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

initialization
  TDUnitX.RegisterTestFixture(TWebMockTests);
end.
