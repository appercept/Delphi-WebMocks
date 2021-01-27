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

unit WebMock.Assertion.Tests;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.Generics.Collections,
  System.SysUtils,
  WebMock.Assertion,
  WebMock.HTTP.Messages,
  WebMock.HTTP.RequestMatcher;

type
  [TestFixture]
  TWebMockAssertionTests = class(TObject)
  private
    History: IInterfaceList;
    Assertion: TWebMockAssertion;
    function GetMatcher: TWebMockHTTPRequestMatcher;
    property Matcher: TWebMockHTTPRequestMatcher read GetMatcher;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Request_GiveMethodAndURIString_ReturnsSelf;
    [Test]
    procedure Request_GivenMethodAndURIString_SetsMatcherValues;
    [Test]
    procedure Request_GiveMethodAndURIRegEx_ReturnsSelf;
    [Test]
    procedure Request_GivenMethodAndURIRegEx_SetsMatcherValues;
    [Test]
    procedure Delete_GivenMethodAndURI_SetsMatcherValues;
    [Test]
    procedure Delete_Always_ReturnsSelf;
    [Test]
    procedure Get_GivenMethodAndURI_SetsMatcherValues;
    [Test]
    procedure Get_Always_ReturnsSelf;
    [Test]
    procedure Patch_GivenMethodAndURI_SetsMatcherValues;
    [Test]
    procedure Patch_Always_ReturnsSelf;
    [Test]
    procedure Post_GivenMethodAndURI_SetsMatcherValues;
    [Test]
    procedure Post_Always_ReturnsSelf;
    [Test]
    procedure Put_GivenMethodAndURI_SetsMatcherValues;
    [Test]
    procedure Put_Always_ReturnsSelf;
    [Test]
    procedure WasRequested_MatchingHistory_RaisesPassingException;
    [Test]
    procedure WasRequested_NotMatchingHistory_RaisesFailingException;
    [Test]
    procedure WasNotRequested_NotMatchingHistory_RaisesPassingException;
    [Test]
    procedure WasNotRequested_MatchingHistory_RaisesFailingException;
    [Test]
    procedure WithBody_GivenString_ReturnsSelf;
    [Test]
    procedure WithBody_GivenString_SetsMatcherValue;
    [Test]
    procedure WithBody_GivenRegEx_ReturnsSelf;
    [Test]
    procedure WithBody_GivenRegEx_SetsMatcherValue;
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
    procedure WithQueryParam_GivenNameAndValue_ReturnsSelf;
    [Test]
    procedure WithQueryParam_GivenNameAndValue_SetsValueForQueryParam;
    [Test]
    procedure WithQueryParam_GivenNameAndRegEx_SetsPatternForQueryParam;
    [Test]
    procedure WithFormData_GivenNameAndValue_ReturnsSelf;
    [Test]
    procedure WithFormData_GivenNameAndValue_SetsValueForBodyMatcher;
    [Test]
    procedure WithFormData_GivenNameAndRegEx_SetsPatternForBodyMatcher;
    [Test]
    procedure WithJSON_GivenPathAndBoolean_ReturnsSelf;
    [Test]
    procedure WithJSON_GivenPathAndBoolean_SetsValueForBodyMatcher;
    [Test]
    procedure WithJSON_GivenPathAndFloat_ReturnsSelf;
    [Test]
    procedure WithJSON_GivenPathAndFloat_SetsValueForBodyMatcher;
    [Test]
    procedure WithJSON_GivenPathAndInteger_ReturnsSelf;
    [Test]
    procedure WithJSON_GivenPathAndInteger_SetsValueForBodyMatcher;
    [Test]
    procedure WithJSON_GivenPathAndString_ReturnsSelf;
    [Test]
    procedure WithJSON_GivenPathAndString_SetsValueForBodyMatcher;
  end;

implementation

{ TWebMockAssertionTests }

uses
  DUnitX.Exceptions,
  Mock.Indy.HTTPRequestInfo,
  System.RegularExpressions,
  System.Rtti,
  WebMock.FormDataMatcher,
  WebMock.FormFieldMatcher,
  WebMock.HTTP.Request,
  WebMock.JSONMatcher,
  WebMock.StringRegExMatcher,
  WebMock.StringMatcher,
  WebMock.StringWildcardMatcher;

procedure TWebMockAssertionTests.Delete_Always_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Delete('/'));

  Assertion.Free;
end;

procedure TWebMockAssertionTests.Delete_GivenMethodAndURI_SetsMatcherValues;
var
  LURI: string;
begin
  LURI := '/resource';

  Assertion.Delete(LURI);

  Assert.IsMatch('DELETE\s/resource', Assertion.Matcher.ToString);

  Assertion.Free;
end;

function TWebMockAssertionTests.GetMatcher: TWebMockHTTPRequestMatcher;
begin
  Result := Assertion.Matcher as TWebMockHTTPRequestMatcher;
end;

procedure TWebMockAssertionTests.Get_Always_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Get('/'));

  Assertion.Free;
end;

procedure TWebMockAssertionTests.Get_GivenMethodAndURI_SetsMatcherValues;
var
  LURI: string;
begin
  LURI := '/resource';

  Assertion.Get(LURI);

  Assert.IsMatch('GET\s/resource', Assertion.Matcher.ToString);

  Assertion.Free;
end;

procedure TWebMockAssertionTests.Patch_Always_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Patch('/'));

  Assertion.Free;
end;

procedure TWebMockAssertionTests.Patch_GivenMethodAndURI_SetsMatcherValues;
var
  LURI: string;
begin
  LURI := '/resource';

  Assertion.Patch(LURI);

  Assert.IsMatch('PATCH\s/resource', Assertion.Matcher.ToString);

  Assertion.Free;
end;

procedure TWebMockAssertionTests.Post_Always_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Post('/'));

  Assertion.Free;
end;

procedure TWebMockAssertionTests.Post_GivenMethodAndURI_SetsMatcherValues;
var
  LURI: string;
begin
  LURI := '/resource';

  Assertion.Post(LURI);

  Assert.IsMatch('POST\s/resource', Assertion.Matcher.ToString);

  Assertion.Free;
end;

procedure TWebMockAssertionTests.Put_Always_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Put('/'));

  Assertion.Free;
end;

procedure TWebMockAssertionTests.Put_GivenMethodAndURI_SetsMatcherValues;
var
  LURI: string;
begin
  LURI := '/resource';

  Assertion.Put(LURI);

  Assert.IsMatch('PUT\s/resource', Assertion.Matcher.ToString);

  Assertion.Free;
end;

procedure TWebMockAssertionTests.Request_GiveMethodAndURIRegEx_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Request('GET', TRegEx.Create('.+')));

  Assertion.Free;
end;

procedure TWebMockAssertionTests.Request_GiveMethodAndURIString_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Request('GET', '/'));

  Assertion.Free;
end;

procedure TWebMockAssertionTests.Request_GivenMethodAndURIRegEx_SetsMatcherValues;
var
  LMethod: string;
  LPattern: TRegEx;
begin
  LMethod := 'PATCH';
  LPattern := TRegEx.Create('.+');

  Assertion.Request(LMethod, LPattern);

  Assert.IsMatch('PATCH\sRegular Expression', Assertion.Matcher.ToString);

  Assertion.Free;
end;

procedure TWebMockAssertionTests.Request_GivenMethodAndURIString_SetsMatcherValues;
var
  LMethod, LURI: string;
begin
  LMethod := 'PATCH';
  LURI := '/resource';

  Assertion.Request(LMethod, LURI);

  Assert.IsMatch('PATCH\s/resource', Assertion.Matcher.ToString);

  Assertion.Free;
end;

procedure TWebMockAssertionTests.Setup;
begin
  History := TInterfaceList.Create;
  Assertion := TWebMockAssertion.Create(History);
end;

procedure TWebMockAssertionTests.TearDown;
begin
  History := nil;
end;

procedure TWebMockAssertionTests.WasRequested_NotMatchingHistory_RaisesFailingException;
var
  LRequestInfo: TMockIdHTTPRequestInfo;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/');
  History.Add(TWebMockHTTPRequest.Create(LRequestInfo));
  LRequestInfo.Free;

  Assert.WillRaise(
    procedure
    begin
      Assertion.Request('DELETE', '/').WasRequested;
    end,
    ETestFailure
  );
end;

procedure TWebMockAssertionTests.WithBody_GivenString_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Put('/').WithBody(''));

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithBody_GivenRegEx_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Put('/').WithBody(TRegEx.Create('.+')));

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithBody_GivenRegEx_SetsMatcherValue;
var
  LPattern: TRegEx;
begin
  LPattern := TRegEx.Create('.+');

  Assertion.Put('/').WithBody(LPattern);

  Assert.AreEqual(
    LPattern,
    (Matcher.Body as TWebMockStringRegExMatcher).RegEx
  );

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithBody_GivenString_SetsMatcherValue;
var
  LBody: string;
begin
  LBody := 'OK';

  Assertion.Post('/').WithBody(LBody);

  Assert.AreEqual(
    LBody,
    (Matcher.Body as TWebMockStringWildcardMatcher).Value
  );

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithFormData_GivenNameAndRegEx_SetsPatternForBodyMatcher;
var
  LName: string;
  LPattern: TRegEx;
  LHTTPMatcher: TWebMockHTTPRequestMatcher;
  LFormDataMatcher: TWebMockFormDataMatcher;
  LFormFieldMatcher: TWebMockFormFieldMatcher;
begin
  LName := 'Param1';
  LPattern := TRegEx.Create('');

  Assertion.Put('/').WithFormData(LName, LPattern);

  LHTTPMatcher := Assertion.Matcher as TWebMockHTTPRequestMatcher;
  LFormDataMatcher := LHTTPMatcher.Body as TWebMockFormDataMatcher;
  LFormFieldMatcher := LFormDataMatcher.FieldMatchers[0] as TWebMockFormFieldMatcher;
  Assert.AreEqual(
    LPattern,
    (LFormFieldMatcher.ValueMatcher as TWebMockStringRegExMatcher).RegEx
  );

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithFormData_GivenNameAndValue_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Put('/').WithFormData('AName', 'AValue'));

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithFormData_GivenNameAndValue_SetsValueForBodyMatcher;
var
  LName, LValue: string;
  LHTTPMatcher: TWebMockHTTPRequestMatcher;
  LFormDataMatcher: TWebMockFormDataMatcher;
  LFormFieldMatcher: TWebMockFormFieldMatcher;
begin
  LName := 'Param1';
  LValue := 'Value1';

  Assertion.Get('/').WithFormData(LName, LValue);

  LHTTPMatcher := Assertion.Matcher as TWebMockHTTPRequestMatcher;
  LFormDataMatcher := LHTTPMatcher.Body as TWebMockFormDataMatcher;
  LFormFieldMatcher := LFormDataMatcher.FieldMatchers[0] as TWebMockFormFieldMatcher;
  Assert.AreEqual(
    LValue,
    (LFormFieldMatcher.ValueMatcher as TWebMockStringWildcardMatcher).Value
  );

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithHeaders_Always_ReturnsSelf;
var
  LHeaders: TStringList;
begin
  LHeaders := TStringList.Create;

  Assert.AreSame(Assertion, Assertion.Get('/').WithHeaders(LHeaders));

  LHeaders.Free;
  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithHeaders_Always_SetsAllValues;
var
  LHeaders: TStringList;
  LHeaderName, LHeaderValue: string;
  I: Integer;
begin
  LHeaders := TStringList.Create;
  LHeaders.Values['Header1'] := 'Value1';
  LHeaders.Values['Header2'] := 'Value2';

  Assertion.Get('/').WithHeaders(LHeaders);

  for I := 0 to LHeaders.Count - 1 do
  begin
    LHeaderName := LHeaders.Names[I];
    LHeaderValue := LHeaders.ValueFromIndex[I];
    Assert.AreEqual(
      LHeaderValue,
      (Matcher.Headers[LHeaderName] as TWebMockStringWildcardMatcher).Value
    );
  end;

  LHeaders.Free;
  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithHeader_Always_OverwritesExistingValues;
var
  LHeaderName, LHeaderValue1, LHeaderValue2: string;
  LMatcher: IStringMatcher;
begin
  LHeaderName := 'Header1';
  LHeaderValue1 := 'Value1';
  LHeaderValue2 := 'Value2';

  Assertion.Get('/').WithHeader(LHeaderName, LHeaderValue1);
  LMatcher := Matcher.Headers[LHeaderName];
  Assertion.WithHeader(LHeaderName, LHeaderValue2);

  Assert.AreNotSame(LMatcher, Matcher.Headers[LHeaderName]);

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithHeader_GivenRegEx_ReturnsSelf;
begin
  Assert.AreSame(
    Assertion,
    Assertion.Get('/').WithHeader('Header', TRegEx.Create(''))
  );

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithHeader_GivenRegEx_SetsPatternForHeader;
var
  LHeaderName: string;
  LHeaderPattern: TRegEx;
begin
  LHeaderName := 'Header1';
  LHeaderPattern := TRegEx.Create('');

  Assertion.Get('/').WithHeader(LHeaderName, LHeaderPattern);

  Assert.AreEqual(
    LHeaderPattern,
    (Matcher.Headers[LHeaderName] as TWebMockStringRegExMatcher).RegEx
  );

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithHeader_GivenString_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Get('/').WithHeader('Header', 'Value'));

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithHeader_GivenString_SetsValueForHeader;
var
  LHeaderName, LHeaderValue: string;
begin
  LHeaderName := 'Header1';
  LHeaderValue := 'Value1';

  Assertion.Get('/').WithHeader(LHeaderName, LHeaderValue);

  Assert.AreEqual(
    LHeaderValue,
    (Matcher.Headers[LHeaderName] as TWebMockStringWildcardMatcher).Value
  );

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithJSON_GivenPathAndBoolean_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Put('/').WithJSON('AKey', True));

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithJSON_GivenPathAndBoolean_SetsValueForBodyMatcher;
var
  LPath: string;
  LValue: Boolean;
  LHTTPMatcher: TWebMockHTTPRequestMatcher;
  LJSONMatcher: TWebMockJSONMatcher;
  LJSONValueMatcher: TWebMockJSONValueMatcher<Boolean>;
begin
  LPath := 'Key1';
  LValue := True;

  Assertion.Post('/').WithJSON(LPath, LValue);

  LHTTPMatcher := Assertion.Matcher as TWebMockHTTPRequestMatcher;
  LJSONMatcher := LHTTPMatcher.Body as TWebMockJSONMatcher;
  LJSONValueMatcher := LJSONMatcher.ValueMatchers[0] as TWebMockJSONValueMatcher<Boolean>;
  Assert.AreEqual(LValue, LJSONValueMatcher.Value);

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithJSON_GivenPathAndFloat_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Put('/').WithJSON('AKey', 0.12));

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithJSON_GivenPathAndFloat_SetsValueForBodyMatcher;
var
  LPath: string;
  LValue: Float64;
  LHTTPMatcher: TWebMockHTTPRequestMatcher;
  LJSONMatcher: TWebMockJSONMatcher;
  LJSONValueMatcher: TWebMockJSONValueMatcher<Float64>;
begin
  LPath := 'Key1';
  LValue := 0.1;

  Assertion.Post('/').WithJSON(LPath, LValue);

  LHTTPMatcher := Assertion.Matcher as TWebMockHTTPRequestMatcher;
  LJSONMatcher := LHTTPMatcher.Body as TWebMockJSONMatcher;
  LJSONValueMatcher := LJSONMatcher.ValueMatchers[0] as TWebMockJSONValueMatcher<Float64>;
  Assert.AreEqual(LValue, LJSONValueMatcher.Value);

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithJSON_GivenPathAndInteger_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Put('/').WithJSON('AKey', 1));

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithJSON_GivenPathAndInteger_SetsValueForBodyMatcher;
var
  LPath: string;
  LValue: Integer;
  LHTTPMatcher: TWebMockHTTPRequestMatcher;
  LJSONMatcher: TWebMockJSONMatcher;
  LJSONValueMatcher: TWebMockJSONValueMatcher<Integer>;
begin
  LPath := 'Key1';
  LValue := 1;

  Assertion.Post('/').WithJSON(LPath, LValue);

  LHTTPMatcher := Assertion.Matcher as TWebMockHTTPRequestMatcher;
  LJSONMatcher := LHTTPMatcher.Body as TWebMockJSONMatcher;
  LJSONValueMatcher := LJSONMatcher.ValueMatchers[0] as TWebMockJSONValueMatcher<Integer>;
  Assert.AreEqual(LValue, LJSONValueMatcher.Value);

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithJSON_GivenPathAndString_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Put('/').WithJSON('AKey', 'AValue'));

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithJSON_GivenPathAndString_SetsValueForBodyMatcher;
var
  LPath, LValue: string;
  LHTTPMatcher: TWebMockHTTPRequestMatcher;
  LJSONMatcher: TWebMockJSONMatcher;
  LJSONValueMatcher: TWebMockJSONValueMatcher<string>;
begin
  LPath := 'Key1';
  LValue := 'Value1';

  Assertion.Post('/').WithJSON(LPath, LValue);

  LHTTPMatcher := Assertion.Matcher as TWebMockHTTPRequestMatcher;
  LJSONMatcher := LHTTPMatcher.Body as TWebMockJSONMatcher;
  LJSONValueMatcher := LJSONMatcher.ValueMatchers[0] as TWebMockJSONValueMatcher<string>;
  Assert.AreEqual(LValue, LJSONValueMatcher.Value);

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithQueryParam_GivenNameAndValue_SetsValueForQueryParam;
var
  LParamName, LParamValue: string;
begin
  LParamName := 'Param1';
  LParamValue := 'Value1';

  Assertion.Get('/').WithQueryParam(LParamName, LParamValue);

  Assert.AreEqual(
    LParamValue,
    (Matcher.QueryParams[LParamName] as TWebMockStringWildcardMatcher).Value
  );

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithQueryParam_GivenNameAndRegEx_SetsPatternForQueryParam;
var
  LParamName: string;
  LParamPattern: TRegEx;
begin
  LParamName := 'Header1';
  LParamPattern := TRegEx.Create('');

  Assertion.Get('/').WithQueryParam(LParamName, LParamPattern);

  Assert.AreEqual(
    LParamPattern,
    (Matcher.QueryParams[LParamName] as TWebMockStringRegExMatcher).RegEx
  );

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WithQueryParam_GivenNameAndValue_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Get('/').WithQueryParam('ParamName', 'Value'));

  Assertion.Free;
end;

procedure TWebMockAssertionTests.WasNotRequested_MatchingHistory_RaisesFailingException;
var
  LRequestInfo: TMockIdHTTPRequestInfo;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/');
  History.Add(TWebMockHTTPRequest.Create(LRequestInfo));
  LRequestInfo.Free;

  Assert.WillRaise(
    procedure
    begin
      Assertion.Request('GET', '/').WasNotRequested;
    end,
    ETestFailure
  );
end;

procedure TWebMockAssertionTests.WasNotRequested_NotMatchingHistory_RaisesPassingException;
var
  LRequestInfo: TMockIdHTTPRequestInfo;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/');
  History.Add(TWebMockHTTPRequest.Create(LRequestInfo));
  LRequestInfo.Free;

  Assert.WillRaise(
    procedure
    begin
      Assertion.Request('DELETE', '/').WasNotRequested;
    end,
    ETestPass
  );
end;

procedure TWebMockAssertionTests.WasRequested_MatchingHistory_RaisesPassingException;
var
  LRequestInfo: TMockIdHTTPRequestInfo;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/');
  History.Add(TWebMockHTTPRequest.Create(LRequestInfo));
  LRequestInfo.Free;

  Assert.WillRaise(
    procedure
    begin
      Assertion.Request('GET', '/').WasRequested;
    end,
    ETestPass
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockAssertionTests);
end.
