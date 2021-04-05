unit WebMock.XMLMatcher.Tests;

interface

uses
  DUnitX.TestFramework,
  IdCustomHTTPServer,
  WebMock.XMLMatcher;

type

  [TestFixture]
  TWebMockXMLMatcherTests = class(TObject)
  private
    Matcher: TWebMockXMLMatcher;
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
    procedure ToString_Always_ReturnsXML;
  end;

implementation

uses
  System.RegularExpressions,
  WebMock.StringMatcher;

{ TWebMockXMLMatcherTests }

procedure TWebMockXMLMatcherTests.Add_Always_AddsValueMatcher;
begin
  Matcher.Add('/APath', '*');

  Assert.AreEqual(1, Matcher.ValueMatchers.Count);
end;

procedure TWebMockXMLMatcherTests.Add_CalledMultipleTimes_AddsMultipleValueMatchers;
begin
  Matcher.Add('Path1', '*');
  Matcher.Add('Path2', '*');
  Matcher.Add('Path3', '*');

  Assert.AreEqual(3, Matcher.ValueMatchers.Count);
end;

procedure TWebMockXMLMatcherTests.Add_GivenPattern_AddsRegExMatcher;
begin
  Matcher.Add('/APath', TRegEx.Create('.*'));

  Assert.AreEqual(1, Matcher.ValueMatchers.Count);
end;

procedure TWebMockXMLMatcherTests.Class_Always_ImplementsStringMatcher;
var
  Subject: IInterface;
begin
  Subject := TWebMockXMLMatcher.Create;

  Assert.Implements<IStringMatcher>(Subject);
end;

procedure TWebMockXMLMatcherTests.Create_Always_InitializesEmpty;
begin
  Assert.AreEqual(0, Matcher.ValueMatchers.Count);
end;

procedure TWebMockXMLMatcherTests.IsMatch_WhenGivenValueDoesNotMatchValue_ReturnsFalse;
var
  LXML: string;
begin
  LXML := '<Key>OtherValue</Key>';

  Matcher.Add('/Key', 'Value');

  Assert.IsFalse(Matcher.IsMatch(LXML));
end;

procedure TWebMockXMLMatcherTests.IsMatch_WhenGivenValueMatchesValue_ReturnsTrue;
var
  LXML: string;
begin
  LXML := '<Key>Value</Key>';

  Matcher.Add('/Key', 'Value');

  Assert.IsTrue(Matcher.IsMatch(LXML));
end;

procedure TWebMockXMLMatcherTests.IsMatch_WithMultipleMatchingValues_ReturnsTrue;
var
  LXML: string;
begin
  LXML := '<Object><Key1>Value 1</Key1><Key2>Value 2</Key2></Object>';

  Matcher.Add('/Object/Key1', 'Value 1');
  Matcher.Add('/Object/Key2', 'Value 2');

  Assert.IsTrue(Matcher.IsMatch(LXML));
end;

procedure TWebMockXMLMatcherTests.IsMatch_WithPartialMatchingValues_ReturnsFalse;
var
  LXML: string;
begin
  LXML := '<Object><Key1>Value 1</Key1><Key2>Value 2</Key2></Object>';

  Matcher.Add('/Object/Key1', 'Value 1');
  Matcher.Add('/Object/Key2', 'Value 3');

  Assert.IsFalse(Matcher.IsMatch(LXML));
end;

procedure TWebMockXMLMatcherTests.Setup;
begin
  Matcher := TWebMockXMLMatcher.Create;
end;

procedure TWebMockXMLMatcherTests.TearDown;
begin
  Matcher.Free;
end;

procedure TWebMockXMLMatcherTests.ToString_Always_ReturnsXML;
begin
  Assert.AreEqual('<XML>', Matcher.ToString);
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockXMLMatcherTests);
end.
