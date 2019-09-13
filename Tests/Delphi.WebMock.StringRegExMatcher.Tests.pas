unit Delphi.WebMock.StringRegExMatcher.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock.StringRegExMatcher,
  IdCustomHTTPServer;

type

  [TestFixture]
  TWebMockStringRegExMatcherTests = class(TObject)
  private
    StringRegExMatcher: TWebMockStringRegExMatcher;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Class_Always_ImplementsStringMatcher;
    [Test]
    procedure IsMatch_WhenGivenValueMatchesRegEx_ReturnsTrue;
    [Test]
    procedure IsMatch_WhenGivenValueDoesNotMatchRegEx_ReturnsFalse;
    [Test]
    procedure ToString_Always_ReturnsRegularExpression;
  end;

implementation

{ TWebMockStringRegExMatcherTests }

uses
  Delphi.WebMock.StringMatcher,
  System.RegularExpressions;

procedure TWebMockStringRegExMatcherTests.Class_Always_ImplementsStringMatcher;
var
  Subject: IInterface;
begin
  Subject := TWebMockStringRegExMatcher.Create(TRegEx.Create(''));

  Assert.Implements<IStringMatcher>(Subject);
end;

procedure TWebMockStringRegExMatcherTests.IsMatch_WhenGivenValueDoesNotMatchRegEx_ReturnsFalse;
var
  LRegEx: TRegEx;
begin
  LRegEx := TRegEx.Create('A\ Value');
  StringRegExMatcher := TWebMockStringRegExMatcher.Create(LRegEx);

  Assert.IsFalse(StringRegExMatcher.IsMatch('Other Value'));
end;

procedure TWebMockStringRegExMatcherTests.IsMatch_WhenGivenValueMatchesRegEx_ReturnsTrue;
var
  LRegEx: TRegEx;
begin
  LRegEx := TRegEx.Create('A\ Value');
  StringRegExMatcher := TWebMockStringRegExMatcher.Create(LRegEx);

  Assert.IsTrue(StringRegExMatcher.IsMatch('A Value'));
end;

procedure TWebMockStringRegExMatcherTests.Setup;
begin

end;

procedure TWebMockStringRegExMatcherTests.TearDown;
begin
  StringRegExMatcher.Free;
end;

procedure TWebMockStringRegExMatcherTests.ToString_Always_ReturnsRegularExpression;
var
  LRegEx: TRegEx;
begin
  LRegEx := TRegEx.Create('');
  StringRegExMatcher := TWebMockStringRegExMatcher.Create(LRegEx);

  Assert.AreEqual('Regular Expression', StringRegExMatcher.ToString);
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockStringRegExMatcherTests);
end.
