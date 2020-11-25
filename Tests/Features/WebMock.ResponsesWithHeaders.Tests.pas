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

unit WebMock.ResponsesWithHeaders.Tests;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  WebMock;

type

  [TestFixture]
  TWebMockResponsesWithHeadersTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Response_WithHeader_HasValueForHeader;
    [Test]
    procedure Response_WithHeaderChained_HasValueForEachHeader;
    [Test]
    procedure Response_WithHeaders_HasValueForAllHeaders;
  end;

implementation

{ TWebMockResponsesWithHeadersTests }

uses
  System.Net.HttpClient,
  TestHelpers;

procedure TWebMockResponsesWithHeadersTests.Response_WithHeaderChained_HasValueForEachHeader;
var
  LHeaderName1, LHeaderName2, LHeaderValue1, LHeaderValue2: string;
  LResponse: IHTTPResponse;
begin
  LHeaderName1 := 'Header1';
  LHeaderValue1 := 'Value1';
  LHeaderName2 := 'Header2';
  LHeaderValue2 := 'Value2';

  WebMock.StubRequest('*', '*').ToRespond
    .WithHeader(LHeaderName1, LHeaderValue1)
    .WithHeader(LHeaderName2, LHeaderValue2);
  LResponse := WebClient.Get(WebMock.BaseURL);

  Assert.AreEqual(LHeaderValue1, LResponse.HeaderValue[LHeaderName1]);
  Assert.AreEqual(LHeaderValue2, LResponse.HeaderValue[LHeaderName2]);
end;

procedure TWebMockResponsesWithHeadersTests.Response_WithHeaders_HasValueForAllHeaders;
var
  LHeaders: TStringList;
  LResponse: IHTTPResponse;
  I: Integer;
begin
  LHeaders := TStringList.Create;
  LHeaders.Values['Header1'] := 'Value1';
  LHeaders.Values['Header2'] := 'Value2';
  LHeaders.Values['Header3'] := 'Value3';
  LHeaders.Values['Header4'] := 'Value4';

  WebMock.StubRequest('*', '*').ToRespond.WithHeaders(LHeaders);
  LResponse := WebClient.Get(WebMock.BaseURL);

  for I := 0 to LHeaders.Count - 1 do
    Assert.AreEqual(
      LHeaders.ValueFromIndex[I],
      LResponse.HeaderValue[LHeaders.Names[I]]
    );

  LHeaders.Free;
end;

procedure TWebMockResponsesWithHeadersTests.Response_WithHeader_HasValueForHeader;
var
  LHeaderName, LHeaderValue: string;
  LResponse: IHTTPResponse;
begin
  LHeaderName := 'Header1';
  LHeaderValue := 'Value1';

  WebMock.StubRequest('*', '*').ToRespond.WithHeader(LHeaderName, LHeaderValue);
  LResponse := WebClient.Get(WebMock.BaseURL);

  Assert.AreEqual(LHeaderValue, LResponse.HeaderValue[LHeaderName]);
end;

procedure TWebMockResponsesWithHeadersTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockResponsesWithHeadersTests.TearDown;
begin
  WebMock.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockResponsesWithHeadersTests);
end.
