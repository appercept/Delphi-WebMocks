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
    [TestCase('HTTPMethod GET', 'HTTPMethod,GET')]
    procedure StringProperty_Defaults_ToValue(APropertyName, Expected: string);
    [Test]
    procedure Headers_Always_IsADictionary;
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
    [Test]
    procedure IsMatch_WhenHeadersAreSetGivenMatchingRequestInfo_ReturnsTrue;
    [Test]
    procedure IsMatch_WhenHeadersAreSetGivenNonMatchingRequestInfo_ReturnsFalse;
  end;

implementation

uses
  Delphi.WebMock.StringMatcher, Delphi.WebMock.StringWildcardMatcher,
  Mock.Indy.HTTPRequestInfo,
  TestHelpers,
  System.Generics.Collections;

{ TWebMockIndyRequestMatcherTests }

procedure TWebMockIndyRequestMatcherTests.Setup;
begin
  RequestMatcher := TWebMockIndyRequestMatcher.Create('');
end;

procedure TWebMockIndyRequestMatcherTests.TearDown;
begin
  RequestMatcher := nil;
end;

procedure TWebMockIndyRequestMatcherTests.Headers_Always_IsADictionary;
begin
  Assert.IsTrue(RequestMatcher.Headers is TDictionary<string, IStringMatcher>);
end;

procedure TWebMockIndyRequestMatcherTests.IsMatch_GivenAMatchingRequestInfo_ReturnsTrue;
var
  LRequestInfo: TIdHTTPRequestInfo;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/match');

  RequestMatcher := TWebMockIndyRequestMatcher.Create('/match', 'GET');

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

  RequestMatcher := TWebMockIndyRequestMatcher.Create('/match', 'GET');

  Assert.IsFalse(RequestMatcher.IsMatch(LRequestInfo));
end;

procedure TWebMockIndyRequestMatcherTests.IsMatch_WhenHeadersAreSetGivenMatchingRequestInfo_ReturnsTrue;
var
  LRequestInfo: TIdHTTPRequestInfo;
  LHeaderName, LHeaderValue: string;
begin
  LHeaderName := 'Header1';
  LHeaderValue := 'Value1';
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/match');
  LRequestInfo.RawHeaders.AddValue(LHeaderName, LHeaderValue);

  RequestMatcher := TWebMockIndyRequestMatcher.Create('/match', 'GET');
  RequestMatcher.Headers.AddOrSetValue(
    LHeaderName, TWebMockStringWildcardMatcher.Create(LHeaderValue)
  );

  Assert.IsTrue(RequestMatcher.IsMatch(LRequestInfo));
end;

procedure TWebMockIndyRequestMatcherTests.IsMatch_WhenHeadersAreSetGivenNonMatchingRequestInfo_ReturnsFalse;
var
  LRequestInfo: TIdHTTPRequestInfo;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/match');

  RequestMatcher := TWebMockIndyRequestMatcher.Create('/match', 'GET');
  RequestMatcher.Headers.AddOrSetValue(
    'Header1', TWebMockStringWildcardMatcher.Create('Value1')
  );

  Assert.IsFalse(RequestMatcher.IsMatch(LRequestInfo));
end;

procedure TWebMockIndyRequestMatcherTests.IsMatch_WhenMethodIsWildcardGivenAnyRequestInfoMethod_ReturnsTrue;
var
  LRequestInfo: TIdHTTPRequestInfo;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('HEAD');

  RequestMatcher := TWebMockIndyRequestMatcher.Create('*', '*');

  Assert.IsTrue(RequestMatcher.IsMatch(LRequestInfo));
end;

procedure TWebMockIndyRequestMatcherTests.IsMatch_WhenURIIsWildcardGivenAnyRequestInfoURI_ReturnsTrue;
var
  LRequestInfo: TIdHTTPRequestInfo;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/match');

  RequestMatcher := TWebMockIndyRequestMatcher.Create('*', 'GET');

  Assert.IsTrue(RequestMatcher.IsMatch(LRequestInfo));
end;

procedure TWebMockIndyRequestMatcherTests.StringProperty_Defaults_ToValue(
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
