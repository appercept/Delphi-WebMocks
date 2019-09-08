unit Delphi.WebMock.ResponsesWithHeaders.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock,
  System.Classes,
  System.SysUtils;

type

  [TestFixture]
  TWebMockResponsesWithHeadersTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Response_WithHeader_HasValueForHeader;
    [Test]
    procedure Response_WithHeaderChained_HasValueForEachHeader;
    [Test]
    procedure Response_WithHeaders_HasValueForAllHeaders;
  end;

implementation

{ TWebMockResponsesWithHeadersTests }

uses
  IdHTTP,
  TestHelpers;

procedure TWebMockResponsesWithHeadersTests.Response_WithHeaderChained_HasValueForEachHeader;
var
  LHeaderName1, LHeaderName2, LHeaderValue1, LHeaderValue2: string;
  LResponse: TIdHTTPResponse;
begin
  LHeaderName1 := 'Header1';
  LHeaderValue1 := 'Value1';
  LHeaderName2 := 'Header2';
  LHeaderValue2 := 'Value2';

  WebMock.StubRequest('*', '*').ToReturn
    .WithHeader(LHeaderName1, LHeaderValue1)
    .WithHeader(LHeaderName2, LHeaderValue2);
  LResponse := WebClient.Get(WebMock.BaseURL);

  Assert.AreEqual(LHeaderValue1, LResponse.RawHeaders.Values[LHeaderName1]);
  Assert.AreEqual(LHeaderValue2, LResponse.RawHeaders.Values[LHeaderName2]);

  LResponse.Free;
end;

procedure TWebMockResponsesWithHeadersTests.Response_WithHeaders_HasValueForAllHeaders;
var
  LHeaders: TStringList;
  LResponse: TIdHTTPResponse;
  I: Integer;
begin
  LHeaders := TStringList.Create;
  LHeaders.Values['Header1'] := 'Value1';
  LHeaders.Values['Header2'] := 'Value2';
  LHeaders.Values['Header3'] := 'Value3';
  LHeaders.Values['Header4'] := 'Value4';

  WebMock.StubRequest('*', '*').ToReturn.WithHeaders(LHeaders);
  LResponse := WebClient.Get(WebMock.BaseURL);

  for I := 0 to LHeaders.Count - 1 do
    Assert.AreEqual(
      LHeaders.ValueFromIndex[I],
      LResponse.RawHeaders.Values[LHeaders.Names[I]]
    );

  LResponse.Free;
  LHeaders.Free;
end;

procedure TWebMockResponsesWithHeadersTests.Response_WithHeader_HasValueForHeader;
var
  LHeaderName, LHeaderValue: string;
  LResponse: TIdHTTPResponse;
begin
  LHeaderName := 'Header1';
  LHeaderValue := 'Value1';

  WebMock.StubRequest('*', '*').ToReturn.WithHeader(LHeaderName, LHeaderValue);
  LResponse := WebClient.Get(WebMock.BaseURL);

  Assert.AreEqual(LHeaderValue, LResponse.RawHeaders.Values[LHeaderName]);
end;

procedure TWebMockResponsesWithHeadersTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockResponsesWithHeadersTests.TearDown;
begin
  WebMock.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockResponsesWithHeadersTests);
end.
