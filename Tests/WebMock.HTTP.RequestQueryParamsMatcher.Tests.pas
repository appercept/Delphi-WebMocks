unit WebMock.HTTP.RequestQueryParamsMatcher.Tests;

interface

uses
  DUnitX.TestFramework,
  WebMock.HTTP.RequestMatcher,
  IdCustomHTTPServer;

type

  [TestFixture]
  TWebMockHTTPRequestQueryParamsMatcherTests = class(TObject)
  private
    Matcher: TWebMockHTTPRequestQueryParamsMatcher;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Add_GivenNameAndStringValue_ReturnsIndexOfAddedQueryParamMatcher;
    [Test]
    procedure Add_GivenNameAndStringValue_AddsMatcherToQueryParams;
    [Test]
    procedure Add_GivenNameAndPattern_ReturnsIndexOfAddedQueryParamMatcher;
    [Test]
    procedure Add_GivenNameAndPattern_AddsMatcherToQueryParams;
    [Test]
    procedure IsMatch_WithNoParamsSet_ReturnsTrue;
    [Test]
    procedure IsMatch_WithOneStringMatchingParamSetGivenMatchingURL_ReturnsTrue;
    [Test]
    procedure IsMatch_WithOneStringMatchingParamSetGivenNonMatchingURL_ReturnsFalse;
    [Test]
    procedure IsMatch_WithOnePatternMatchingParamSetGivenMatchingURL_ReturnsTrue;
    [Test]
    procedure IsMatch_WithOnePatternMatchingParamSetGivenNonMatchingURL_ReturnsFalse;
    [Test]
    procedure IsMatch_WithMultipleStringMatchingParamSetGivenMatchingURL_ReturnsTrue;
    [Test]
    procedure IsMatch_WithMultipleStringMatchingParamSetGivenNonMatchingURL_ReturnsFalse;
    [Test]
    procedure IsMatch_WithMultipleStringMatchingParamSetGivenPartialMatchingURL_ReturnsFalse;
    [Test]
    procedure IsMatch_WithMultipleStringMatchingParamWithDuplicateNamesSetGivenMatchingURL_ReturnsTrue;
    [Test]
    procedure IsMatch_WithMultiplePatternMatchingParamSetGivenMatchingURL_ReturnsTrue;
    [Test]
    procedure IsMatch_WithMultiplePatternMatchingParamSetGivenNonMatchingURL_ReturnsFalse;
    [Test]
    procedure IsMatch_WithMultiplePatternMatchingParamSetGivenPartialMatchingURL_ReturnsFalse;
    [Test]
    procedure IsMatch_WithMultiplePatternMatchingParamWithDuplicateNamesSetGivenMatchingURL_ReturnsTrue;
  end;

implementation

uses
  System.RegularExpressions,
  WebMock.StringRegExMatcher,
  WebMock.StringWildcardMatcher;

{ TWebMockHTTPRequestQueryParamsMatcherTests }

procedure TWebMockHTTPRequestQueryParamsMatcherTests.Add_GivenNameAndPattern_AddsMatcherToQueryParams;
var
  LPattern: TRegEx;
begin
  LPattern := TRegEx.Create('Value');
  Matcher.Add('Name', LPattern);

  Assert.AreEqual('Name', Matcher.QueryParams.First.Name);
  Assert.AreEqual(
    LPattern,
    (Matcher.QueryParams.First.ValueMatcher as TWebMockStringRegExMatcher).RegEx
  );
end;

procedure TWebMockHTTPRequestQueryParamsMatcherTests.Add_GivenNameAndPattern_ReturnsIndexOfAddedQueryParamMatcher;
begin
  Assert.AreEqual(0, Matcher.Add('Name', TRegEx.Create('Value')));
end;

procedure TWebMockHTTPRequestQueryParamsMatcherTests.Add_GivenNameAndStringValue_AddsMatcherToQueryParams;
begin
  Matcher.Add('Name', 'Value');

  Assert.AreEqual('Name', Matcher.QueryParams.First.Name);
  Assert.AreEqual('Value', (Matcher.QueryParams.First.ValueMatcher as TWebMockStringWildcardMatcher).Value);
end;

procedure TWebMockHTTPRequestQueryParamsMatcherTests.Add_GivenNameAndStringValue_ReturnsIndexOfAddedQueryParamMatcher;
begin
  Assert.AreEqual(0, Matcher.Add('Name', 'Value'));
end;

procedure TWebMockHTTPRequestQueryParamsMatcherTests.IsMatch_WithMultiplePatternMatchingParamSetGivenMatchingURL_ReturnsTrue;
begin
  Matcher.Add('Name1', TRegEx.Create('Value1'));
  Matcher.Add('Name2', TRegEx.Create('Value2'));

  Assert.IsTrue(Matcher.IsMatch('http://example.com?Name1=Value1&Name2=Value2'));
end;

procedure TWebMockHTTPRequestQueryParamsMatcherTests.IsMatch_WithMultiplePatternMatchingParamSetGivenNonMatchingURL_ReturnsFalse;
begin
  Matcher.Add('Name1', TRegEx.Create('Value1'));
  Matcher.Add('Name2', TRegEx.Create('Value2'));

  Assert.IsFalse(Matcher.IsMatch('http://example.com'));
end;

procedure TWebMockHTTPRequestQueryParamsMatcherTests.IsMatch_WithMultiplePatternMatchingParamSetGivenPartialMatchingURL_ReturnsFalse;
begin
  Matcher.Add('Name1', TRegEx.Create('Value1'));
  Matcher.Add('Name2', TRegEx.Create('Value2'));

  Assert.IsFalse(Matcher.IsMatch('http://example.com?Name1=Value1'));
end;

procedure TWebMockHTTPRequestQueryParamsMatcherTests.IsMatch_WithMultiplePatternMatchingParamWithDuplicateNamesSetGivenMatchingURL_ReturnsTrue;
begin
  Matcher.Add('Name', TRegEx.Create('Value1'));
  Matcher.Add('Name', TRegEx.Create('Value2'));

  Assert.IsTrue(Matcher.IsMatch('http://example.com?Name=Value1&Name=Value2'));
end;

procedure TWebMockHTTPRequestQueryParamsMatcherTests.IsMatch_WithMultipleStringMatchingParamSetGivenMatchingURL_ReturnsTrue;
begin
  Matcher.Add('Name1', 'Value1');
  Matcher.Add('Name2', 'Value2');

  Assert.IsTrue(Matcher.IsMatch('http://example.com?Name1=Value1&Name2=Value2'));
end;

procedure TWebMockHTTPRequestQueryParamsMatcherTests.IsMatch_WithMultipleStringMatchingParamSetGivenNonMatchingURL_ReturnsFalse;
begin
  Matcher.Add('Name1', 'Value1');
  Matcher.Add('Name2', 'Value2');

  Assert.IsFalse(Matcher.IsMatch('http://example.com'));
end;

procedure TWebMockHTTPRequestQueryParamsMatcherTests.IsMatch_WithMultipleStringMatchingParamSetGivenPartialMatchingURL_ReturnsFalse;
begin
  Matcher.Add('Name1', 'Value1');
  Matcher.Add('Name2', 'Value2');

  Assert.IsFalse(Matcher.IsMatch('http://example.com?Name1=Value1'));
end;

procedure TWebMockHTTPRequestQueryParamsMatcherTests.IsMatch_WithMultipleStringMatchingParamWithDuplicateNamesSetGivenMatchingURL_ReturnsTrue;
begin
  Matcher.Add('Name', 'Value1');
  Matcher.Add('Name', 'Value2');

  Assert.IsTrue(Matcher.IsMatch('http://example.com?Name=Value1&Name=Value2'));
end;

procedure TWebMockHTTPRequestQueryParamsMatcherTests.IsMatch_WithNoParamsSet_ReturnsTrue;
begin
  Assert.IsTrue(Matcher.IsMatch('http://example.com'));
end;

procedure TWebMockHTTPRequestQueryParamsMatcherTests.IsMatch_WithOnePatternMatchingParamSetGivenMatchingURL_ReturnsTrue;
begin
  Matcher.Add('Name', TRegEx.Create('Value'));

  Assert.IsTrue(Matcher.IsMatch('http://example.com?Name=Value'));
end;

procedure TWebMockHTTPRequestQueryParamsMatcherTests.IsMatch_WithOnePatternMatchingParamSetGivenNonMatchingURL_ReturnsFalse;
begin
  Matcher.Add('Name', TRegEx.Create('Value'));

  Assert.IsFalse(Matcher.IsMatch('http://example.com?Name=Other'));
end;

procedure TWebMockHTTPRequestQueryParamsMatcherTests.IsMatch_WithOneStringMatchingParamSetGivenMatchingURL_ReturnsTrue;
begin
  Matcher.Add('Name', 'Value');

  Assert.IsTrue(Matcher.IsMatch('http://example.com?Name=Value'));
end;

procedure TWebMockHTTPRequestQueryParamsMatcherTests.IsMatch_WithOneStringMatchingParamSetGivenNonMatchingURL_ReturnsFalse;
begin
  Matcher.Add('Name', 'Value');

  Assert.IsFalse(Matcher.IsMatch('http://example.com?Name=OtherValue'));
end;

procedure TWebMockHTTPRequestQueryParamsMatcherTests.Setup;
begin
  Matcher := TWebMockHTTPRequestQueryParamsMatcher.Create;
end;

procedure TWebMockHTTPRequestQueryParamsMatcherTests.TearDown;
begin
  Matcher.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockHTTPRequestQueryParamsMatcherTests);
end.
