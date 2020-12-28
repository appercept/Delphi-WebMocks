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

unit WebMock.ResponseContentString.Tests;

interface

uses
  DUnitX.TestFramework,
  WebMock.ResponseContentString;

type

  [TestFixture]
  TWebMockResponseContentStringTests = class(TObject)
  private
    WebMockResponseContentString: TWebMockResponseContentString;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Create_WithoutArguments_SetsAnEmptyString;
    [Test]
    procedure Create_WithString_SetsString;
    [Test]
    procedure ContentString_Always_ReturnsValueInitializedOnCreate;
    [Test]
    procedure ContentStream_Always_ReturnsAStringStreamContainingString;
    [Test]
    procedure ContentType_WhenNotSpecified_DefaultsToPlainTextWithUTF8CharSet;
    [Test]
    procedure ContentType_WhenSpecified_ReturnsContentType;
  end;

implementation

uses
  System.Classes;

{ TWebMockResponseContentStringTests }

procedure TWebMockResponseContentStringTests.Setup;
begin

end;

procedure TWebMockResponseContentStringTests.TearDown;
begin
  WebMockResponseContentString.Free;
end;

procedure TWebMockResponseContentStringTests.ContentStream_Always_ReturnsAStringStreamContainingString;
var
  LExpected: string;
  LActual: TStringStream;
begin
  LExpected := 'A String Value';
  WebMockResponseContentString := TWebMockResponseContentString.Create(LExpected);

  LActual := WebMockResponseContentString.ContentStream as TStringStream;
  Assert.AreEqual(
    LExpected,
    LActual.DataString
  );

  LActual.Free;
end;

procedure TWebMockResponseContentStringTests.ContentString_Always_ReturnsValueInitializedOnCreate;
var
  LExpected, LActual: string;
begin
  LExpected := 'A String Value';

  WebMockResponseContentString := TWebMockResponseContentString.Create(LExpected);
  LActual := WebMockResponseContentString.ContentString;

  Assert.AreEqual(LExpected, LActual);
end;

procedure TWebMockResponseContentStringTests.ContentType_WhenNotSpecified_DefaultsToPlainTextWithUTF8CharSet;
begin
  WebMockResponseContentString := TWebMockResponseContentString.Create;

  Assert.AreEqual('text/plain; charset=utf-8', WebMockResponseContentString.ContentType);
end;

procedure TWebMockResponseContentStringTests.ContentType_WhenSpecified_ReturnsContentType;
var
  LExpectedContentType: string;
begin
  LExpectedContentType := 'application/json';

  WebMockResponseContentString := TWebMockResponseContentString.Create('{}', LExpectedContentType);

  Assert.AreEqual(LExpectedContentType, WebMockResponseContentString.ContentType);
end;

procedure TWebMockResponseContentStringTests.Create_WithoutArguments_SetsAnEmptyString;
begin
  WebMockResponseContentString := TWebMockResponseContentString.Create;

  Assert.IsEmpty(WebMockResponseContentString.GetContentString);
end;

procedure TWebMockResponseContentStringTests.Create_WithString_SetsString;
var
  LExpected: string;
begin
  LExpected := 'Test';

  WebMockResponseContentString := TWebMockResponseContentString.Create(LExpected);

  Assert.AreEqual(LExpected, WebMockResponseContentString.GetContentString);
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockResponseContentStringTests);
end.
