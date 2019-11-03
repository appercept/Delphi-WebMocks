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

unit Delphi.WebMock.Response.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock.Response;

type

  [TestFixture]
  TWebMockResponseTests = class(TObject)
  private
    WebMockResponse: TWebMockResponse;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Create_WithoutArguments_SetsStatusToOK;
    [Test]
    procedure Create_WithStatus_SetsStatus;
    [Test]
    procedure BodySource_WhenNotSet_ReturnsEmptyContentSource;
    [Test]
    procedure WithBody_Always_ReturnsSelf;
    [Test]
    procedure WithBody_WithString_SetsResponseContent;
    [Test]
    procedure WithBodyFile_Always_ReturnsSelf;
    [Test]
    procedure WithBodyFile_WithValidFile_SetsResponseContent;
    [Test]
    procedure WithHeader_Always_ReturnsSelf;
    [Test]
    procedure WithHeader_Always_SetsValueForHeader;
    [Test]
    procedure WithHeader_Always_OverwritesExistingValues;
    [Test]
    procedure WithHeaders_Always_ReturnsSelf;
    [Test]
    procedure WithHeaders_Always_SetsAllValues;
  end;

implementation

{ TWebMockResponseTests }

uses
  Delphi.WebMock.ResponseStatus,
  System.Classes,
  TestHelpers;

procedure TWebMockResponseTests.Setup;
begin
  WebMockResponse := TWebMockResponse.Create;
end;

procedure TWebMockResponseTests.TearDown;
begin
  WebMockResponse.Free;
end;

procedure TWebMockResponseTests.WithBodyFile_Always_ReturnsSelf;
begin
  Assert.AreSame(WebMockResponse, WebMockResponse.WithBodyFile(FixturePath('Sample.txt')));
end;

procedure TWebMockResponseTests.WithBodyFile_WithValidFile_SetsResponseContent;
var
  LExpectedContent: string;
  LActualStream: TStringStream;
begin
  LExpectedContent := 'Sample Text';

  WebMockResponse.WithBodyFile(FixturePath('Sample.txt'));

  LActualStream := TStringStream.Create;
  LActualStream.CopyFrom(WebMockResponse.BodySource.ContentStream, 0);
  Assert.AreEqual(
    LExpectedContent,
    LActualStream.DataString
  );
end;

procedure TWebMockResponseTests.WithBody_Always_ReturnsSelf;
begin
  Assert.AreSame(WebMockResponse, WebMockResponse.WithBody(''));
end;

procedure TWebMockResponseTests.WithBody_WithString_SetsResponseContent;
var
  LExpectedContent: string;
begin
  LExpectedContent := 'Text Body.';

  WebMockResponse.WithBody(LExpectedContent);

  Assert.AreEqual(
    LExpectedContent,
    (WebMockResponse.BodySource.ContentStream as TStringStream).DataString
  );
end;

procedure TWebMockResponseTests.WithHeaders_Always_ReturnsSelf;
var
  LHeaders: TStringList;
begin
  LHeaders := TStringList.Create;

  Assert.AreSame(WebMockResponse, WebMockResponse.WithHeaders(LHeaders));

  LHeaders.Free;
end;

procedure TWebMockResponseTests.WithHeaders_Always_SetsAllValues;
var
  LHeaders: TStringList;
  LHeaderName, LHeaderValue: string;
  I: Integer;
begin
  LHeaders := TStringList.Create;
  LHeaders.Values['Header1'] := 'Value1';
  LHeaders.Values['Header2'] := 'Value2';

  WebMockResponse.WithHeaders(LHeaders);

  for I := 0 to LHeaders.Count - 1 do
  begin
    LHeaderName := LHeaders.Names[I];
    LHeaderValue := LHeaders.ValueFromIndex[I];
    Assert.AreEqual(LHeaderValue, WebMockResponse.Headers.Values[LHeaderName]);
  end;

  LHeaders.Free;
end;

procedure TWebMockResponseTests.WithHeader_Always_OverwritesExistingValues;
var
  LHeaderName, LHeaderValue1, LHeaderValue2: string;
begin
  LHeaderName := 'Header1';
  LHeaderValue1 := 'Value1';
  LHeaderValue2 := 'Value2';

  WebMockResponse.WithHeader(LHeaderName, LHeaderValue1);
  WebMockResponse.WithHeader(LHeaderName, LHeaderValue2);

  Assert.AreEqual(LHeaderValue2, WebMockResponse.Headers.Values[LHeaderName]);
end;

procedure TWebMockResponseTests.WithHeader_Always_ReturnsSelf;
begin
  Assert.AreSame(
    WebMockResponse,
    WebMockResponse.WithHeader('Header1', 'Value1')
  );
end;

procedure TWebMockResponseTests.WithHeader_Always_SetsValueForHeader;
var
  LHeaderName, LHeaderValue: string;
begin
  LHeaderName := 'Header1';
  LHeaderValue := 'Value1';

  WebMockResponse.WithHeader(LHeaderName, LHeaderValue);

  Assert.AreEqual(LHeaderValue, WebMockResponse.Headers.Values[LHeaderName]);
end;

procedure TWebMockResponseTests.BodySource_WhenNotSet_ReturnsEmptyContentSource;
begin
  Assert.AreEqual(Int64(0), WebMockResponse.BodySource.ContentStream.Size);
end;

procedure TWebMockResponseTests.Create_WithoutArguments_SetsStatusToOK;
begin
  Assert.AreEqual(200, WebMockResponse.Status.Code);
end;

procedure TWebMockResponseTests.Create_WithStatus_SetsStatus;
var
  LExpectedStatus: TWebMockResponseStatus;
begin
  LExpectedStatus := TWebMockResponseStatus.Accepted;

  WebMockResponse := TWebMockResponse.Create(LExpectedStatus);

  Assert.AreSame(LExpectedStatus, WebMockResponse.Status);
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockResponseTests);
end.
