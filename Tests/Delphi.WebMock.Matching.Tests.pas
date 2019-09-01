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
    procedure RequestWithMethodAndStringPath_Matching_RespondsOK(const AMatcherMethod, AMatcherURI, ARequestURI: string);
    [Test]
    [TestCase('No Match', 'POST,/pathA,pathB')]
    [TestCase('Wildcard Method Not Matching URI', '*,/pathA,pathB')]
    [TestCase('Wildcard URI Not Matching Method', 'POST,*,')]
    procedure StubWithMethodAndStringURI_NotMatching_RespondsNotImplemented(const AMatcherMethod, AMatcherURI, ARequestURI: string);
    [Test]
    [TestCase('Exact Match', 'GET,^/path$,path')]
    [TestCase('Resource by ID', 'GET,^/resource/\d+$,resource/123')]
    procedure RequestWithMethodAndRegExPath_Matching_RespondsOK(const AMatcherMethod, AMatcherURIPattern, ARequestURI: string);
    [Test]
    [TestCase('No Simple Match', 'GET,^/path$,other_path')]
    [TestCase('No Resource by ID', 'GET,^/resource/\d+$,resource/abc')]
    procedure RequestWithMethodAndRegExPath_NotMatching_RespondsNotImplemented(const AMatcherMethod, AMatcherURIPattern, ARequestURI: string);
    [Test]
    procedure Request_MatchingSingleHeader_ReturnsOK;
    [Test]
    procedure Request_NotMatchingSingleHeader_ReturnsNotImplemented;
    [Test]
    procedure Request_MatchingMultipleHeaders_ReturnsOK;
    [Test]
    procedure Request_PartiallyMatchingMultipleHeaders_ReturnsNotImplemented;
    [Test]
    procedure Request_MatchingMultipleHeadersStringList_ReturnsOK;
  end;

implementation

uses
  Delphi.WebMock.RequestStub,
  Delphi.WebMock.ResponseStatus,
  IdGlobal, IdHTTP,
  System.RegularExpressions, System.StrUtils,
  TestHelpers;

procedure TWebMockMatchingTests.Request_MatchingMultipleHeadersStringList_ReturnsOK;
var
  LHeaders: TStringList;
  LResponse: TIdHTTPResponse;
begin
  LHeaders := TStringList.Create;
  LHeaders.Values['Header1'] := 'Value1';
  LHeaders.Values['Header2'] := 'Value2';

  WebMock.StubRequest('*', '*').WithHeaders(LHeaders);
  LResponse := WebClient.Get(WebMock.BaseURL, LHeaders);

  Assert.AreEqual(200, LResponse.ResponseCode);

  LResponse.Free;
  LHeaders.Free;
end;

procedure TWebMockMatchingTests.Request_MatchingMultipleHeaders_ReturnsOK;
var
  LHeaderName1, LHeaderValue1, LHeaderName2, LHeaderValue2: string;
  LHeaders: TStringList;
  LResponse: TIdHTTPResponse;
begin
  LHeaderName1 := 'Header1';
  LHeaderValue1 := 'Value1';
  LHeaderName2 := 'Header2';
  LHeaderValue2 := 'Value2';
  LHeaders := TStringList.Create;
  LHeaders.AddPair(LHeaderName1, LHeaderValue1);
  LHeaders.AddPair(LHeaderName2, LHeaderValue2);

  WebMock.StubRequest('*', '*')
    .WithHeader(LHeaderName1, LHeaderValue1)
    .WithHeader(LHeaderName2, LHeaderValue2);
  LResponse := WebClient.Get(WebMock.BaseURL, LHeaders);

  Assert.AreEqual(200, LResponse.ResponseCode);

  LResponse.Free;
  LHeaders.Free;
end;

procedure TWebMockMatchingTests.Request_MatchingSingleHeader_ReturnsOK;
var
  LHeaderName, LHeaderValue: string;
  LHeaders: TStringList;
  LResponse: TIdHTTPResponse;
begin
  LHeaderName := 'CustomerHeader';
  LHeaderValue := 'Value';
  LHeaders := TStringList.Create;
  LHeaders.AddPair(LHeaderName, LHeaderValue);

  WebMock.StubRequest('*', '*').WithHeader(LHeaderName, LHeaderValue);
  LResponse := WebClient.Get(WebMock.BaseURL, LHeaders);

  Assert.AreEqual(200, LResponse.ResponseCode);

  LResponse.Free;
  LHeaders.Free;
end;

procedure TWebMockMatchingTests.StubWithMethodAndStringURI_NotMatching_RespondsNotImplemented(const AMatcherMethod, AMatcherURI, ARequestURI: string);
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest(AMatcherMethod, AMatcherURI);
  LResponse := WebClient.Get(WebMock.BaseURL + ARequestURI);

  Assert.AreEqual(501, LResponse.ResponseCode);

  LResponse.Free;
end;

procedure TWebMockMatchingTests.Request_NotMatchingSingleHeader_ReturnsNotImplemented;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest('*', '*').WithHeader('CustomerHeader', 'Value');
  LResponse := WebClient.Get(WebMock.BaseURL);

  Assert.AreEqual(501, LResponse.ResponseCode);

  LResponse.Free;
end;

procedure TWebMockMatchingTests.Request_PartiallyMatchingMultipleHeaders_ReturnsNotImplemented;
var
  LHeaderName1, LHeaderValue1, LHeaderName2, LHeaderValue2: string;
  LHeaders: TStringList;
  LResponse: TIdHTTPResponse;
begin
  LHeaderName1 := 'Header1';
  LHeaderValue1 := 'Value1';
  LHeaderName2 := 'Header2';
  LHeaderValue2 := 'Value2';
  LHeaders := TStringList.Create;
  LHeaders.AddPair(LHeaderName1, LHeaderValue1);
  LHeaders.AddPair(LHeaderName2, 'WrongValue');

  WebMock.StubRequest('*', '*')
    .WithHeader(LHeaderName1, LHeaderValue1)
    .WithHeader(LHeaderName2, LHeaderValue2);
  LResponse := WebClient.Get(WebMock.BaseURL, LHeaders);

  Assert.AreEqual(501, LResponse.ResponseCode);

  LResponse.Free;
  LHeaders.Free;
end;

procedure TWebMockMatchingTests.RequestWithMethodAndRegExPath_Matching_RespondsOK(
  const AMatcherMethod, AMatcherURIPattern, ARequestURI: string);
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest(AMatcherMethod, TRegEx.Create(AMatcherURIPattern));
  LResponse := WebClient.Get(WebMock.BaseURL + ARequestURI);

  Assert.AreEqual(200, LResponse.ResponseCode);

  LResponse.Free;
end;

procedure TWebMockMatchingTests.RequestWithMethodAndRegExPath_NotMatching_RespondsNotImplemented(
  const AMatcherMethod, AMatcherURIPattern, ARequestURI: string);
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest(AMatcherMethod, TRegEx.Create(AMatcherURIPattern));
  LResponse := WebClient.Get(WebMock.BaseURL + ARequestURI);

  Assert.AreEqual(501, LResponse.ResponseCode);

  LResponse.Free;
end;

procedure TWebMockMatchingTests.RequestWithMethodAndStringPath_Matching_RespondsOK(const AMatcherMethod, AMatcherURI, ARequestURI: string);
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest(AMatcherMethod, AMatcherURI);
  LResponse := WebClient.Get(WebMock.BaseURL + ARequestURI);

  Assert.AreEqual(200, LResponse.ResponseCode);

  LResponse.Free;
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

