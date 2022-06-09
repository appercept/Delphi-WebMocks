{******************************************************************************}
{                                                                              }
{           Delphi-WebMocks                                                    }
{                                                                              }
{           Copyright (c) 2019-2021 Richard Hatherall                          }
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
  WebMock.HTTP.RequestMatcher,
  WebMock.Static.RequestStub;

type

  [TestFixture]
  TWebMockStaticRequestStubTests = class(TObject)
  private
    StubbedRequest: TWebMockStaticRequestStub;
    Matcher: TWebMockHTTPRequestMatcher;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
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
    procedure WithFormData_GivenString_ReturnsSelf;
    [Test]
    procedure WithFormData_GivenStringValue_SetsValueForFormData;
    [Test]
    procedure WithFormData_GivenRegExValue_ReturnsSelf;
    [Test]
    procedure WithFormData_GivenRegExValue_SetsValueForFormData;
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
    [Test]
    procedure WithJSON_GivenPathAndBoolean_ReturnsSelf;
    [Test]
    procedure WithJSON_GivenPathAndBoolean_SetsMatcherForContent;
    [Test]
    procedure WithJSON_GivenPathAndFloat_ReturnsSelf;
    [Test]
    procedure WithJSON_GivenPathAndFloat_SetsMatcherForContent;
    [Test]
    procedure WithJSON_GivenPathAndInteger_ReturnsSelf;
    [Test]
    procedure WithJSON_GivenPathAndInteger_SetsMatcherForContent;
    [Test]
    procedure WithJSON_GivenPathAndString_ReturnsSelf;
    [Test]
    procedure WithJSON_GivenPathAndString_SetsMatcherForContent;
    [Test]
    procedure WithJSON_GivenPathAndPattern_ReturnsSelf;
    [Test]
    procedure WithJSON_GivenPathAndPattern_SetsMatcherForContent;
    [Test]
    procedure WithQueryParam_GivenString_ReturnsSelf;
    [Test]
    procedure WithQueryParam_GivenString_SetsMatcherForParam;
    [Test]
    procedure WithQueryParam_GivenRegEx_ReturnsSelf;
    [Test]
    procedure WithQueryParam_GivenRegEx_SetsMatcherForParam;
    [Test]
    procedure WithXML_GivenPathAndString_ReturnsSelf;
    [Test]
    procedure WithXML_GivenPathAndString_SetsMatcherForContent;
    [Test]
    procedure WithXML_GivenPathAndPattern_ReturnsSelf;
    [Test]
    procedure WithXML_GivenPathAndPattern_SetsMatcherForContent;
  end;

implementation

uses
  IdCustomHTTPServer,
  Mock.Indy.HTTPRequestInfo,
  System.Classes,
  System.RegularExpressions,
  WebMock.FormDataMatcher,
  WebMock.FormFieldMatcher,
  WebMock.JSONMatcher,
  WebMock.RequestStub,
  WebMock.Response,
  WebMock.ResponseStatus,
  WebMock.StringMatcher,
  WebMock.StringWildcardMatcher,
  WebMock.StringRegExMatcher,
  WebMock.XMLMatcher;

{ TWebMockRequestStubTests }

procedure TWebMockStaticRequestStubTests.Setup;
begin
  Matcher := TWebMockHTTPRequestMatcher.Create('');
  StubbedRequest := TWebMockStaticRequestStub.Create(Matcher);
end;

procedure TWebMockStaticRequestStubTests.TearDown;
begin
  StubbedRequest.Free;
  Matcher := nil;
end;

procedure TWebMockStaticRequestStubTests.ToRespond_Always_ReturnsAResponseStub;
begin
  Assert.IsNotNull(StubbedRequest.ToRespond);
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
  LExpected, LActual: IWebMockResponse;
begin
  LExpected := StubbedRequest.Responder.GetResponseTo(nil);

  StubbedRequest.ToRespond;

  LActual := StubbedRequest.Responder.GetResponseTo(nil);
  Assert.AreEqual(LExpected.Status, LActual.Status);
end;

procedure TWebMockStaticRequestStubTests.ToRespond_WithResponse_SetsResponseStatus;
var
  LResponse: TWebMockResponseStatus;
begin
  LResponse := TWebMockResponseStatus.Continue;

  StubbedRequest.ToRespond(LResponse);

  Assert.AreEqual(LResponse, StubbedRequest.Responder.GetResponseTo(nil).Status);
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

procedure TWebMockStaticRequestStubTests.WithFormData_GivenRegExValue_ReturnsSelf;
begin
  Assert.AreSame(
    StubbedRequest,
    StubbedRequest.WithFormData('AField', TRegEx.Create(''))
  );
end;

procedure TWebMockStaticRequestStubTests.WithFormData_GivenRegExValue_SetsValueForFormData;
var
  LName: string;
  LValuePattern: TRegEx;
  LFormDataMatcher: TWebMockFormDataMatcher;
  LFormFieldMatcher: TWebMockFormFieldMatcher;
begin
  LName := 'AName';
  LValuePattern := TRegEx.Create('');

  StubbedRequest.WithFormData(LName, LValuePattern);

  LFormDataMatcher := (StubbedRequest.Matcher.Body as TWebMockFormDataMatcher);
  LFormFieldMatcher := (LFormDataMatcher.FieldMatchers[0] as TWebMockFormFieldMatcher);
  Assert.AreEqual(
    LValuePattern,
    (LFormFieldMatcher.ValueMatcher as TWebMockStringRegExMatcher).RegEx
  );
end;

procedure TWebMockStaticRequestStubTests.WithFormData_GivenStringValue_SetsValueForFormData;
var
  LName, LValue: string;
  LFormDataMatcher: TWebMockFormDataMatcher;
  LFormFieldMatcher: TWebMockFormFieldMatcher;
begin
  LName := 'AName';
  LValue := 'AValue';

  StubbedRequest.WithFormData(LName, LValue);

  LFormDataMatcher := (StubbedRequest.Matcher.Body as TWebMockFormDataMatcher);
  LFormFieldMatcher := (LFormDataMatcher.FieldMatchers[0] as TWebMockFormFieldMatcher);
  Assert.AreEqual(
    LValue,
    (LFormFieldMatcher.ValueMatcher as TWebMockStringWildcardMatcher).Value
  );
end;

procedure TWebMockStaticRequestStubTests.WithFormData_GivenString_ReturnsSelf;
begin
  Assert.AreSame(
    StubbedRequest,
    StubbedRequest.WithFormData('AField', 'AValue')
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

procedure TWebMockStaticRequestStubTests.WithJSON_GivenPathAndBoolean_ReturnsSelf;
begin
  Assert.AreSame(StubbedRequest, StubbedRequest.WithJSON('key', True));
end;

procedure TWebMockStaticRequestStubTests.WithJSON_GivenPathAndBoolean_SetsMatcherForContent;
begin
  StubbedRequest.WithJSON('key', True);

  Assert.IsTrue(StubbedRequest.Matcher.Body is TWebMockJSONMatcher);
end;

procedure TWebMockStaticRequestStubTests.WithJSON_GivenPathAndFloat_ReturnsSelf;
begin
  Assert.AreSame(StubbedRequest, StubbedRequest.WithJSON('key', 0.123));
end;

procedure TWebMockStaticRequestStubTests.WithJSON_GivenPathAndFloat_SetsMatcherForContent;
begin
  StubbedRequest.WithJSON('key', 0.123);

  Assert.IsTrue(StubbedRequest.Matcher.Body is TWebMockJSONMatcher);
end;

procedure TWebMockStaticRequestStubTests.WithJSON_GivenPathAndInteger_ReturnsSelf;
begin
  Assert.AreSame(StubbedRequest, StubbedRequest.WithJSON('key', 1));
end;

procedure TWebMockStaticRequestStubTests.WithJSON_GivenPathAndInteger_SetsMatcherForContent;
begin
  StubbedRequest.WithJSON('key', 1);

  Assert.IsTrue(StubbedRequest.Matcher.Body is TWebMockJSONMatcher);
end;

procedure TWebMockStaticRequestStubTests.WithJSON_GivenPathAndPattern_ReturnsSelf;
begin
  Assert.AreSame(
    StubbedRequest,
    StubbedRequest.WithJSON('key', TRegEx.Create('.*'))
  );
end;

procedure TWebMockStaticRequestStubTests.WithJSON_GivenPathAndPattern_SetsMatcherForContent;
begin
  StubbedRequest.WithJSON('key', TRegEx.Create('.*'));

  Assert.IsTrue(StubbedRequest.Matcher.Body is TWebMockJSONMatcher);
end;

procedure TWebMockStaticRequestStubTests.WithJSON_GivenPathAndString_ReturnsSelf;
begin
  Assert.AreSame(StubbedRequest, StubbedRequest.WithJSON('key', 'value'));
end;

procedure TWebMockStaticRequestStubTests.WithJSON_GivenPathAndString_SetsMatcherForContent;
begin
  StubbedRequest.WithJSON('key', 'value');

  Assert.IsTrue(StubbedRequest.Matcher.Body is TWebMockJSONMatcher);
end;

procedure TWebMockStaticRequestStubTests.WithQueryParam_GivenRegEx_ReturnsSelf;
begin
  Assert.AreSame(
    StubbedRequest,
    StubbedRequest.WithQueryParam('name', TRegEx.Create('pattern'))
  );
end;

procedure TWebMockStaticRequestStubTests.WithQueryParam_GivenRegEx_SetsMatcherForParam;
var
  LParamName: string;
  LParamPattern: TRegEx;
begin
  LParamName := 'Header2';
  LParamPattern := TRegEx.Create('');

  StubbedRequest.WithQueryParam(LParamName, LParamPattern);

  Assert.AreEqual(
    LParamPattern,
    (StubbedRequest.Matcher.QueryParams[LParamName] as TWebMockStringRegExMatcher).RegEx
  );
end;

procedure TWebMockStaticRequestStubTests.WithQueryParam_GivenString_ReturnsSelf;
begin
  Assert.AreSame(StubbedRequest, StubbedRequest.WithQueryParam('name', 'value'));
end;

procedure TWebMockStaticRequestStubTests.WithQueryParam_GivenString_SetsMatcherForParam;
var
  LParamName, LParamValue: string;
begin
  LParamName := 'Name1';
  LParamValue := 'Value1';

  StubbedRequest.WithQueryParam(LParamName, LParamValue);

  Assert.AreEqual(
    LParamValue,
    (StubbedRequest.Matcher.QueryParams[LParamName] as TWebMockStringWildcardMatcher).Value
  );
end;

procedure TWebMockStaticRequestStubTests.WithXML_GivenPathAndPattern_ReturnsSelf;
begin
  Assert.AreSame(StubbedRequest,
                 StubbedRequest.WithXML('/path', TRegEx.Create('.*')));
end;

procedure TWebMockStaticRequestStubTests.WithXML_GivenPathAndPattern_SetsMatcherForContent;
begin
  StubbedRequest.WithXML('/Key', TRegEx.Create('.*'));

  Assert.IsTrue(StubbedRequest.Matcher.Body is TWebMockXMLMatcher);
end;

procedure TWebMockStaticRequestStubTests.WithXML_GivenPathAndString_ReturnsSelf;
begin
  Assert.AreSame(StubbedRequest, StubbedRequest.WithXML('/path', 'value'));
end;

procedure TWebMockStaticRequestStubTests.WithXML_GivenPathAndString_SetsMatcherForContent;
begin
  StubbedRequest.WithXML('/Key', 'Value');

  Assert.IsTrue(StubbedRequest.Matcher.Body is TWebMockXMLMatcher);
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockStaticRequestStubTests);
end.
