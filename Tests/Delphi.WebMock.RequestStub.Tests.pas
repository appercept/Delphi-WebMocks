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

uses
  Delphi.WebMock.Indy.RequestMatcher,
  Delphi.WebMock.Response,
  Delphi.WebMock.ResponseStatus,
  IdCustomHTTPServer,
  Mock.Indy.HTTPRequestInfo,
  System.Classes;

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

procedure TWebMockRequestStubTests.WithHeaders_Always_ReturnsSelf;
var
  LHeaders: TStringList;
  LHeaderName, LHeaderValue: string;
  I: Integer;
begin
  LHeaders := TStringList.Create;

  Assert.AreSame(StubbedRequest, StubbedRequest.WithHeaders(LHeaders));

  LHeaders.Free;
end;

procedure TWebMockRequestStubTests.WithHeaders_Always_SetsAllValues;
var
  LHeaders: TStringList;
  LHeaderName, LHeaderValue: string;
  I: Integer;
begin
  LHeaders := TStringList.Create;
  LHeaders.Values['Header1'] := 'Value1';
  LHeaders.Values['Header2'] := 'Value2';

  StubbedRequest.WithHeaders(LHeaders);

  for I := 0 to LHeaders.Count - 1 do
  begin
    LHeaderName := LHeaders.Names[I];
    LHeaderValue := LHeaders.ValueFromIndex[I];
    Assert.AreEqual(LHeaderValue, StubbedRequest.Matcher.Headers[LHeaderName]);
  end;

  LHeaders.Free;
end;

procedure TWebMockRequestStubTests.WithHeader_Always_OverwritesExistingValues;
var
  LHeaderName, LHeaderValue1, LHeaderValue2: string;
begin
  LHeaderName := 'Header1';
  LHeaderValue1 := 'Value1';
  LHeaderValue2 := 'Value2';

  StubbedRequest.WithHeader(LHeaderName, LHeaderValue1);
  StubbedRequest.WithHeader(LHeaderName, LHeaderValue2);

  Assert.AreEqual(LHeaderValue2, StubbedRequest.Matcher.Headers[LHeaderName]);
end;

procedure TWebMockRequestStubTests.WithHeader_Always_ReturnsSelf;
begin
  Assert.AreSame(StubbedRequest, StubbedRequest.WithHeader('Header', 'Value'));
end;

procedure TWebMockRequestStubTests.WithHeader_Always_SetsValueForHeader;
var
  LHeaderName, LHeaderValue: string;
begin
  LHeaderName := 'Header1';
  LHeaderValue := 'Value1';

  StubbedRequest.WithHeader(LHeaderName, LHeaderValue);

  Assert.AreEqual(LHeaderValue, StubbedRequest.Matcher.Headers[LHeaderName]);
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockRequestStubTests);
end.
