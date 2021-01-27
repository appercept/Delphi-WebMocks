{******************************************************************************}
{                                                                              }
{           Delphi-WebMocks                                                    }
{                                                                              }
{           Copyright (c) 2020 Richard Hatherall                               }
{                                                                              }
{           richard@appercept.com                                              }
{           https://appercept.com                                              }
{                                                                              }
{******************************************************************************}
{                                                                              }
{   Licensed under the Apache License, Version 2.0 (the "License");            }
{   you may not use this file except in compliance with the License.           }
{   You may obtain a copy of the License at                                    }
{                                                                              }
{       http://www.apache.org/licenses/LICENSE-2.0                             }
{                                                                              }
{   Unless required by applicable law or agreed to in writing, software        }
{   distributed under the License is distributed on an "AS IS" BASIS,          }
{   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   }
{   See the License for the specific language governing permissions and        }
{   limitations under the License.                                             }
{                                                                              }
{******************************************************************************}

unit WebMock.FormDataMatcher.Tests;

interface

uses
  DUnitX.TestFramework,
  IdCustomHTTPServer,
  WebMock.FormDataMatcher;

type

  [TestFixture]
  TWebMockFormDataMatcherTests = class(TObject)
  private
    Matcher: TWebMockFormDataMatcher;
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
    procedure Add_Always_AddsFieldMatcher;
    [Test]
    procedure Add_CalledMultipleTimes_AddsMultipleFieldMatchers;
    [Test]
    procedure Add_GivenNameOnly_AddsWildcardFieldMatcher;
    [Test]
    procedure Add_GivenNameAndValue_AddsFieldMatcherWithValue;
    [Test]
    procedure Add_GivenNameAndRegEx_AddsFieldMatcherWithPattern;
    [Test]
    procedure IsMatch_WithNoFieldMatchers_ReturnsTrue;
    [Test]
    procedure IsMatch_WhenGivenNameAndValueMatchesValue_ReturnsTrue;
    [Test]
    procedure IsMatch_WhenGivenNameDoesNotMatchValue_ReturnsFalse;
    [Test]
    procedure IsMatch_WhenGivenValueDoesNotMatchValue_ReturnsFalse;
    [Test]
    procedure IsMatch_WhenInitializedValueIsWildcard_ReturnsTrue;
    [Test]
    procedure IsMatch_WithMultipleFieldsMatch_ReturnsTrue;
    [Test]
    procedure IsMatch_WithASingledMatcherOfMultipleDoesNotMatch_ReturnsFalse;
    [Test]
    procedure ToString_Always_ReturnsInitializedValue;
  end;

implementation

uses
  System.RegularExpressions,
  WebMock.FormFieldMatcher,
  WebMock.StringRegExMatcher,
  WebMock.StringMatcher,
  WebMock.StringWildcardMatcher;

{ TWebMockFormDataMatcherTests }

procedure TWebMockFormDataMatcherTests.Class_Always_ImplementsStringMatcher;
var
  Subject: IInterface;
begin
  Subject := TWebMockFormDataMatcher.Create;

  Assert.Implements<IStringMatcher>(Subject);
end;

procedure TWebMockFormDataMatcherTests.IsMatch_WhenGivenValueDoesNotMatchValue_ReturnsFalse;
var
  LExpectedName, LExpectedValue: string;
  LFormData: string;
begin
  LExpectedName := 'AName';
  LExpectedValue := 'AValue';
  LFormData := 'AName=OtherValue';
  Matcher.Add(LExpectedName, LExpectedValue);

  Assert.IsFalse(Matcher.IsMatch(LFormData));
end;

procedure TWebMockFormDataMatcherTests.IsMatch_WhenGivenNameAndValueMatchesValue_ReturnsTrue;
var
  LExpectedName, LExpectedValue: string;
  LFormData: string;
begin
  LExpectedName := 'AName';
  LExpectedValue := 'AValue';
  LFormData := 'AName=AValue';
  Matcher.Add(LExpectedName, LExpectedValue);

  Assert.IsTrue(Matcher.IsMatch(LFormData));
end;

procedure TWebMockFormDataMatcherTests.IsMatch_WhenGivenNameDoesNotMatchValue_ReturnsFalse;
var
  LExpectedName, LExpectedValue: string;
  LFormData: string;
begin
  LExpectedName := 'AName';
  LExpectedValue := 'AValue';
  LFormData := 'OtherName=AValue';
  Matcher.Add(LExpectedName, LExpectedValue);

  Assert.IsFalse(Matcher.IsMatch(LFormData));
end;

procedure TWebMockFormDataMatcherTests.IsMatch_WhenInitializedValueIsWildcard_ReturnsTrue;
var
  LExpectedName, LExpectedValue: string;
  LFormData: string;
begin
  LExpectedName := 'AName';
  LExpectedValue := '*';
  LFormData := 'AName=OtherValue';
  Matcher.Add(LExpectedName, LExpectedValue);

  Assert.IsTrue(Matcher.IsMatch(LFormData));
end;

procedure TWebMockFormDataMatcherTests.IsMatch_WithASingledMatcherOfMultipleDoesNotMatch_ReturnsFalse;
var
  LFormData: string;
begin
  LFormData := 'Field1=Value1&Field2=WrongValue';
  Matcher.Add('Field1', 'Value1');
  Matcher.Add('Field2', 'Value2');

  Assert.IsFalse(Matcher.IsMatch(LFormData));
end;

procedure TWebMockFormDataMatcherTests.IsMatch_WithMultipleFieldsMatch_ReturnsTrue;
var
  LFormData: string;
begin
  LFormData := 'Field1=Value1&Field2=Value2';
  Matcher.Add('Field1', 'Value1');
  Matcher.Add('Field2', 'Value2');

  Assert.IsTrue(Matcher.IsMatch(LFormData));
end;

procedure TWebMockFormDataMatcherTests.IsMatch_WithNoFieldMatchers_ReturnsTrue;
begin
  Assert.IsTrue(Matcher.IsMatch('AnyValue'));
end;

procedure TWebMockFormDataMatcherTests.Create_Always_InitializesEmpty;
begin
  Assert.AreEqual(0, Matcher.FieldMatchers.Count);
end;

procedure TWebMockFormDataMatcherTests.Setup;
begin
  Matcher := TWebMockFormDataMatcher.Create;
end;

procedure TWebMockFormDataMatcherTests.TearDown;
begin
  Matcher.Free;
end;

procedure TWebMockFormDataMatcherTests.ToString_Always_ReturnsInitializedValue;
begin
  Matcher.Add('Field1');
  Matcher.Add('Field2');

  Assert.AreEqual('Field1=* AND Field2=*', Matcher.ToString);
end;

procedure TWebMockFormDataMatcherTests.Add_Always_AddsFieldMatcher;
begin
  Matcher.Add('AName');

  Assert.AreEqual(1, Matcher.FieldMatchers.Count);
end;

procedure TWebMockFormDataMatcherTests.Add_CalledMultipleTimes_AddsMultipleFieldMatchers;
begin
  Matcher.Add('Field1');
  Matcher.Add('Field2');
  Matcher.Add('Field3');

  Assert.AreEqual(3, Matcher.FieldMatchers.Count);
end;

procedure TWebMockFormDataMatcherTests.Add_GivenNameAndRegEx_AddsFieldMatcherWithPattern;
var
  LExpected: TRegEx;
  LFieldMatcher: TWebMockFormFieldMatcher;
begin
  LExpected := TRegEx.Create('');
  Matcher.Add('AName', LExpected);

  LFieldMatcher := Matcher.FieldMatchers[0] as TWebMockFormFieldMatcher;
  Assert.AreEqual(
    LExpected,
    (LFieldMatcher.ValueMatcher as TWebMockStringRegExMatcher).RegEx
  );
end;

procedure TWebMockFormDataMatcherTests.Add_GivenNameAndValue_AddsFieldMatcherWithValue;
var
  LExpected: string;
  LFieldMatcher: TWebMockFormFieldMatcher;
begin
  LExpected := 'A Value';
  Matcher.Add('AName', LExpected);

  LFieldMatcher := Matcher.FieldMatchers[0] as TWebMockFormFieldMatcher;
  Assert.AreEqual(
    LExpected,
    (LFieldMatcher.ValueMatcher as TWebMockStringWildcardMatcher).Value
  );
end;

procedure TWebMockFormDataMatcherTests.Add_GivenNameOnly_AddsWildcardFieldMatcher;
var
  LFieldMatcher: TWebMockFormFieldMatcher;
begin
  Matcher.Add('AName');

  LFieldMatcher := Matcher.FieldMatchers[0] as TWebMockFormFieldMatcher;
  Assert.AreEqual(
    '*',
    (LFieldMatcher.ValueMatcher as TWebMockStringWildcardMatcher).Value
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockFormDataMatcherTests);
end.
