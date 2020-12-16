unit WebMock.FormFieldMatcher.Tests;

interface

uses
  DUnitX.TestFramework,
  IdCustomHTTPServer,
  WebMock.FormFieldMatcher;

type

  [TestFixture]
  TWebMockFormFieldMatcherTests = class(TObject)
  private
    Matcher: TWebMockFormFieldMatcher;
  public
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Class_Always_ImplementsStringMatcher;
    [Test]
    procedure Name_Always_IsInitializedValue;
    [Test]
    procedure Value_WhenNotInitialized_IsWildcard;
    [Test]
    procedure Value_WithInitializedValue_IsGivenValue;
    [Test]
    procedure Value_WithInitializedRegex_IsGivenPattern;
    [Test]
    procedure IsMatch_WhenGivenNameAndValueMatchesValue_ReturnsTrue;
    [Test]
    procedure IsMatch_WhenGivenNameDoesNotMatchValue_ReturnsFalse;
    [Test]
    procedure IsMatch_WhenGivenValueDoesNotMatchValue_ReturnsFalse;
    [Test]
    procedure IsMatch_WhenInitializedValueIsWildcard_ReturnsTrue;
    [Test]
    procedure IsMatch_WhenGivenEncodedNameMatchingValue_ReturnsTrue;
    [Test]
    procedure IsMatch_WhenGivenEncodedValueMatchingValue_ReturnsTrue;
    [Test]
    procedure ToString_Always_ReturnsInitializedValue;
  end;

implementation

uses
  System.RegularExpressions,
  WebMock.StringRegExMatcher,
  WebMock.StringMatcher,
  WebMock.StringWildcardMatcher;

{ TWebMockFormFieldMatcherTests }

procedure TWebMockFormFieldMatcherTests.Class_Always_ImplementsStringMatcher;
var
  Subject: IInterface;
begin
  Subject := TWebMockFormFieldMatcher.Create('AName');

  Assert.Implements<IStringMatcher>(Subject);
end;

procedure TWebMockFormFieldMatcherTests.IsMatch_WhenGivenValueDoesNotMatchValue_ReturnsFalse;
var
  LExpectedName, LExpectedValue: string;
  LFormData: string;
begin
  LExpectedName := 'AName';
  LExpectedValue := 'AValue';
  LFormData := 'AName=OtherValue';
  Matcher := TWebMockFormFieldMatcher.Create(LExpectedName, LExpectedValue);

  Assert.IsFalse(Matcher.IsMatch(LFormData));
end;

procedure TWebMockFormFieldMatcherTests.IsMatch_WhenGivenEncodedNameMatchingValue_ReturnsTrue;
var
  LExpectedName, LExpectedValue: string;
  LFormData: string;
begin
  LExpectedName := 'A Name';
  LExpectedValue := 'AValue';
  LFormData := 'A%20Name=AValue';
  Matcher := TWebMockFormFieldMatcher.Create(LExpectedName, LExpectedValue);

  Assert.IsTrue(Matcher.IsMatch(LFormData));
end;

procedure TWebMockFormFieldMatcherTests.IsMatch_WhenGivenEncodedValueMatchingValue_ReturnsTrue;
var
  LExpectedName, LExpectedValue: string;
  LFormData: string;
begin
  LExpectedName := 'AName';
  LExpectedValue := 'A Value';
  LFormData := 'AName=A%20Value';
  Matcher := TWebMockFormFieldMatcher.Create(LExpectedName, LExpectedValue);

  Assert.IsTrue(Matcher.IsMatch(LFormData));
end;

procedure TWebMockFormFieldMatcherTests.IsMatch_WhenGivenNameAndValueMatchesValue_ReturnsTrue;
var
  LExpectedName, LExpectedValue: string;
  LFormData: string;
begin
  LExpectedName := 'AName';
  LExpectedValue := 'AValue';
  LFormData := 'AName=AValue';
  Matcher := TWebMockFormFieldMatcher.Create(LExpectedName, LExpectedValue);

  Assert.IsTrue(Matcher.IsMatch(LFormData));
end;

procedure TWebMockFormFieldMatcherTests.IsMatch_WhenGivenNameDoesNotMatchValue_ReturnsFalse;
var
  LExpectedName, LExpectedValue: string;
  LFormData: string;
begin
  LExpectedName := 'AName';
  LExpectedValue := 'AValue';
  LFormData := 'OtherName=AValue';
  Matcher := TWebMockFormFieldMatcher.Create(LExpectedName, LExpectedValue);

  Assert.IsFalse(Matcher.IsMatch(LFormData));
end;

procedure TWebMockFormFieldMatcherTests.IsMatch_WhenInitializedValueIsWildcard_ReturnsTrue;
var
  LExpectedName, LExpectedValue: string;
  LFormData: string;
begin
  LExpectedName := 'AName';
  LExpectedValue := '*';
  LFormData := 'AName=OtherValue';
  Matcher := TWebMockFormFieldMatcher.Create(LExpectedName, LExpectedValue);

  Assert.IsTrue(Matcher.IsMatch(LFormData));
end;

procedure TWebMockFormFieldMatcherTests.Name_Always_IsInitializedValue;
var
  LName: string;
begin
  LName := 'AName';

  Matcher := TWebMockFormFieldMatcher.Create(LName);

  Assert.AreEqual(LName, Matcher.Name);
end;

procedure TWebMockFormFieldMatcherTests.TearDown;
begin
  Matcher.Free;
end;

procedure TWebMockFormFieldMatcherTests.ToString_Always_ReturnsInitializedValue;
begin
  Matcher := TWebMockFormFieldMatcher.Create('AName');

  Assert.AreEqual('AName=*', Matcher.ToString);
end;

procedure TWebMockFormFieldMatcherTests.Value_WhenNotInitialized_IsWildcard;
begin
  Matcher := TWebMockFormFieldMatcher.Create('AName');

  Assert.AreEqual(
    '*',
    (Matcher.ValueMatcher as TWebMockStringWildcardMatcher).Value
  );
end;

procedure TWebMockFormFieldMatcherTests.Value_WithInitializedRegex_IsGivenPattern;
var
  LExpected: TRegEx;
begin
  LExpected := TRegEx.Create('');

  Matcher := TWebMockFormFieldMatcher.Create('AName', LExpected);

  Assert.AreEqual(
    LExpected,
    (Matcher.ValueMatcher as TWebMockStringRegExMatcher).RegEx
  );
end;

procedure TWebMockFormFieldMatcherTests.Value_WithInitializedValue_IsGivenValue;
var
  LExpected: string;
begin
  LExpected := 'A Value';

  Matcher := TWebMockFormFieldMatcher.Create('AName', LExpected);

  Assert.AreEqual(
    LExpected,
    (Matcher.ValueMatcher as TWebMockStringWildcardMatcher).Value
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockFormFieldMatcherTests);
end.
