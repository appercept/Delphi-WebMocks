unit Delphi.WebMock.StringAnyMatcher.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock.StringAnyMatcher,
  IdCustomHTTPServer;

type

  [TestFixture]
  TWebMockStringAnyMatcherTests = class(TObject)
  private
    StringAnyMatcher: TWebMockStringAnyMatcher;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure IsMatch_Always_ReturnsTrue;
    [Test]
    procedure ToString_Always_ReturnsWildcard;
  end;

implementation

{ TWebMockStringAnyMatcherTests }

procedure TWebMockStringAnyMatcherTests.IsMatch_Always_ReturnsTrue;
begin
  Assert.IsTrue(StringAnyMatcher.IsMatch('Any Value'));
end;

procedure TWebMockStringAnyMatcherTests.Setup;
begin
  StringAnyMatcher := TWebMockStringAnyMatcher.Create;
end;

procedure TWebMockStringAnyMatcherTests.TearDown;
begin
  StringAnyMatcher.Free;
end;

procedure TWebMockStringAnyMatcherTests.ToString_Always_ReturnsWildcard;
begin
  Assert.AreEqual('*', StringAnyMatcher.ToString);
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockStringAnyMatcherTests);
end.
