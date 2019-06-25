unit Delphi.WebMock.RequestStub.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock.RequestStub;

type

  [TestFixture]
  TWebMockRequestStubTests = class(TObject)
  private
    StubbedRequest: TWebMockRequestStub;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Test_ToReturn_Always_ReturnsSelf;
    [Test]
    procedure Test_ToReturn_WithNoArguments_DoesNotRaiseException;
    [Test]
    procedure Test_ToReturn_WithNoArguments_DoesNotChangeStatus;
    [Test]
    procedure Test_ToReturn_WithResponse_SetsResponseStatus;
    [Test]
    procedure Test_WithContent_WithString_ReturnsSelf;
    [Test]
    procedure Test_WithContent_WithString_SetsResponseContent;
    [Test]
    procedure Test_WithContentFile_Always_ReturnsSelf;
    [Test]
    procedure Test_WithContentFile_WithValidFile_SetsResponseContent;
  end;

implementation

uses
  Delphi.WebMock.Indy.RequestMatcher,
  Delphi.WebMock.ResponseStatus,
  IdCustomHTTPServer,
  Mock.Indy.HTTPRequestInfo,
  System.Classes,
  TestHelpers;

{ TWebMockRequestStubTests }

procedure TWebMockRequestStubTests.Setup;
var
  LMatcher: TWebMockIndyRequestMatcher;
begin
  LMatcher := TWebMockIndyRequestMatcher.Create;
  StubbedRequest := TWebMockRequestStub.Create(LMatcher);
end;

procedure TWebMockRequestStubTests.TearDown;
begin
  StubbedRequest := nil;
end;

procedure TWebMockRequestStubTests.Test_ToReturn_Always_ReturnsSelf;
begin
  Assert.AreSame(StubbedRequest, StubbedRequest.ToReturn);
end;

procedure TWebMockRequestStubTests.Test_ToReturn_WithNoArguments_DoesNotRaiseException;
begin
  Assert.WillNotRaiseAny(
  procedure
  begin
    StubbedRequest.ToReturn;
  end);
end;

procedure TWebMockRequestStubTests.Test_ToReturn_WithNoArguments_DoesNotChangeStatus;
var
  LExpectedStatus: TWebMockResponseStatus;
begin
  LExpectedStatus := StubbedRequest.Response.Status;

  StubbedRequest.ToReturn;

  Assert.AreSame(LExpectedStatus, StubbedRequest.Response.Status);
end;

procedure TWebMockRequestStubTests.Test_ToReturn_WithResponse_SetsResponseStatus;
var
  LResponse: TWebMockResponseStatus;
begin
  LResponse := TWebMockResponseStatus.Continue;

  StubbedRequest.ToReturn(LResponse);

  Assert.AreSame(LResponse, StubbedRequest.Response.Status);
end;

procedure TWebMockRequestStubTests.Test_WithContentFile_Always_ReturnsSelf;
begin
  Assert.AreSame(StubbedRequest, StubbedRequest.WithContentFile(FixturePath('Sample.txt')));
end;

procedure TWebMockRequestStubTests.Test_WithContentFile_WithValidFile_SetsResponseContent;
var
  LExpectedContent: string;
  LActualStream: TStringStream;
begin
  LExpectedContent := 'Sample Text';

  StubbedRequest.WithContentFile(FixturePath('Sample.txt'));

  LActualStream := TStringStream.Create;
  LActualStream.CopyFrom(StubbedRequest.Response.ContentSource.ContentStream, 0);
  Assert.AreEqual(
    LExpectedContent,
    LActualStream.DataString
  );
end;

procedure TWebMockRequestStubTests.Test_WithContent_WithString_ReturnsSelf;
begin
  Assert.AreSame(StubbedRequest, StubbedRequest.WithContent(''));
end;

procedure TWebMockRequestStubTests.Test_WithContent_WithString_SetsResponseContent;
var
  LExpectedContent: string;
begin
  LExpectedContent := 'Text Body.';

  StubbedRequest.WithContent(LExpectedContent);

  Assert.AreEqual(
    LExpectedContent,
    (StubbedRequest.Response.ContentSource.ContentStream as TStringStream).DataString
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockRequestStubTests);
end.
