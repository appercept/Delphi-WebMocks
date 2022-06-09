unit WebMock.JSONMatcher.Tests;

interface

uses
  DUnitX.TestFramework,
  IdCustomHTTPServer,
  WebMock.JSONMatcher;

type

  [TestFixture]
  TWebMockJSONMatcherTests = class(TObject)
  private
    Matcher: TWebMockJSONMatcher;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Class_Always_ImplementsStringMatcher;
    [Test]
    procedure Create_Always_InitializesEmpty;
    [Test]
    procedure Add_Always_AddsValueMatcher;
    [Test]
    procedure Add_CalledMultipleTimes_AddsMultipleValueMatchers;
    [Test]
    procedure Add_GivenPattern_AddsRegExMatcher;
    [Test]
    procedure IsMatch_WhenGivenValueMatchesValue_ReturnsTrue;
    [Test]
    procedure IsMatch_WhenGivenValueDoesNotMatchValue_ReturnsFalse;
    [Test]
    procedure IsMatch_WithMultipleMatchingValues_ReturnsTrue;
    [Test]
    procedure IsMatch_WithPartialMatchingValues_ReturnsFalse;
    [Test]
    procedure ToString_Always_ReturnsJSON;
  end;

implementation

uses
  System.RegularExpressions,
  WebMock.StringMatcher;

{ TWebMockJSONMatcherTests }

procedure TWebMockJSONMatcherTests.Add_Always_AddsValueMatcher;
begin
  Matcher.Add<string>('AName', '*');

  Assert.AreEqual(1, Matcher.ValueMatchers.Count);
end;

procedure TWebMockJSONMatcherTests.Add_CalledMultipleTimes_AddsMultipleValueMatchers;
begin
  Matcher.Add<string>('Path1', '*');
  Matcher.Add<string>('Path2', '*');
  Matcher.Add<string>('Path3', '*');

  Assert.AreEqual(3, Matcher.ValueMatchers.Count);
end;

procedure TWebMockJSONMatcherTests.Add_GivenPattern_AddsRegExMatcher;
begin
  Matcher.Add('/APath', TRegEx.Create('.*'));

  Assert.AreEqual(1, Matcher.ValueMatchers.Count);
end;

procedure TWebMockJSONMatcherTests.Class_Always_ImplementsStringMatcher;
var
  Subject: IInterface;
begin
  Subject := TWebMockJSONMatcher.Create;

  Assert.Implements<IStringMatcher>(Subject);
end;

procedure TWebMockJSONMatcherTests.Create_Always_InitializesEmpty;
begin
  Assert.AreEqual(0, Matcher.ValueMatchers.Count);
end;

procedure TWebMockJSONMatcherTests.IsMatch_WhenGivenValueDoesNotMatchValue_ReturnsFalse;
var
  LJSON: string;
begin
  LJSON := '{ "AName": "OtherValue" }';

  Matcher.Add<string>('AName', 'Value');

  Assert.IsFalse(Matcher.IsMatch(LJSON));
end;

procedure TWebMockJSONMatcherTests.IsMatch_WhenGivenValueMatchesValue_ReturnsTrue;
var
  LJSON: string;
begin
  LJSON := '{ "AName": "Value" }';

  Matcher.Add<string>('AName', 'Value');

  Assert.IsTrue(Matcher.IsMatch(LJSON));
end;

procedure TWebMockJSONMatcherTests.IsMatch_WithMultipleMatchingValues_ReturnsTrue;
var
  LJSON: string;
begin
  LJSON := '{ "key1": "value 1", "key2": 2 }';

  Matcher.Add<string>('key1', 'value 1');
  Matcher.Add<Integer>('key2', 2);

  Assert.IsTrue(Matcher.IsMatch(LJSON));
end;

procedure TWebMockJSONMatcherTests.IsMatch_WithPartialMatchingValues_ReturnsFalse;
var
  LJSON: string;
begin
  LJSON := '{ "key1": "value 1", "key2": 2 }';

  Matcher.Add<string>('key1', 'value 1');
  Matcher.Add<Integer>('key2', 3);

  Assert.IsFalse(Matcher.IsMatch(LJSON));
end;

procedure TWebMockJSONMatcherTests.Setup;
begin
  Matcher := TWebMockJSONMatcher.Create;
end;

procedure TWebMockJSONMatcherTests.TearDown;
begin
  Matcher.Free;
end;

procedure TWebMockJSONMatcherTests.ToString_Always_ReturnsJSON;
begin
  Assert.AreEqual('<JSON>', Matcher.ToString);
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockJSONMatcherTests);
end.
