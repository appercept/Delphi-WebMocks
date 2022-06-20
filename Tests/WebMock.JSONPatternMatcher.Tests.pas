unit WebMock.JSONPatternMatcher.Tests;

interface

uses
  DUnitX.TestFramework,
  WebMock.JSONMatcher;

type
  [TestFixture]
  TWebMockJSONPatternMatcherTests = class(TObject)
  public
    [Test]
    procedure Create_Always_RequiresPathAndPattern;
    [Test]
    procedure IsMatch_MatchingString_ReturnsTrue;
    [Test]
    procedure IsMatch_NotMatchingString_ReturnsFalse;
    [Test]
    procedure IsMatch_MatchingObjectPath_ReturnsTrue;
    [Test]
    procedure IsMatch_NotMatchingObjectPath_ReturnsFalse;
    [Test]
    procedure IsMatch_MatchingArrayPath_ReturnsTrue;
    [Test]
    procedure IsMatch_NotMatchingArrayPath_ReturnsFalse;
  end;

implementation

uses
  System.JSON,
  System.RegularExpressions;

{ TWebMockJSONPatternMatcherTests }

procedure TWebMockJSONPatternMatcherTests.Create_Always_RequiresPathAndPattern;
var
  LMatcher: TWebMockJSONPatternMatcher;
begin
  LMatcher := TWebMockJSONPatternMatcher.Create('APath', TRegEx.Create('\d+'));

  LMatcher.Free;

  Assert.Pass('Create takes path and value');
end;

procedure TWebMockJSONPatternMatcherTests.IsMatch_MatchingArrayPath_ReturnsTrue;
var
  LJSON: TJSONValue;
  LMatcher: TWebMockJSONPatternMatcher;
begin
  LJSON := TJSONObject.ParseJSONValue(
    '{ "objects": [{ "key": "abc" }, { "key": "123" }] }'
  );

  LMatcher := TWebMockJSONPatternMatcher.Create(
    'objects[1].key',
    TRegEx.Create('\d+')
  );
  Assert.IsTrue(LMatcher.IsMatch(LJSON));

  LMatcher.Free;
  LJSON.Free;
end;

procedure TWebMockJSONPatternMatcherTests.IsMatch_MatchingObjectPath_ReturnsTrue;
var
  LJSON: TJSONValue;
  LMatcher: TWebMockJSONPatternMatcher;
begin
  LJSON := TJSONObject.ParseJSONValue('{ "object": { "key": "abc" } }');

  LMatcher := TWebMockJSONPatternMatcher.Create(
    'object.key',
    TRegEx.Create('[a-z]+')
  );
  Assert.IsTrue(LMatcher.IsMatch(LJSON));

  LMatcher.Free;
  LJSON.Free;
end;

procedure TWebMockJSONPatternMatcherTests.IsMatch_MatchingString_ReturnsTrue;
var
  LJSON: TJSONValue;
  LMatcher: TWebMockJSONPatternMatcher;
begin
  LJSON := TJSONObject.ParseJSONValue('{ "key": "value" }');

  LMatcher := TWebMockJSONPatternMatcher.Create('key', TRegEx.Create('value'));
  Assert.IsTrue(LMatcher.IsMatch(LJSON));

  LMatcher.Free;
  LJSON.Free;
end;

procedure TWebMockJSONPatternMatcherTests.IsMatch_NotMatchingArrayPath_ReturnsFalse;
var
  LJSON: TJSONValue;
  LMatcher: TWebMockJSONPatternMatcher;
begin
  LJSON := TJSONObject.ParseJSONValue(
    '{ "objects": [{ "key": "abc" }, { "key": "123" }] }'
  );

  LMatcher := TWebMockJSONPatternMatcher.Create('objects[0].key', TRegEx.Create('\d+'));
  Assert.IsFalse(LMatcher.IsMatch(LJSON));

  LMatcher.Free;
  LJSON.Free;
end;

procedure TWebMockJSONPatternMatcherTests.IsMatch_NotMatchingObjectPath_ReturnsFalse;
var
  LJSON: TJSONValue;
  LMatcher: TWebMockJSONPatternMatcher;
begin
  LJSON := TJSONObject.ParseJSONValue('{ "object": { "key": "value" } }');

  LMatcher := TWebMockJSONPatternMatcher.Create(
    'object.key',
    TRegEx.Create('other value')
  );
  Assert.IsFalse(LMatcher.IsMatch(LJSON));

  LMatcher.Free;
  LJSON.Free;
end;

procedure TWebMockJSONPatternMatcherTests.IsMatch_NotMatchingString_ReturnsFalse;
var
  LJSON: TJSONValue;
  LMatcher: TWebMockJSONPatternMatcher;
begin
  LJSON := TJSONObject.ParseJSONValue('{ "key": "value" }');

  LMatcher := TWebMockJSONPatternMatcher.Create('key', TRegEx.Create('other value'));
  Assert.IsFalse(LMatcher.IsMatch(LJSON));

  LMatcher.Free;
  LJSON.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockJSONPatternMatcherTests);
end.
