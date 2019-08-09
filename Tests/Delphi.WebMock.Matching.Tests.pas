unit Delphi.WebMock.Matching.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock,
  System.Classes,
  System.SysUtils;

type

  [TestFixture]
  TWebMockMatchingTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    [TestCase('Exact Match', 'GET,/,')]
    [TestCase('Wildcard Method Match', '*,/,')]
    [TestCase('Wildcard URI Match', 'GET,*,anypath')]
    procedure Request_WithMatchingMethodAndPath_ReturnsOK(const AMatcherMethod, AMatcherURI, ARequestURI: string);
    [Test]
    [TestCase('No Match', 'POST,/pathA,pathB')]
    [TestCase('Wildcard Method Not Matching URI', '*,/pathA,pathB')]
    [TestCase('Wildcard URI Not Matching Method', 'POST,*,')]
    procedure Request_NotMatchingMethodAndPath_ReturnsNotImplemented(const AMatcherMethod, AMatcherURI, ARequestURI: string);
    [Test]
    procedure Request_MatchingSingleHeader_ReturnsOK;
  end;

implementation

uses
  Delphi.WebMock.RequestStub,
  Delphi.WebMock.ResponseStatus,
  IdGlobal, IdHTTP,
  System.StrUtils,
  TestHelpers;

procedure TWebMockMatchingTests.Request_MatchingSingleHeader_ReturnsOK;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest('*', '*').WithHeader('CustomerHeader', 'Value');
  LResponse := WebClient.Get(WebMock.BaseURL);

  Assert.AreEqual(200, LResponse.ResponseCode);
end;

procedure TWebMockMatchingTests.Request_NotMatchingMethodAndPath_ReturnsNotImplemented(const AMatcherMethod, AMatcherURI, ARequestURI: string);
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest(AMatcherMethod, AMatcherURI);
  LResponse := WebClient.Get(WebMock.BaseURL + ARequestURI);

  Assert.AreEqual(501, LResponse.ResponseCode);
end;

procedure TWebMockMatchingTests.Request_WithMatchingMethodAndPath_ReturnsOK(const AMatcherMethod, AMatcherURI, ARequestURI: string);
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest(AMatcherMethod, AMatcherURI);
  LResponse := WebClient.Get(WebMock.BaseURL + ARequestURI);

  Assert.AreEqual(200, LResponse.ResponseCode);
end;

procedure TWebMockMatchingTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockMatchingTests.TearDown;
begin
  WebMock.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockMatchingTests);
end.

