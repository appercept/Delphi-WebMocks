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
    procedure Test_Create_WithoutArguments_SetsStatusToOK;
    [Test]
    procedure Test_Create_WithStatus_SetsStatus;
    [Test]
    procedure Test_ContentSource_WhenNotSet_ReturnsEmptyContentSource;
  end;

implementation

{ TWebMockResponseTests }

uses Delphi.WebMock.ResponseStatus;

procedure TWebMockResponseTests.Setup;
begin
  WebMockResponse := TWebMockResponse.Create;
end;

procedure TWebMockResponseTests.TearDown;
begin
  WebMockResponse.Free;
end;

procedure TWebMockResponseTests.Test_ContentSource_WhenNotSet_ReturnsEmptyContentSource;
begin
  Assert.AreEqual(Int64(0), WebMockResponse.ContentSource.ContentStream.Size);
end;

procedure TWebMockResponseTests.Test_Create_WithoutArguments_SetsStatusToOK;
begin
  Assert.AreEqual(200, WebMockResponse.Status.Code);
end;

procedure TWebMockResponseTests.Test_Create_WithStatus_SetsStatus;
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
