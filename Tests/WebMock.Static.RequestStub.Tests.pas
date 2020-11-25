{******************************************************************************}
{                                                                              }
{           Delphi-WebMocks                                                    }
{                                                                              }
{           Copyright (c) 2019-2020 Richard Hatherall                          }
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

unit WebMock.Static.RequestStub.Tests;

interface

uses
  DUnitX.TestFramework,
  WebMock.Static.RequestStub;

type

  [TestFixture]
  TWebMockStaticRequestStubTests = class(TObject)
  private
    StubbedRequest: TWebMockStaticRequestStub;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Class_Always_ImplementsIWebMockRequestStub;
    [Test]
    procedure ToRespond_Always_ReturnsAResponseStub;
    [Test]
    procedure ToRespond_WithNoArguments_DoesNotRaiseException;
    [Test]
    procedure ToRespond_WithNoArguments_DoesNotChangeStatus;
    [Test]
    procedure ToRespond_WithResponse_SetsResponseStatus;
    [Test]
    procedure WithBody_GivenString_ReturnsSelf;
    [Test]
    procedure WithBody_GivenString_SetsValueForContent;
    [Test]
    procedure WithBody_GivenRegEx_ReturnsSelf;
    [Test]
    procedure WithBody_GivenRegEx_SetsValueForContent;
    [Test]
    procedure WithHeader_GivenString_ReturnsSelf;
    [Test]
    procedure WithHeader_GivenString_SetsValueForHeader;
    [Test]
    procedure WithHeader_Always_OverwritesExistingValues;
    [Test]
    procedure WithHeader_GivenRegEx_ReturnsSelf;
    [Test]
    procedure WithHeader_GivenRegEx_SetsPatternForHeader;
    [Test]
    procedure WithHeaders_Always_ReturnsSelf;
    [Test]
    procedure WithHeaders_Always_SetsAllValues;
  end;

implementation

uses
  IdCustomHTTPServer,
  Mock.Indy.HTTPRequestInfo,
  System.Classes,
  System.RegularExpressions,
  WebMock.HTTP.RequestMatcher,
  WebMock.RequestStub,
  WebMock.Response,
  WebMock.ResponseStatus,
  WebMock.StringMatcher,
  WebMock.StringWildcardMatcher,
  WebMock.StringRegExMatcher;

{ TWebMockRequestStubTests }

procedure TWebMockStaticRequestStubTests.Class_Always_ImplementsIWebMockRequestStub;
var
  LSubject: IInterface;
begin
  LSubject := StubbedRequest;

  Assert.Implements<IWebMockRequestStub>(LSubject);
end;

procedure TWebMockStaticRequestStubTests.Setup;
var
  LMatcher: TWebMockHTTPRequestMatcher;
begin
  LMatcher := TWebMockHTTPRequestMatcher.Create('');
  StubbedRequest := TWebMockStaticRequestStub.Create(LMatcher);
end;

procedure TWebMockStaticRequestStubTests.TearDown;
begin
  StubbedRequest := nil;
end;

procedure TWebMockStaticRequestStubTests.ToRespond_Always_ReturnsAResponseStub;
begin
  Assert.IsNotNull(StubbedRequest.ToRespond as IWebMockResponseBuilder);
end;

procedure TWebMockStaticRequestStubTests.ToRespond_WithNoArguments_DoesNotRaiseException;
begin
  Assert.WillNotRaiseAny(
  procedure
  begin
    StubbedRequest.ToRespond;
  end);
end;

procedure TWebMockStaticRequestStubTests.ToRespond_WithNoArguments_DoesNotChangeStatus;
var
  LExpectedStatus: TWebMockResponseStatus;
begin
  LExpectedStatus := StubbedRequest.Responder.GetResponseTo(nil).Status;

  StubbedRequest.ToRespond;

  Assert.AreSame(LExpectedStatus,
                 StubbedRequest.Responder.GetResponseTo(nil).Status);
end;

procedure TWebMockStaticRequestStubTests.ToRespond_WithResponse_SetsResponseStatus;
var
  LResponse: TWebMockResponseStatus;
begin
  LResponse := TWebMockResponseStatus.Continue;

  StubbedRequest.ToRespond(LResponse);

  Assert.AreSame(LResponse, StubbedRequest.Responder.GetResponseTo(nil).Status);
end;

procedure TWebMockStaticRequestStubTests.WithBody_GivenRegEx_ReturnsSelf;
begin
  Assert.AreSame(
    StubbedRequest,
    StubbedRequest.WithBody(TRegEx.Create('Hello.'))
  );
end;

procedure TWebMockStaticRequestStubTests.WithBody_GivenRegEx_SetsValueForContent;
var
  LPattern: TRegEx;
begin
  LPattern := TRegEx.Create('.+');

  StubbedRequest.WithBody(LPattern);

  Assert.AreEqual(
    LPattern,
    (StubbedRequest.Matcher.Body as TWebMockStringRegExMatcher).RegEx
  );
end;

procedure TWebMockStaticRequestStubTests.WithBody_GivenString_ReturnsSelf;
begin
  Assert.AreSame(StubbedRequest, StubbedRequest.WithBody('Hello.'));
end;

procedure TWebMockStaticRequestStubTests.WithBody_GivenString_SetsValueForContent;
var
  LContent: string;
begin
  LContent := 'Welcome!';

  StubbedRequest.WithBody(LContent);

  Assert.AreEqual(
    LContent,
    (StubbedRequest.Matcher.Body as TWebMockStringWildcardMatcher).Value
  );
end;

procedure TWebMockStaticRequestStubTests.WithHeaders_Always_ReturnsSelf;
var
  LHeaders: TStringList;
begin
  LHeaders := TStringList.Create;

  Assert.AreSame(StubbedRequest, StubbedRequest.WithHeaders(LHeaders));

  LHeaders.Free;
end;

procedure TWebMockStaticRequestStubTests.WithHeaders_Always_SetsAllValues;
var
  LHeaders: TStringList;
  LHeaderName, LHeaderValue: string;
  I: Integer;
begin
  LHeaders := TStringList.Create;
  LHeaders.Values['Header1'] := 'Value1';
  LHeaders.Values['Header2'] := 'Value2';

  StubbedRequest.WithHeaders(LHeaders);

  for I := 0 to LHeaders.Count - 1 do
  begin
    LHeaderName := LHeaders.Names[I];
    LHeaderValue := LHeaders.ValueFromIndex[I];
    Assert.AreEqual(
      LHeaderValue,
      (StubbedRequest.Matcher.Headers[LHeaderName] as TWebMockStringWildcardMatcher).Value
    );
  end;

  LHeaders.Free;
end;

procedure TWebMockStaticRequestStubTests.WithHeader_Always_OverwritesExistingValues;
var
  LHeaderName, LHeaderValue1, LHeaderValue2: string;
  LMatcher: IStringMatcher;
begin
  LHeaderName := 'Header1';
  LHeaderValue1 := 'Value1';
  LHeaderValue2 := 'Value2';

  StubbedRequest.WithHeader(LHeaderName, LHeaderValue1);
  LMatcher := StubbedRequest.Matcher.Headers[LHeaderName];
  StubbedRequest.WithHeader(LHeaderName, LHeaderValue2);

  Assert.AreNotSame(LMatcher, StubbedRequest.Matcher.Headers[LHeaderName]);
end;

procedure TWebMockStaticRequestStubTests.WithHeader_GivenRegEx_ReturnsSelf;
begin
  Assert.AreSame(
    StubbedRequest,
    StubbedRequest.WithHeader('Header', TRegEx.Create(''))
  );
end;

procedure TWebMockStaticRequestStubTests.WithHeader_GivenRegEx_SetsPatternForHeader;
var
  LHeaderName: string;
  LHeaderPattern: TRegEx;
begin
  LHeaderName := 'Header1';
  LHeaderPattern := TRegEx.Create('');

  StubbedRequest.WithHeader(LHeaderName, LHeaderPattern);

  Assert.AreEqual(
    LHeaderPattern,
    (StubbedRequest.Matcher.Headers[LHeaderName] as TWebMockStringRegExMatcher).RegEx
  );
end;

procedure TWebMockStaticRequestStubTests.WithHeader_GivenString_ReturnsSelf;
begin
  Assert.AreSame(StubbedRequest, StubbedRequest.WithHeader('Header', 'Value'));
end;

procedure TWebMockStaticRequestStubTests.WithHeader_GivenString_SetsValueForHeader;
var
  LHeaderName, LHeaderValue: string;
begin
  LHeaderName := 'Header1';
  LHeaderValue := 'Value1';

  StubbedRequest.WithHeader(LHeaderName, LHeaderValue);

  Assert.AreEqual(
    LHeaderValue,
    (StubbedRequest.Matcher.Headers[LHeaderName] as TWebMockStringWildcardMatcher).Value
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockStaticRequestStubTests);
end.
