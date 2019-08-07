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
