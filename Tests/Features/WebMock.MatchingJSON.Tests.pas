{******************************************************************************}
{                                                                              }
{           Delphi-WebMocks                                                    }
{                                                                              }
{           Copyright (c) 2021 Richard Hatherall                               }
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

unit WebMock.MatchingJSON.Tests;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  WebMock;

type
  [TestFixture]
  TWebMockMatchingJSONTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Request_MatchingJSONContent_RespondsOK;
    [Test]
    procedure Request_NotMatchingJSONContent_RespondsNotImplemented;
  end;

implementation

uses
  System.Net.HttpClient,
  System.Net.URLClient,
  System.RegularExpressions,
  TestHelpers;

{ TWebMockMatchingJSONTests }

procedure TWebMockMatchingJSONTests.Request_MatchingJSONContent_RespondsOK;
var
  LContent: string;
  LContentStream: TStringStream;
  LHeaders: TNetHeaders;
  LResponse: IHTTPResponse;
begin
  LContent := '{ "key": "value" }';
  LContentStream := TStringStream.Create(LContent);
  LHeaders := TNetHeaders.Create(
    TNetHeader.Create('content-type', 'application/json')
  );

  WebMock.StubRequest('*', '*').WithJSON('key', 'value');
  LResponse := WebClient.Post(WebMock.BaseURL, LContentStream, nil, LHeaders);

  Assert.AreEqual(200, LResponse.StatusCode);

  LContentStream.Free;
end;

procedure TWebMockMatchingJSONTests.Request_NotMatchingJSONContent_RespondsNotImplemented;
var
  LContent: string;
  LContentStream: TStringStream;
  LHeaders: TNetHeaders;
  LResponse: IHTTPResponse;
begin
  LContent := '{ "key": "value" }';
  LContentStream := TStringStream.Create(LContent);
  LHeaders := TNetHeaders.Create(
    TNetHeader.Create('content-type', 'application/json')
  );

  WebMock.StubRequest('*', '*').WithJSON('key', 'othervalue');
  LResponse := WebClient.Post(WebMock.BaseURL, LContentStream, nil, LHeaders);

  Assert.AreEqual(501, LResponse.StatusCode);

  LContentStream.Free;
end;

procedure TWebMockMatchingJSONTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockMatchingJSONTests.TearDown;
begin
  WebMock.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockMatchingJSONTests);
end.
