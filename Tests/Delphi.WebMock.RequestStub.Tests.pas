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
    procedure WithContent_GivenString_ReturnsSelf;
    [Test]
    procedure WithContent_GivenString_SetsValueForContent;
    [Test]
    procedure WithHeader_GivenString_ReturnsSelf;
    [Test]
    procedure WithHeader_GivenString_SetsValueForHeader;
    [Test]
    procedure WithHeader_Always_OverwritesExistingValues;
    [Test]
    procedure WithHeader_GivenRegEx_ReturnsSelf;
    [Test]
    procedure WithHeader_GivenRegEx_SetsPatternForHeader;
    [Test]
    procedure WithHeaders_Always_ReturnsSelf;
    [Test]
    procedure WithHeaders_Always_SetsAllValues;
  end;

implementation

uses
  Delphi.WebMock.Indy.RequestMatcher, Delphi.WebMock.Response,
  Delphi.WebMock.ResponseStatus, Delphi.WebMock.StringMatcher,
  Delphi.WebMock.StringWildcardMatcher, Delphi.WebMock.StringRegExMatcher,
  IdCustomHTTPServer,
  Mock.Indy.HTTPRequestInfo,
  System.Classes, System.RegularExpressions;

{ TWebMockRequestStubTests }

procedure TWebMockRequestStubTests.Setup;
var
  LMatcher: TWebMockIndyRequestMatcher;
begin
  LMatcher := TWebMockIndyRequestMatcher.Create('');
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

procedure TWebMockRequestStubTests.WithContent_GivenString_ReturnsSelf;
begin
  Assert.AreSame(StubbedRequest, StubbedRequest.WithContent('Hello.'));
end;

procedure TWebMockRequestStubTests.WithContent_GivenString_SetsValueForContent;
var
  LContent: string;
begin
  LContent := 'Welcome!';

  StubbedRequest.WithContent(LContent);

  Assert.AreEqual(
    LContent,
    (StubbedRequest.Matcher.Content as TWebMockStringWildcardMatcher).Value
  );
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
    Assert.AreEqual(
      LHeaderValue,
      (StubbedRequest.Matcher.Headers[LHeaderName] as TWebMockStringWildcardMatcher).Value
    );
  end;

  LHeaders.Free;
end;

procedure TWebMockRequestStubTests.WithHeader_Always_OverwritesExistingValues;
var
  LHeaderName, LHeaderValue1, LHeaderValue2: string;
  LMatcher: IStringMatcher;
begin
  LHeaderName := 'Header1';
  LHeaderValue1 := 'Value1';
  LHeaderValue2 := 'Value2';

  StubbedRequest.WithHeader(LHeaderName, LHeaderValue1);
  LMatcher := StubbedRequest.Matcher.Headers[LHeaderName];
  StubbedRequest.WithHeader(LHeaderName, LHeaderValue2);

  Assert.AreNotSame(LMatcher, StubbedRequest.Matcher.Headers[LHeaderName]);
end;

procedure TWebMockRequestStubTests.WithHeader_GivenRegEx_ReturnsSelf;
begin
  Assert.AreSame(
    StubbedRequest,
    StubbedRequest.WithHeader('Header', TRegEx.Create(''))
  );
end;

procedure TWebMockRequestStubTests.WithHeader_GivenRegEx_SetsPatternForHeader;
var
  LHeaderName: string;
  LHeaderPattern: TRegEx;
begin
  LHeaderName := 'Header1';
  LHeaderPattern := TRegEx.Create('');

  StubbedRequest.WithHeader(LHeaderName, LHeaderPattern);

  Assert.AreEqual(
    LHeaderPattern,
    (StubbedRequest.Matcher.Headers[LHeaderName] as TWebMockStringRegExMatcher).RegEx
  );
end;

procedure TWebMockRequestStubTests.WithHeader_GivenString_ReturnsSelf;
begin
  Assert.AreSame(StubbedRequest, StubbedRequest.WithHeader('Header', 'Value'));
end;

procedure TWebMockRequestStubTests.WithHeader_GivenString_SetsValueForHeader;
var
  LHeaderName, LHeaderValue: string;
begin
  LHeaderName := 'Header1';
  LHeaderValue := 'Value1';

  StubbedRequest.WithHeader(LHeaderName, LHeaderValue);

  Assert.AreEqual(
    LHeaderValue,
    (StubbedRequest.Matcher.Headers[LHeaderName] as TWebMockStringWildcardMatcher).Value
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockRequestStubTests);
end.
