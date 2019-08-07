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
    procedure ToReturn_Always_ReturnsAResponseStub;
    [Test]
    procedure ToReturn_WithNoArguments_DoesNotRaiseException;
    [Test]
    procedure ToReturn_WithNoArguments_DoesNotChangeStatus;
    [Test]
    procedure ToReturn_WithResponse_SetsResponseStatus;
  end;

implementation

uses
  Delphi.WebMock.Indy.RequestMatcher,
  Delphi.WebMock.Response,
  Delphi.WebMock.ResponseStatus,
  IdCustomHTTPServer,
  Mock.Indy.HTTPRequestInfo;

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

procedure TWebMockRequestStubTests.ToReturn_Always_ReturnsAResponseStub;
begin
  Assert.IsTrue(StubbedRequest.ToReturn is TWebMockResponse);
end;

procedure TWebMockRequestStubTests.ToReturn_WithNoArguments_DoesNotRaiseException;
begin
  Assert.WillNotRaiseAny(
  procedure
  begin
    StubbedRequest.ToReturn;
  end);
end;

procedure TWebMockRequestStubTests.ToReturn_WithNoArguments_DoesNotChangeStatus;
var
  LExpectedStatus: TWebMockResponseStatus;
begin
  LExpectedStatus := StubbedRequest.Response.Status;

  StubbedRequest.ToReturn;

  Assert.AreSame(LExpectedStatus, StubbedRequest.Response.Status);
end;

procedure TWebMockRequestStubTests.ToReturn_WithResponse_SetsResponseStatus;
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
