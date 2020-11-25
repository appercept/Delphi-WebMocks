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

unit WebMock.StringRegExMatcher.Tests;

interface

uses
  DUnitX.TestFramework,
  IdCustomHTTPServer,
  WebMock.StringRegExMatcher;

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
  System.RegularExpressions,
  WebMock.StringMatcher;

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
