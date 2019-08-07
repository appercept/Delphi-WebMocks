unit Delphi.WebMock.Indy.RequestMatcher.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock.Indy.RequestMatcher,
  IdCustomHTTPServer;

type

  [TestFixture]
  TWebMockIndyRequestMatcherTests = class(TObject)
  private
    RequestMatcher: TWebMockIndyRequestMatcher;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    [TestCase('HTTPMethod', 'HTTPMethod,GET')]
    [TestCase('HTTPMethod', 'URI,*')]
    procedure Test_StringProperty_Defaults_ToValue(APropertyName,
      Expected: string);
    [Test]
    procedure IsMatch_GivenAMatchingRequestInfo_ReturnsTrue;
    [Test]
    procedure IsMatch_WhenMethodIsWildcardGivenAnyRequestInfoMethod_ReturnsTrue;
    [Test]
    procedure IsMatch_WhenURIIsWildcardGivenAnyRequestInfoURI_ReturnsTrue;
    [Test]
    procedure IsMatch_GivenDifferingHTTPMethod_ReturnsFalse;
    [Test]
    procedure IsMatch_GivenDifferingURI_ReturnsFalse;
  end;

implementation

uses
  Mock.Indy.HTTPRequestInfo,
  TestHelpers;

{ TWebMockIndyRequestMatcherTests }

procedure TWebMockIndyRequestMatcherTests.Setup;
begin
  RequestMatcher := TWebMockIndyRequestMatcher.Create;
end;

procedure TWebMockIndyRequestMatcherTests.TearDown;
begin
  RequestMatcher := nil;
end;

procedure TWebMockIndyRequestMatcherTests.IsMatch_GivenAMatchingRequestInfo_ReturnsTrue;
var
  LRequestInfo: TIdHTTPRequestInfo;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/match');

  RequestMatcher := TWebMockIndyRequestMatcher.Create('GET', '/match');

  Assert.IsTrue(RequestMatcher.IsMatch(LRequestInfo));
end;

procedure TWebMockIndyRequestMatcherTests.IsMatch_GivenDifferingHTTPMethod_ReturnsFalse;
var
  LRequestInfo: TIdHTTPRequestInfo;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('HEAD');

  RequestMatcher := TWebMockIndyRequestMatcher.Create('GET');

  Assert.IsFalse(RequestMatcher.IsMatch(LRequestInfo));
end;

procedure TWebMockIndyRequestMatcherTests.IsMatch_GivenDifferingURI_ReturnsFalse;
var
  LRequestInfo: TIdHTTPRequestInfo;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/no-match');

  RequestMatcher := TWebMockIndyRequestMatcher.Create('GET', '/match');

  Assert.IsFalse(RequestMatcher.IsMatch(LRequestInfo));
end;

procedure TWebMockIndyRequestMatcherTests.IsMatch_WhenMethodIsWildcardGivenAnyRequestInfoMethod_ReturnsTrue;
var
  LRequestInfo: TIdHTTPRequestInfo;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('HEAD');

  RequestMatcher := TWebMockIndyRequestMatcher.Create('*');

  Assert.IsTrue(RequestMatcher.IsMatch(LRequestInfo));
end;

procedure TWebMockIndyRequestMatcherTests.IsMatch_WhenURIIsWildcardGivenAnyRequestInfoURI_ReturnsTrue;
var
  LRequestInfo: TIdHTTPRequestInfo;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/match');

  RequestMatcher := TWebMockIndyRequestMatcher.Create('GET', '*');

  Assert.IsTrue(RequestMatcher.IsMatch(LRequestInfo));
end;

procedure TWebMockIndyRequestMatcherTests.Test_StringProperty_Defaults_ToValue(
  APropertyName, Expected: string);
var
  Actual: string;
begin
  Actual := GetPropertyValue(RequestMatcher, APropertyName).ToString;

  Assert.AreEqual(Expected, Actual);
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockIndyRequestMatcherTests);
end.
