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

unit WebMock.ResponseContentFile.Tests;

interface

uses
  DUnitX.TestFramework,
  WebMock.ResponseContentFile;

type

  [TestFixture]
  TWebMockResponseContentFileTests = class(TObject)
  private
    WebMockResponseContentFile: TWebMockResponseContentFile;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Create_WithValidFileName_LoadsContentStreamFromFile;
    [Test]
    procedure ContentType_WhenNotSpecifiedWithKnownFileType_SetsContentType;
    [Test]
    procedure ContentType_WhenNotSpecifiedWithUnknownFileType_SetsContentTypeToBinary;
    [Test]
    procedure ContentType_WhenSpecified_ReturnsContentType;
  end;

implementation

uses
  System.Classes,
  TestHelpers;

{ TWebMockResponseContentFileTests }

procedure TWebMockResponseContentFileTests.Setup;
begin

end;

procedure TWebMockResponseContentFileTests.TearDown;
begin
  WebMockResponseContentFile.Free;
end;

procedure TWebMockResponseContentFileTests.ContentType_WhenNotSpecifiedWithKnownFileType_SetsContentType;
begin
  WebMockResponseContentFile := TWebMockResponseContentFile.Create(FixturePath('Sample.txt'));

  Assert.AreEqual('text/plain', WebMockResponseContentFile.ContentType);
end;

procedure TWebMockResponseContentFileTests.ContentType_WhenNotSpecifiedWithUnknownFileType_SetsContentTypeToBinary;
begin
  WebMockResponseContentFile := TWebMockResponseContentFile.Create(FixturePath('Sample.unknown'));

  Assert.AreEqual('application/octet-stream', WebMockResponseContentFile.ContentType);
end;

procedure TWebMockResponseContentFileTests.ContentType_WhenSpecified_ReturnsContentType;
var
  LExpected: string;
begin
  LExpected := 'text/rtf';

  WebMockResponseContentFile := TWebMockResponseContentFile.Create(FixturePath('Sample.txt'), LExpected);

  Assert.AreEqual(LExpected, WebMockResponseContentFile.ContentType);
end;

procedure TWebMockResponseContentFileTests.Create_WithValidFileName_LoadsContentStreamFromFile;
var
  LActualContent: TStream;
  LActualStringContent: TStringStream;
begin
  WebMockResponseContentFile := TWebMockResponseContentFile.Create(FixturePath('Sample.txt'));

  LActualContent := WebMockResponseContentFile.ContentStream;
  LActualStringContent := TStringStream.Create('');
  LActualStringContent.CopyFrom(LActualContent, 0);
  Assert.AreEqual('Sample Text', LActualStringContent.DataString);

  LActualStringContent.Free;
  LActualContent.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockResponseContentFileTests);
end.
