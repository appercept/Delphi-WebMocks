unit Delphi.WebMock.Response.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock.Response;

type

  [TestFixture]
  TWebMockResponseTests = class(TObject)
  private
    WebMockResponse: TWebMockResponse;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Create_WithoutArguments_SetsStatusToOK;
    [Test]
    procedure Create_WithStatus_SetsStatus;
    [Test]
    procedure ContentSource_WhenNotSet_ReturnsEmptyContentSource;
    [Test]
    procedure WithContent_Always_ReturnsSelf;
    [Test]
    procedure WithContent_WithString_SetsResponseContent;
    [Test]
    procedure WithContentFile_Always_ReturnsSelf;
    [Test]
    procedure WithContentFile_WithValidFile_SetsResponseContent;
    [Test]
    procedure WithHeader_Always_ReturnsSelf;
    [Test]
    procedure WithHeader_Always_SetsValueForHeader;
    [Test]
    procedure WithHeader_Always_OverwritesExistingValues;
    [Test]
    procedure WithHeaders_Always_ReturnsSelf;
    [Test]
    procedure WithHeaders_Always_SetsAllValues;
  end;

implementation

{ TWebMockResponseTests }

uses
  Delphi.WebMock.ResponseStatus,
  System.Classes,
  TestHelpers;

procedure TWebMockResponseTests.Setup;
begin
  WebMockResponse := TWebMockResponse.Create;
end;

procedure TWebMockResponseTests.TearDown;
begin
  WebMockResponse.Free;
end;

procedure TWebMockResponseTests.WithContentFile_Always_ReturnsSelf;
begin
  Assert.AreSame(WebMockResponse, WebMockResponse.WithContentFile(FixturePath('Sample.txt')));
end;

procedure TWebMockResponseTests.WithContentFile_WithValidFile_SetsResponseContent;
var
  LExpectedContent: string;
  LActualStream: TStringStream;
begin
  LExpectedContent := 'Sample Text';

  WebMockResponse.WithContentFile(FixturePath('Sample.txt'));

  LActualStream := TStringStream.Create;
  LActualStream.CopyFrom(WebMockResponse.ContentSource.ContentStream, 0);
  Assert.AreEqual(
    LExpectedContent,
    LActualStream.DataString
  );
end;

procedure TWebMockResponseTests.WithContent_Always_ReturnsSelf;
begin
  Assert.AreSame(WebMockResponse, WebMockResponse.WithContent(''));
end;

procedure TWebMockResponseTests.WithContent_WithString_SetsResponseContent;
var
  LExpectedContent: string;
begin
  LExpectedContent := 'Text Body.';

  WebMockResponse.WithContent(LExpectedContent);

  Assert.AreEqual(
    LExpectedContent,
    (WebMockResponse.ContentSource.ContentStream as TStringStream).DataString
  );
end;

procedure TWebMockResponseTests.WithHeaders_Always_ReturnsSelf;
var
  LHeaders: TStringList;
begin
  LHeaders := TStringList.Create;

  Assert.AreSame(WebMockResponse, WebMockResponse.WithHeaders(LHeaders));

  LHeaders.Free;
end;

procedure TWebMockResponseTests.WithHeaders_Always_SetsAllValues;
var
  LHeaders: TStringList;
  LHeaderName, LHeaderValue: string;
  I: Integer;
begin
  LHeaders := TStringList.Create;
  LHeaders.Values['Header1'] := 'Value1';
  LHeaders.Values['Header2'] := 'Value2';

  WebMockResponse.WithHeaders(LHeaders);

  for I := 0 to LHeaders.Count - 1 do
  begin
    LHeaderName := LHeaders.Names[I];
    LHeaderValue := LHeaders.ValueFromIndex[I];
    Assert.AreEqual(LHeaderValue, WebMockResponse.Headers.Values[LHeaderName]);
  end;

  LHeaders.Free;
end;

procedure TWebMockResponseTests.WithHeader_Always_OverwritesExistingValues;
var
  LHeaderName, LHeaderValue1, LHeaderValue2: string;
begin
  LHeaderName := 'Header1';
  LHeaderValue1 := 'Value1';
  LHeaderValue2 := 'Value2';

  WebMockResponse.WithHeader(LHeaderName, LHeaderValue1);
  WebMockResponse.WithHeader(LHeaderName, LHeaderValue2);

  Assert.AreEqual(LHeaderValue2, WebMockResponse.Headers.Values[LHeaderName]);
end;

procedure TWebMockResponseTests.WithHeader_Always_ReturnsSelf;
begin
  Assert.AreSame(
    WebMockResponse,
    WebMockResponse.WithHeader('Header1', 'Value1')
  );
end;

procedure TWebMockResponseTests.WithHeader_Always_SetsValueForHeader;
var
  LHeaderName, LHeaderValue: string;
begin
  LHeaderName := 'Header1';
  LHeaderValue := 'Value1';

  WebMockResponse.WithHeader(LHeaderName, LHeaderValue);

  Assert.AreEqual(LHeaderValue, WebMockResponse.Headers.Values[LHeaderName]);
end;

procedure TWebMockResponseTests.ContentSource_WhenNotSet_ReturnsEmptyContentSource;
begin
  Assert.AreEqual(Int64(0), WebMockResponse.ContentSource.ContentStream.Size);
end;

procedure TWebMockResponseTests.Create_WithoutArguments_SetsStatusToOK;
begin
  Assert.AreEqual(200, WebMockResponse.Status.Code);
end;

procedure TWebMockResponseTests.Create_WithStatus_SetsStatus;
var
  LExpectedStatus: TWebMockResponseStatus;
begin
  LExpectedStatus := TWebMockResponseStatus.Accepted;

  WebMockResponse := TWebMockResponse.Create(LExpectedStatus);

  Assert.AreSame(LExpectedStatus, WebMockResponse.Status);
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockResponseTests);
end.
