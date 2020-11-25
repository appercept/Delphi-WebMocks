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

unit WebMock.History.Tests;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  WebMock;

type
  [TestFixture]
  TWebMockHistoryTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure History_AfterStubbedRequest_IncreasesCount;
    [Test]
    procedure History_AfterUnStubbedRequest_IncreasesCount;
    [Test]
    procedure History_AfterRequest_ContainsMatchingRequest;
  end;

implementation

{ TWebMockHistoryTests }

uses
  System.Generics.Collections,
  TestHelpers,
  WebMock.HTTP.Messages;

procedure TWebMockHistoryTests.History_AfterRequest_ContainsMatchingRequest;
var
  LastRequest: IWebMockHTTPRequest;
begin
  WebClient.Get(WebMock.URLFor('resource'));

  LastRequest := WebMock.History.Last;
  Assert.AreEqual('GET', LastRequest.Method);
  Assert.AreEqual('/resource', LastRequest.RequestURI);
end;

procedure TWebMockHistoryTests.History_AfterStubbedRequest_IncreasesCount;
var
  ExpectedHistoryCount: Integer;
begin
  ExpectedHistoryCount := WebMock.History.Count + 1;
  WebMock.StubRequest('GET', '/stubbed');

  WebClient.Get(WebMock.URLFor('stubbed'));

  Assert.AreEqual(ExpectedHistoryCount, WebMock.History.Count);
end;

procedure TWebMockHistoryTests.History_AfterUnStubbedRequest_IncreasesCount;
var
  ExpectedHistoryCount: Integer;
begin
  ExpectedHistoryCount := WebMock.History.Count + 1;

  WebClient.Get(WebMock.URLFor('not-stubbed'));

  Assert.AreEqual(ExpectedHistoryCount, WebMock.History.Count);
end;

procedure TWebMockHistoryTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockHistoryTests.TearDown;
begin
  WebMock.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockHistoryTests);
end.
