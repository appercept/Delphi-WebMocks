unit WebMock.JSONValueMatcher.Tests;

interface

uses
  DUnitX.TestFramework,
  WebMock.JSONMatcher;

type
  [TestFixture]
  TWebMockJSONValueMatcherTests = class(TObject)
  public
    [Test]
    procedure Create_Always_RequiresPathAndValue;
    [Test]
    procedure IsMatch_MatchingBoolean_ReturnsTrue;
    [Test]
    procedure IsMatch_NotMatchingBoolean_ReturnsFalse;
    [Test]
    procedure IsMatch_MatchingFloat_ReturnsTrue;
    [Test]
    procedure IsMatch_NotMatchingFloat_ReturnsFalse;
    [Test]
    procedure IsMatch_MatchingInteger_ReturnsTrue;
    [Test]
    procedure IsMatch_NotMatchingInteger_ReturnsFalse;
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
  System.JSON;

{ TWebMockJSONValueMatcherTests }

procedure TWebMockJSONValueMatcherTests.Create_Always_RequiresPathAndValue;
var
  LMatcher: TWebMockJSONValueMatcher<Integer>;
begin
  LMatcher := TWebMockJSONValueMatcher<Integer>.Create('APath', 1);

  LMatcher.Free;

  Assert.Pass('Create takes path and value');
end;

procedure TWebMockJSONValueMatcherTests.IsMatch_MatchingArrayPath_ReturnsTrue;
var
  LJSON: TJSONValue;
  LMatcher: TWebMockJSONValueMatcher<Boolean>;
begin
  LJSON := TJSONObject.ParseJSONValue(
    '{ "objects": [{ "key": true }, { "key": false }] }'
  );

  LMatcher := TWebMockJSONValueMatcher<Boolean>.Create('objects[0].key', True);
  Assert.IsTrue(LMatcher.IsMatch(LJSON));

  LMatcher.Free;
  LJSON.Free;
end;

procedure TWebMockJSONValueMatcherTests.IsMatch_MatchingBoolean_ReturnsTrue;
var
  LJSON: TJSONValue;
  LMatcher: TWebMockJSONValueMatcher<Boolean>;
begin
  LJSON := TJSONObject.ParseJSONValue('{ "key": true }');

  LMatcher := TWebMockJSONValueMatcher<Boolean>.Create('key', True);
  Assert.IsTrue(LMatcher.IsMatch(LJSON));

  LMatcher.Free;
  LJSON.Free;
end;

procedure TWebMockJSONValueMatcherTests.IsMatch_MatchingFloat_ReturnsTrue;
var
  LJSON: TJSONValue;
  LMatcher: TWebMockJSONValueMatcher<Float64>;
begin
  LJSON := TJSONObject.ParseJSONValue('{ "key": 0.12345 }');

  LMatcher := TWebMockJSONValueMatcher<Float64>.Create('key', 0.12345);
  Assert.IsTrue(LMatcher.IsMatch(LJSON));

  LMatcher.Free;
  LJSON.Free;
end;

procedure TWebMockJSONValueMatcherTests.IsMatch_MatchingInteger_ReturnsTrue;
var
  LJSON: TJSONValue;
  LMatcher: TWebMockJSONValueMatcher<Integer>;
begin
  LJSON := TJSONObject.ParseJSONValue('{ "key": 1 }');

  LMatcher := TWebMockJSONValueMatcher<Integer>.Create('key', 1);
  Assert.IsTrue(LMatcher.IsMatch(LJSON));

  LMatcher.Free;
  LJSON.Free;
end;

procedure TWebMockJSONValueMatcherTests.IsMatch_MatchingObjectPath_ReturnsTrue;
var
  LJSON: TJSONValue;
  LMatcher: TWebMockJSONValueMatcher<Boolean>;
begin
  LJSON := TJSONObject.ParseJSONValue('{ "object": { "key": true } }');

  LMatcher := TWebMockJSONValueMatcher<Boolean>.Create('object.key', True);
  Assert.IsTrue(LMatcher.IsMatch(LJSON));

  LMatcher.Free;
  LJSON.Free;
end;

procedure TWebMockJSONValueMatcherTests.IsMatch_MatchingString_ReturnsTrue;
var
  LJSON: TJSONValue;
  LMatcher: TWebMockJSONValueMatcher<string>;
begin
  LJSON := TJSONObject.ParseJSONValue('{ "key": "value" }');

  LMatcher := TWebMockJSONValueMatcher<string>.Create('key', 'value');
  Assert.IsTrue(LMatcher.IsMatch(LJSON));

  LMatcher.Free;
  LJSON.Free;
end;

procedure TWebMockJSONValueMatcherTests.IsMatch_NotMatchingArrayPath_ReturnsFalse;
var
  LJSON: TJSONValue;
  LMatcher: TWebMockJSONValueMatcher<Boolean>;
begin
  LJSON := TJSONObject.ParseJSONValue(
    '{ "objects": [{ "key": true }, { "key": false }] }'
  );

  LMatcher := TWebMockJSONValueMatcher<Boolean>.Create('objects[1].key', True);
  Assert.IsFalse(LMatcher.IsMatch(LJSON));

  LMatcher.Free;
  LJSON.Free;
end;

procedure TWebMockJSONValueMatcherTests.IsMatch_NotMatchingBoolean_ReturnsFalse;
var
  LJSON: TJSONValue;
  LMatcher: TWebMockJSONValueMatcher<Boolean>;
begin
  LJSON := TJSONObject.ParseJSONValue('{ "key": true }');

  LMatcher := TWebMockJSONValueMatcher<Boolean>.Create('key', False);
  Assert.IsFalse(LMatcher.IsMatch(LJSON));

  LMatcher.Free;
  LJSON.Free;
end;

procedure TWebMockJSONValueMatcherTests.IsMatch_NotMatchingFloat_ReturnsFalse;
var
  LJSON: TJSONValue;
  LMatcher: TWebMockJSONValueMatcher<Float64>;
begin
  LJSON := TJSONObject.ParseJSONValue('{ "key": 0.12345 }');

  LMatcher := TWebMockJSONValueMatcher<Float64>.Create('key', 0.12346);
  Assert.IsFalse(LMatcher.IsMatch(LJSON));

  LMatcher.Free;
  LJSON.Free;
end;

procedure TWebMockJSONValueMatcherTests.IsMatch_NotMatchingInteger_ReturnsFalse;
var
  LJSON: TJSONValue;
  LMatcher: TWebMockJSONValueMatcher<Integer>;
begin
  LJSON := TJSONObject.ParseJSONValue('{ "key": 1 }');

  LMatcher := TWebMockJSONValueMatcher<Integer>.Create('key', 2);
  Assert.IsFalse(LMatcher.IsMatch(LJSON));

  LMatcher.Free;
  LJSON.Free;
end;

procedure TWebMockJSONValueMatcherTests.IsMatch_NotMatchingObjectPath_ReturnsFalse;
var
  LJSON: TJSONValue;
  LMatcher: TWebMockJSONValueMatcher<Boolean>;
begin
  LJSON := TJSONObject.ParseJSONValue('{ "object": { "key": true } }');

  LMatcher := TWebMockJSONValueMatcher<Boolean>.Create('object.key', False);
  Assert.IsFalse(LMatcher.IsMatch(LJSON));

  LMatcher.Free;
  LJSON.Free;
end;

procedure TWebMockJSONValueMatcherTests.IsMatch_NotMatchingString_ReturnsFalse;
var
  LJSON: TJSONValue;
  LMatcher: TWebMockJSONValueMatcher<string>;
begin
  LJSON := TJSONObject.ParseJSONValue('{ "key": "value" }');

  LMatcher := TWebMockJSONValueMatcher<string>.Create('key', 'other value');
  Assert.IsFalse(LMatcher.IsMatch(LJSON));

  LMatcher.Free;
  LJSON.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockJSONValueMatcherTests);
end.
