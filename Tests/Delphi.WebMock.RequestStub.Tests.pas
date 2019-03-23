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
    procedure Test_ToReturn_WithNoArguments_DoesNothing;
    [Test]
    procedure Test_ToReturn_WithResponse_SetsResponse;
  end;

implementation

uses
  Delphi.WebMock.Indy.RequestMatcher,
  Delphi.WebMock.ResponseStatus,
  IdCustomHTTPServer,
  Mock.Indy.HTTPRequestInfo,
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
  Assert.AreEqual(StubbedRequest, StubbedRequest.ToReturn as TWebMockRequestStub);
end;

procedure TWebMockRequestStubTests.Test_ToReturn_WithNoArguments_DoesNothing;
begin
  Assert.WillNotRaiseAny(
  procedure
  begin
    StubbedRequest.ToReturn;
  end);
end;

procedure TWebMockRequestStubTests.Test_ToReturn_WithResponse_SetsResponse;
var
  LResponse: TWebMockResponseStatus;
begin
  LResponse := TWebMockResponseStatus.Continue;

  StubbedRequest.ToReturn(LResponse);

  Assert.AreSame(LResponse, StubbedRequest.Response.Status);
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockRequestStubTests);
end.
