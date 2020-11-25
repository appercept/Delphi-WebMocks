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

unit WebMock.StringAnyMatcher.Tests;

interface

uses
  DUnitX.TestFramework,
  IdCustomHTTPServer,
  WebMock.StringAnyMatcher;

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
