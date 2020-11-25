{******************************************************************************}
{                                                                              }
{           Delphi-WebMocks                                                    }
{                                                                              }
{           Copyright (c) 2019 Richard Hatherall                               }
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

unit WebMock.StringWildcardMatcher.Tests;

interface

uses
  DUnitX.TestFramework,
  IdCustomHTTPServer,
  WebMock.StringWildcardMatcher;

type

  [TestFixture]
  TWebMockStringWildcardMatcherTests = class(TObject)
  private
    StringWildcardMatcher: TWebMockStringWildcardMatcher;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Class_Always_ImplementsStringMatcher;
    [Test]
    procedure Value_WithoutIntializedValue_IsWildcard;
    [Test]
    procedure Value_WithInitializedValue_IsGivenValue;
    [Test]
    procedure IsMatch_WhenGivenValueMatchesValue_ReturnsTrue;
    [Test]
    procedure IsMatch_WhenGivenValueDoesNotMatchValue_ReturnsFalse;
    [Test]
    procedure IsMatch_WhenInitializedValueIsWildcard_ReturnsTrue;
    [Test]
    procedure ToString_Always_ReturnsInitializedValue;
  end;

implementation

{ TWebMockStringWildcardMatcherTests }

uses WebMock.StringMatcher;

procedure TWebMockStringWildcardMatcherTests.Class_Always_ImplementsStringMatcher;
var
  Subject: IInterface;
begin
  Subject := TWebMockStringWildcardMatcher.Create;

  Assert.Implements<IStringMatcher>(Subject);
end;

procedure TWebMockStringWildcardMatcherTests.IsMatch_WhenGivenValueDoesNotMatchValue_ReturnsFalse;
var
  LExpected: string;
begin
  LExpected := 'A Value';
  StringWildcardMatcher := TWebMockStringWildcardMatcher.Create(LExpected);

  Assert.IsFalse(StringWildcardMatcher.IsMatch('Other Value'));
end;

procedure TWebMockStringWildcardMatcherTests.IsMatch_WhenGivenValueMatchesValue_ReturnsTrue;
var
  LExpected: string;
begin
  LExpected := 'A Value';
  StringWildcardMatcher := TWebMockStringWildcardMatcher.Create(LExpected);

  Assert.IsTrue(StringWildcardMatcher.IsMatch(LExpected));
end;

procedure TWebMockStringWildcardMatcherTests.IsMatch_WhenInitializedValueIsWildcard_ReturnsTrue;
begin
  StringWildcardMatcher := TWebMockStringWildcardMatcher.Create('*');

  Assert.IsTrue(StringWildcardMatcher.IsMatch('Any Value'));
end;

procedure TWebMockStringWildcardMatcherTests.Setup;
begin

end;

procedure TWebMockStringWildcardMatcherTests.TearDown;
begin
  StringWildcardMatcher.Free;
end;

procedure TWebMockStringWildcardMatcherTests.ToString_Always_ReturnsInitializedValue;
var
  LExpected: string;
begin
  LExpected := 'A Value';
  StringWildcardMatcher := TWebMockStringWildcardMatcher.Create(LExpected);

  Assert.AreEqual(LExpected, StringWildcardMatcher.ToString);
end;

procedure TWebMockStringWildcardMatcherTests.Value_WithoutIntializedValue_IsWildcard;
begin
  StringWildcardMatcher := TWebMockStringWildcardMatcher.Create;

  Assert.AreEqual('*', StringWildcardMatcher.Value);
end;

procedure TWebMockStringWildcardMatcherTests.Value_WithInitializedValue_IsGivenValue;
var
  LExpected: string;
begin
  LExpected := 'A Value';

  StringWildcardMatcher := TWebMockStringWildcardMatcher.Create(LExpected);

  Assert.AreEqual(LExpected, StringWildcardMatcher.Value);
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockStringWildcardMatcherTests);
end.
