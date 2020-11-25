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

unit WebMock.ResponseBuilder.Tests;

interface

uses
  DUnitX.TestFramework,
  WebMock.Response;

type
  [TestFixture]
  TWebMockResponseBuilderTests = class(TObject)
  private
    Response: TWebMockResponse;
    Builder: IWebMockResponseBuilder;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure WithBody_Always_ReturnsBuilder;
    [Test]
    procedure WithBody_WithString_SetsResponseContent;
    [Test]
    procedure WithBodyFile_Always_ReturnsBuilder;
    [Test]
    procedure WithBodyFile_WithValidFile_SetsResponseContent;
    [Test]
    procedure WithHeader_Always_ReturnsBuilder;
    [Test]
    procedure WithHeader_Always_SetsValueForHeader;
    [Test]
    procedure WithHeader_Always_OverwritesExistingValues;
    [Test]
    procedure WithHeaders_Always_ReturnsBuilder;
    [Test]
    procedure WithHeaders_Always_SetsAllValues;
    [Test]
    procedure WithStatus_GivenStatus_ReturnsBuilder;
    [Test]
    procedure WithStatus_GivenStatus_SetsStatus;
    [Test]
    procedure WithStatus_GivenRawValues_ReturnsBuilder;
    [Test]
    procedure WithStatus_GivenRawValues_SetsStatusCode;
    [Test]
    procedure WithStatus_GivenRawValues_SetsStatusText;
  end;

implementation

uses
  System.Classes,
  TestHelpers,
  WebMock.ResponseStatus;

{ TWebMockResponseBuilderTests }

procedure TWebMockResponseBuilderTests.Setup;
begin
  Response := TWebMockResponse.Create;
  Builder := Response.Builder;
end;

procedure TWebMockResponseBuilderTests.TearDown;
begin
  Builder := nil;
  Response.Free;
end;

procedure TWebMockResponseBuilderTests.WithBodyFile_Always_ReturnsBuilder;
begin
  Assert.AreSame(Builder, Builder.WithBodyFile(FixturePath('Sample.txt')));
end;

procedure TWebMockResponseBuilderTests.WithBodyFile_WithValidFile_SetsResponseContent;
var
  LExpectedContent: string;
  LActualStream: TStringStream;
begin
  LExpectedContent := 'Sample Text';

  Builder.WithBodyFile(FixturePath('Sample.txt'));

  LActualStream := TStringStream.Create;
  LActualStream.CopyFrom(Response.BodySource.ContentStream, 0);
  Assert.AreEqual(
    LExpectedContent,
    LActualStream.DataString
  );
end;

procedure TWebMockResponseBuilderTests.WithBody_Always_ReturnsBuilder;
begin
  Assert.AreSame(Builder, Builder.WithBody(''));
end;

procedure TWebMockResponseBuilderTests.WithBody_WithString_SetsResponseContent;
var
  LExpectedContent: string;
begin
  LExpectedContent := 'Text Body.';

  Builder.WithBody(LExpectedContent);

  Assert.AreEqual(
    LExpectedContent,
    (Response.BodySource.ContentStream as TStringStream).DataString
  );
end;

procedure TWebMockResponseBuilderTests.WithHeaders_Always_ReturnsBuilder;
var
  LHeaders: TStringList;
begin
  LHeaders := TStringList.Create;

  Assert.AreSame(Builder, Builder.WithHeaders(LHeaders));

  LHeaders.Free;
end;

procedure TWebMockResponseBuilderTests.WithHeaders_Always_SetsAllValues;
var
  LHeaders: TStringList;
  LHeaderName, LHeaderValue: string;
  I: Integer;
begin
  LHeaders := TStringList.Create;
  LHeaders.Values['Header1'] := 'Value1';
  LHeaders.Values['Header2'] := 'Value2';

  Builder.WithHeaders(LHeaders);

  for I := 0 to LHeaders.Count - 1 do
  begin
    LHeaderName := LHeaders.Names[I];
    LHeaderValue := LHeaders.ValueFromIndex[I];
    Assert.AreEqual(LHeaderValue, Response.Headers.Values[LHeaderName]);
  end;

  LHeaders.Free;
end;

procedure TWebMockResponseBuilderTests.WithHeader_Always_OverwritesExistingValues;
var
  LHeaderName, LHeaderValue1, LHeaderValue2: string;
begin
  LHeaderName := 'Header1';
  LHeaderValue1 := 'Value1';
  LHeaderValue2 := 'Value2';

  Builder.WithHeader(LHeaderName, LHeaderValue1);
  Builder.WithHeader(LHeaderName, LHeaderValue2);

  Assert.AreEqual(LHeaderValue2, Response.Headers.Values[LHeaderName]);
end;

procedure TWebMockResponseBuilderTests.WithHeader_Always_ReturnsBuilder;
begin
  Assert.AreSame(Builder, Builder.WithHeader('Header1', 'Value1'));
end;

procedure TWebMockResponseBuilderTests.WithHeader_Always_SetsValueForHeader;
var
  LHeaderName, LHeaderValue: string;
begin
  LHeaderName := 'Header1';
  LHeaderValue := 'Value1';

  Builder.WithHeader(LHeaderName, LHeaderValue);

  Assert.AreEqual(LHeaderValue, Response.Headers.Values[LHeaderName]);
end;

procedure TWebMockResponseBuilderTests.WithStatus_GivenRawValues_ReturnsBuilder;
begin
  Assert.AreSame(Builder, Builder.WithStatus(555, 'Custom Status'));
end;

procedure TWebMockResponseBuilderTests.WithStatus_GivenRawValues_SetsStatusCode;
begin
  Builder.WithStatus(401);

  Assert.AreEqual(401, Response.Status.Code);
end;

procedure TWebMockResponseBuilderTests.WithStatus_GivenRawValues_SetsStatusText;
begin
  Builder.WithStatus(555, 'Custom Status');

  Assert.AreEqual('Custom Status', Response.Status.Text);
end;

procedure TWebMockResponseBuilderTests.WithStatus_GivenStatus_ReturnsBuilder;
begin
  Assert.AreSame(Builder, Builder.WithStatus(TWebMockResponseStatus.InternalServerError));
end;

procedure TWebMockResponseBuilderTests.WithStatus_GivenStatus_SetsStatus;
begin
  Builder.WithStatus(TWebMockResponseStatus.InternalServerError);

  Assert.AreEqual(500, Response.Status.Code);
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockResponseBuilderTests);
end.
