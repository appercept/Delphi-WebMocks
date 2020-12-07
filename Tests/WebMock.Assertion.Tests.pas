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

unit WebMock.Assertion.Tests;

interface

uses
  DUnitX.TestFramework,
  System.Classes, System.Generics.Collections, System.SysUtils,
  WebMock.Assertion, WebMock.HTTP.Messages;

type
  [TestFixture]
  TWebMockAssertionTests = class(TObject)
  private
    History: TList<IWebMockHTTPRequest>;
    Assertion: TWebMockAssertion;
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
  end;

implementation

{ TWebMockAssertionTests }

uses
  DUnitX.Exceptions,
  Mock.Indy.HTTPRequestInfo,
  System.RegularExpressions,
  WebMock.HTTP.Request, WebMock.StringRegExMatcher, WebMock.StringMatcher,
  WebMock.StringWildcardMatcher;

procedure TWebMockAssertionTests.Delete_Always_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Delete('/'));
end;

procedure TWebMockAssertionTests.Delete_GivenMethodAndURI_SetsMatcherValues;
var
  LURI: string;
begin
  LURI := '/resource';

  Assertion.Delete(LURI);

  Assert.AreEqual('DELETE', Assertion.Matcher.HTTPMethod);
  Assert.AreEqual(
    LURI,
    (Assertion.Matcher.URIMatcher as TWebMockStringWildcardMatcher).Value
  );
end;

procedure TWebMockAssertionTests.Get_Always_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Get('/'));
end;

procedure TWebMockAssertionTests.Get_GivenMethodAndURI_SetsMatcherValues;
var
  LURI: string;
begin
  LURI := '/resource';

  Assertion.Get(LURI);

  Assert.AreEqual('GET', Assertion.Matcher.HTTPMethod);
  Assert.AreEqual(
    LURI,
    (Assertion.Matcher.URIMatcher as TWebMockStringWildcardMatcher).Value
  );
end;

procedure TWebMockAssertionTests.Patch_Always_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Patch('/'));
end;

procedure TWebMockAssertionTests.Patch_GivenMethodAndURI_SetsMatcherValues;
var
  LURI: string;
begin
  LURI := '/resource';

  Assertion.Patch(LURI);

  Assert.AreEqual('PATCH', Assertion.Matcher.HTTPMethod);
  Assert.AreEqual(
    LURI,
    (Assertion.Matcher.URIMatcher as TWebMockStringWildcardMatcher).Value
  );
end;

procedure TWebMockAssertionTests.Post_Always_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Post('/'));
end;

procedure TWebMockAssertionTests.Post_GivenMethodAndURI_SetsMatcherValues;
var
  LURI: string;
begin
  LURI := '/resource';

  Assertion.Post(LURI);

  Assert.AreEqual('POST', Assertion.Matcher.HTTPMethod);
  Assert.AreEqual(
    LURI,
    (Assertion.Matcher.URIMatcher as TWebMockStringWildcardMatcher).Value
  );
end;

procedure TWebMockAssertionTests.Put_Always_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Put('/'));
end;

procedure TWebMockAssertionTests.Put_GivenMethodAndURI_SetsMatcherValues;
var
  LURI: string;
begin
  LURI := '/resource';

  Assertion.Put(LURI);

  Assert.AreEqual('PUT', Assertion.Matcher.HTTPMethod);
  Assert.AreEqual(
    LURI,
    (Assertion.Matcher.URIMatcher as TWebMockStringWildcardMatcher).Value
  );
end;

procedure TWebMockAssertionTests.Request_GiveMethodAndURIRegEx_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Request('GET', TRegEx.Create('.+')));
end;

procedure TWebMockAssertionTests.Request_GiveMethodAndURIString_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Request('GET', '/'));
end;

procedure TWebMockAssertionTests.Request_GivenMethodAndURIRegEx_SetsMatcherValues;
var
  LMethod: string;
  LPattern: TRegEx;
begin
  LMethod := 'PATCH';
  LPattern := TRegEx.Create('.+');

  Assertion.Request(LMethod, LPattern);

  Assert.AreEqual(LMethod, Assertion.Matcher.HTTPMethod);
  Assert.AreEqual(
    LPattern,
    (Assertion.Matcher.URIMatcher as TWebMockStringRegExMatcher).RegEx
  );
end;

procedure TWebMockAssertionTests.Request_GivenMethodAndURIString_SetsMatcherValues;
var
  LMethod, LURI: string;
begin
  LMethod := 'PATCH';
  LURI := '/resource';

  Assertion.Request(LMethod, LURI);

  Assert.AreEqual(LMethod, Assertion.Matcher.HTTPMethod);
  Assert.AreEqual(
    LURI,
    (Assertion.Matcher.URIMatcher as TWebMockStringWildcardMatcher).Value
  );
end;

procedure TWebMockAssertionTests.Setup;
begin
  History := TList<IWebMockHTTPRequest>.Create;
  Assertion := TWebMockAssertion.Create(History);
end;

procedure TWebMockAssertionTests.TearDown;
begin
  Assertion.Free;
  History.Free;
end;

procedure TWebMockAssertionTests.WasRequested_NotMatchingHistory_RaisesFailingException;
var
  LRequestInfo: TMockIdHTTPRequestInfo;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/');
  History.Add(TWebMockHTTPRequest.Create(LRequestInfo));

  Assert.WillRaise(
    procedure
    begin
      Assertion.Request('DELETE', '/').WasRequested;
    end,
    ETestFailure
  );

  LRequestInfo.Free;
end;

procedure TWebMockAssertionTests.WithBody_GivenString_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Put('/').WithBody(''));
end;

procedure TWebMockAssertionTests.WithBody_GivenRegEx_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Put('/').WithBody(TRegEx.Create('.+')));
end;

procedure TWebMockAssertionTests.WithBody_GivenRegEx_SetsMatcherValue;
var
  LPattern: TRegEx;
begin
  LPattern := TRegEx.Create('.+');

  Assertion.Put('/').WithBody(LPattern);

  Assert.AreEqual(
    LPattern,
    (Assertion.Matcher.Body as TWebMockStringRegExMatcher).RegEx
  );
end;

procedure TWebMockAssertionTests.WithBody_GivenString_SetsMatcherValue;
var
  LBody: string;
begin
  LBody := 'OK';

  Assertion.Post('/').WithBody(LBody);

  Assert.AreEqual(
    LBody,
    (Assertion.Matcher.Body as TWebMockStringWildcardMatcher).Value
  );
end;

procedure TWebMockAssertionTests.WithHeaders_Always_ReturnsSelf;
var
  LHeaders: TStringList;
begin
  LHeaders := TStringList.Create;

  Assert.AreSame(Assertion, Assertion.Get('/').WithHeaders(LHeaders));

  LHeaders.Free;
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
      (Assertion.Matcher.Headers[LHeaderName] as TWebMockStringWildcardMatcher).Value
    );
  end;

  LHeaders.Free;
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
  LMatcher := Assertion.Matcher.Headers[LHeaderName];
  Assertion.WithHeader(LHeaderName, LHeaderValue2);

  Assert.AreNotSame(LMatcher, Assertion.Matcher.Headers[LHeaderName]);
end;

procedure TWebMockAssertionTests.WithHeader_GivenRegEx_ReturnsSelf;
begin
  Assert.AreSame(
    Assertion,
    Assertion.Get('/').WithHeader('Header', TRegEx.Create(''))
  );
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
    (Assertion.Matcher.Headers[LHeaderName] as TWebMockStringRegExMatcher).RegEx
  );
end;

procedure TWebMockAssertionTests.WithHeader_GivenString_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Get('/').WithHeader('Header', 'Value'));
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
    (Assertion.Matcher.Headers[LHeaderName] as TWebMockStringWildcardMatcher).Value
  );
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
    (Assertion.Matcher.QueryParams[LParamName] as TWebMockStringWildcardMatcher).Value
  );
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
    (Assertion.Matcher.QueryParams[LParamName] as TWebMockStringRegExMatcher).RegEx
  );
end;

procedure TWebMockAssertionTests.WithQueryParam_GivenNameAndValue_ReturnsSelf;
begin
  Assert.AreSame(Assertion, Assertion.Get('/').WithQueryParam('ParamName', 'Value'));
end;

procedure TWebMockAssertionTests.WasNotRequested_MatchingHistory_RaisesFailingException;
var
  LRequestInfo: TMockIdHTTPRequestInfo;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/');
  History.Add(TWebMockHTTPRequest.Create(LRequestInfo));

  Assert.WillRaise(
    procedure
    begin
      Assertion.Request('GET', '/').WasNotRequested;
    end,
    ETestFailure
  );

  LRequestInfo.Free;
end;

procedure TWebMockAssertionTests.WasNotRequested_NotMatchingHistory_RaisesPassingException;
var
  LRequestInfo: TMockIdHTTPRequestInfo;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/');
  History.Add(TWebMockHTTPRequest.Create(LRequestInfo));

  Assert.WillRaise(
    procedure
    begin
      Assertion.Request('DELETE', '/').WasNotRequested;
    end,
    ETestPass
  );

  LRequestInfo.Free;
end;

procedure TWebMockAssertionTests.WasRequested_MatchingHistory_RaisesPassingException;
var
  LRequestInfo: TMockIdHTTPRequestInfo;
begin
  LRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/');
  History.Add(TWebMockHTTPRequest.Create(LRequestInfo));

  Assert.WillRaise(
    procedure
    begin
      Assertion.Request('GET', '/').WasRequested;
    end,
    ETestPass
  );

  LRequestInfo.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockAssertionTests);
end.
