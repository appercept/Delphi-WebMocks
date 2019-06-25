unit Delphi.WebMock.ResponseContentFile.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock.ResponseContentFile;

type

  [TestFixture]
  TWebMockResponseContentFileTests = class(TObject)
  private
    WebMockResponseContentFile: TWebMockResponseContentFile;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Test_Create_WithValidFileName_LoadsContentStreamFromFile;
    [Test]
    procedure Test_ContentType_WhenNotSpecifiedWithKnownFileType_SetsContentType;
    [Test]
    procedure Test_ContentType_WhenNotSpecifiedWithUnknownFileType_SetsContentTypeToBinary;
    [Test]
    procedure Test_ContentType_WhenSpecified_ReturnsContentType;
  end;

implementation

uses
  System.Classes,
  TestHelpers;

{ TWebMockResponseContentFileTests }

procedure TWebMockResponseContentFileTests.Setup;
begin

end;

procedure TWebMockResponseContentFileTests.TearDown;
begin
  WebMockResponseContentFile.Free;
end;

procedure TWebMockResponseContentFileTests.Test_ContentType_WhenNotSpecifiedWithKnownFileType_SetsContentType;
begin
  WebMockResponseContentFile := TWebMockResponseContentFile.Create(FixturePath('Sample.txt'));

  Assert.AreEqual('text/plain', WebMockResponseContentFile.ContentType);
end;

procedure TWebMockResponseContentFileTests.Test_ContentType_WhenNotSpecifiedWithUnknownFileType_SetsContentTypeToBinary;
begin
  WebMockResponseContentFile := TWebMockResponseContentFile.Create(FixturePath('Sample.unknown'));

  Assert.AreEqual('application/octet-stream', WebMockResponseContentFile.ContentType);
end;

procedure TWebMockResponseContentFileTests.Test_ContentType_WhenSpecified_ReturnsContentType;
var
  LExpected: string;
begin
  LExpected := 'text/rtf';

  WebMockResponseContentFile := TWebMockResponseContentFile.Create(FixturePath('Sample.txt'), LExpected);

  Assert.AreEqual(LExpected, WebMockResponseContentFile.ContentType);
end;

procedure TWebMockResponseContentFileTests.Test_Create_WithValidFileName_LoadsContentStreamFromFile;
var
  LActualContent: TStringStream;
begin
  WebMockResponseContentFile := TWebMockResponseContentFile.Create(FixturePath('Sample.txt'));

  LActualContent := TStringStream.Create('');
  LActualContent.CopyFrom(WebMockResponseContentFile.ContentStream, 0);
  Assert.AreEqual('Sample Text', LActualContent.DataString);

  LActualContent.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockResponseContentFileTests);
end.
