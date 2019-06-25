unit Delphi.WebMock.ResponseContentString.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock.ResponseContentString;

type

  [TestFixture]
  TWebMockResponseContentStringTests = class(TObject)
  private
    WebMockResponseContentString: TWebMockResponseContentString;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Test_Create_WithoutArguments_SetsAnEmptyString;
    [Test]
    procedure Test_Create_WithString_SetsString;
    [Test]
    procedure Test_ContentString_Always_ReturnsValueInitializedOnCreate;
    [Test]
    procedure Test_ContentStream_Always_ReturnsAStringStreamContainingString;
    [Test]
    procedure Test_ContentType_WhenNotSpecified_DefaultsToPlainTextWithUTF8CharSet;
    [Test]
    procedure Test_ContentType_WhenSpecified_ReturnsContentType;
  end;

implementation

uses
  System.Classes;

{ TWebMockResponseContentStringTests }

procedure TWebMockResponseContentStringTests.Setup;
begin

end;

procedure TWebMockResponseContentStringTests.TearDown;
begin
  WebMockResponseContentString.Free;
end;

procedure TWebMockResponseContentStringTests.Test_ContentStream_Always_ReturnsAStringStreamContainingString;
var
  LExpected: string;
  LStream: TStream;
begin
  LExpected := 'A String Value';
  WebMockResponseContentString := TWebMockResponseContentString.Create(LExpected);

  Assert.AreEqual(
    LExpected,
    (WebMockResponseContentString.ContentStream as TStringStream).DataString
  );
end;

procedure TWebMockResponseContentStringTests.Test_ContentString_Always_ReturnsValueInitializedOnCreate;
var
  LExpected, LActual: string;
begin
  LExpected := 'A String Value';

  WebMockResponseContentString := TWebMockResponseContentString.Create(LExpected);
  LActual := WebMockResponseContentString.ContentString;

  Assert.AreEqual(LExpected, LActual);
end;

procedure TWebMockResponseContentStringTests.Test_ContentType_WhenNotSpecified_DefaultsToPlainTextWithUTF8CharSet;
begin
  WebMockResponseContentString := TWebMockResponseContentString.Create;

  Assert.AreEqual('text/plain; charset=utf-8', WebMockResponseContentString.ContentType);
end;

procedure TWebMockResponseContentStringTests.Test_ContentType_WhenSpecified_ReturnsContentType;
var
  LExpectedContentType: string;
begin
  LExpectedContentType := 'application/json';

  WebMockResponseContentString := TWebMockResponseContentString.Create('{}', LExpectedContentType);

  Assert.AreEqual(LExpectedContentType, WebMockResponseContentString.ContentType);
end;

procedure TWebMockResponseContentStringTests.Test_Create_WithoutArguments_SetsAnEmptyString;
begin
  WebMockResponseContentString := TWebMockResponseContentString.Create;

  Assert.IsEmpty(WebMockResponseContentString.GetContentString);
end;

procedure TWebMockResponseContentStringTests.Test_Create_WithString_SetsString;
var
  LExpected: string;
begin
  LExpected := 'Test';

  WebMockResponseContentString := TWebMockResponseContentString.Create(LExpected);

  Assert.AreEqual(LExpected, WebMockResponseContentString.GetContentString);
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockResponseContentStringTests);
end.
