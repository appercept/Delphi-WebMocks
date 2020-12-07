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

unit WebMock.Assertions.Tests;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  WebMock;

type
  [TestFixture]
  TWebMockAssertionsTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure WasRequested_WithStringURIMatchingRequest_Passes;
    [Test]
    procedure WasRequested_WithStringURINotMatchingRequest_Fails;
    [Test]
    procedure WasRequested_WithRegExURIMatchingRequest_Passes;
    [Test]
    procedure WasRequested_WithRegExURINotMatchingRequest_Fails;
    [Test]
    procedure WasRequestedWithBodyString_MatchingRequestBody_Passes;
    [Test]
    procedure WasRequestedWithBodyString_NotMatchingRequestBody_Fails;
    [Test]
    procedure WasRequestedWithBodyRegEx_MatchingRequestBody_Passes;
    [Test]
    procedure WasRequestedWithBodyRegEx_NotMatchingRequestBody_Fails;
    [Test]
    procedure WasRequestedWithHeaderString_MatchingRequest_Passes;
    [Test]
    procedure WasRequestedWithHeaderString_NotMatchingRequest_Fails;
    [Test]
    procedure WasRequestedWithHeaderRegEx_MatchingRequest_Passes;
    [Test]
    procedure WasRequestedWithHeaderRegEx_NotMatchingRequest_Fails;
    [Test]
    procedure WasRequestedWithHeadersStrings_MatchingRequest_Passes;
    [Test]
    procedure WasRequestedWithHeadersStrings_NotMatchingRequest_Fails;
    [Test]
    procedure WasRequestedWithQueryParam_MatchingRequest_Passes;
    [Test]
    procedure WasRequestedWithQueryParam_NotMatchingRequest_Fails;
    [Test]
    procedure DeleteWasRequested_MatchingRequest_Passes;
    [Test]
    procedure DeleteWasRequested_NotMatchingRequest_Fails;
    [Test]
    procedure GetWasRequested_MatchingRequest_Passes;
    [Test]
    procedure GetWasRequested_NotMatchingRequest_Fails;
    [Test]
    procedure PatchWasRequested_MatchingRequest_Passes;
    [Test]
    procedure PatchWasRequested_NotMatchingRequest_Fails;
    [Test]
    procedure PostWasRequested_MatchingRequest_Passes;
    [Test]
    procedure PostWasRequested_NotMatchingRequest_Fails;
    [Test]
    procedure PutWasRequested_MatchingRequest_Passes;
    [Test]
    procedure PutWasRequested_NotMatchingRequest_Fails;
    [Test]
    procedure WasNotRequested_NotMatchingRequest_Passes;
    [Test]
    procedure WasNotRequested_MatchingRequest_Fails;
  end;

implementation

{ TWebMockAssertionsTests }

uses
  DUnitX.Exceptions,
  System.Net.URLClient, System.RegularExpressions,
  TestHelpers,
  WebMock.Assertion;

procedure TWebMockAssertionsTests.DeleteWasRequested_MatchingRequest_Passes;
begin
  WebClient.Delete(WebMock.URLFor('/'));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Delete('/').WasRequested;
    end,
    ETestPass
  );
end;

procedure TWebMockAssertionsTests.DeleteWasRequested_NotMatchingRequest_Fails;
begin
  WebClient.Delete(WebMock.URLFor('/'));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Delete('/resource').WasRequested;
    end,
    ETestFailure
  );
end;

procedure TWebMockAssertionsTests.GetWasRequested_MatchingRequest_Passes;
begin
  WebClient.Get(WebMock.URLFor('/'));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Get('/').WasRequested;
    end,
    ETestPass
  );
end;

procedure TWebMockAssertionsTests.GetWasRequested_NotMatchingRequest_Fails;
begin
  WebClient.Get(WebMock.URLFor('/'));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Get('/resource').WasRequested;
    end,
    ETestFailure
  );
end;

procedure TWebMockAssertionsTests.WasNotRequested_MatchingRequest_Fails;
begin
  WebClient.Get(WebMock.URLFor('/'));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Request('GET', '/').WasNotRequested;
    end,
    ETestFailure
  );
end;

procedure TWebMockAssertionsTests.WasNotRequested_NotMatchingRequest_Passes;
begin
  WebClient.Get(WebMock.URLFor('/'));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Request('GET', '/resource').WasNotRequested;
    end,
    ETestPass
  );
end;

procedure TWebMockAssertionsTests.PatchWasRequested_MatchingRequest_Passes;
begin
  WebClient.Patch(WebMock.URLFor('/'));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Patch('/').WasRequested;
    end,
    ETestPass
  );
end;

procedure TWebMockAssertionsTests.PatchWasRequested_NotMatchingRequest_Fails;
begin
  WebClient.Patch(WebMock.URLFor('/'));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Patch('/resource').WasRequested;
    end,
    ETestFailure
  );
end;

procedure TWebMockAssertionsTests.PostWasRequested_MatchingRequest_Passes;
begin
  WebClient.Post(WebMock.URLFor('/'), TStringStream.Create(''));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Post('/').WasRequested;
    end,
    ETestPass
  );
end;

procedure TWebMockAssertionsTests.PostWasRequested_NotMatchingRequest_Fails;
begin
  WebClient.Post(WebMock.URLFor('/'), TStringStream.Create(''));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Post('/resource').WasRequested;
    end,
    ETestFailure
  );
end;

procedure TWebMockAssertionsTests.PutWasRequested_MatchingRequest_Passes;
begin
  WebClient.Put(WebMock.URLFor('/'));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Put('/').WasRequested;
    end,
    ETestPass
  );
end;

procedure TWebMockAssertionsTests.PutWasRequested_NotMatchingRequest_Fails;
begin
  WebClient.Put(WebMock.URLFor('/'));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Put('/resource').WasRequested;
    end,
    ETestFailure
  );
end;

procedure TWebMockAssertionsTests.WasRequestedWithBodyRegEx_MatchingRequestBody_Passes;
begin
  WebClient.Post(WebMock.URLFor('/'), TStringStream.Create('HELLO'));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Post('/').WithBody(TRegEx.Create('ELLO')).WasRequested;
    end,
    ETestPass
  );
end;

procedure TWebMockAssertionsTests.WasRequestedWithBodyRegEx_NotMatchingRequestBody_Fails;
begin
  WebClient.Post(WebMock.URLFor('/'), TStringStream.Create('HELLO'));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Post('/').WithBody(TRegEx.Create('BELL')).WasRequested;
    end,
    ETestFailure
  );
end;

procedure TWebMockAssertionsTests.WasRequestedWithBodyString_MatchingRequestBody_Passes;
var
  LContent: string;
begin
  LContent := 'OK';
  WebClient.Post(WebMock.URLFor('/'), TStringStream.Create(LContent));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Post('/').WithBody(LContent).WasRequested;
    end,
    ETestPass
  );
end;

procedure TWebMockAssertionsTests.WasRequestedWithBodyString_NotMatchingRequestBody_Fails;
begin
  WebClient.Post(WebMock.URLFor('/'), TStringStream.Create('HELLO'));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Post('/').WithBody('GOODBYE').WasRequested;
    end,
    ETestFailure
  );
end;

procedure TWebMockAssertionsTests.WasRequestedWithHeaderRegEx_MatchingRequest_Passes;
var
  LHeaderName: string;
begin
  LHeaderName := 'Header-1';
  WebClient.Get(
    WebMock.URLFor('/'),
    nil,
    TNetHeaders.Create(
      TNetHeader.Create(LHeaderName, 'Value-1')
    )
  );

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert
        .Get('/')
        .WithHeader(LHeaderName, TRegEx.Create('Value-\d+'))
        .WasRequested;
    end,
    ETestPass
  );
end;

procedure TWebMockAssertionsTests.WasRequestedWithHeaderRegEx_NotMatchingRequest_Fails;
var
  LHeaderName: string;
begin
  LHeaderName := 'Header-1';
  WebClient.Get(
    WebMock.URLFor('/'),
    nil,
    TNetHeaders.Create(
      TNetHeader.Create(LHeaderName, 'Value-A')
    )
  );

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert
        .Get('/')
        .WithHeader(LHeaderName, TRegEx.Create('Value-\d+'))
        .WasRequested;
    end,
    ETestFailure
  );
end;

procedure TWebMockAssertionsTests.WasRequestedWithHeadersStrings_MatchingRequest_Passes;
var
  LHeaders: TStringList;
  LHeaderName, LHeaderValue: string;
begin
  LHeaderName := 'Header-1';
  LHeaderValue := 'Value-1';
  LHeaders := TStringList.Create;
  LHeaders.Values[LHeaderName] := LHeaderValue;
  WebClient.Get(
    WebMock.URLFor('/'),
    nil,
    TNetHeaders.Create(
      TNetHeader.Create(LHeaderName, LHeaderValue)
    )
  );

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Get('/').WithHeaders(LHeaders).WasRequested;
    end,
    ETestPass
  );
end;

procedure TWebMockAssertionsTests.WasRequestedWithHeadersStrings_NotMatchingRequest_Fails;
var
  LHeaders: TStringList;
  LHeaderName, LHeaderValue: string;
begin
  LHeaderName := 'Header-1';
  LHeaderValue := 'Value-1';
  LHeaders := TStringList.Create;
  LHeaders.Values[LHeaderName] := LHeaderValue;
  WebClient.Get(
    WebMock.URLFor('/'),
    nil,
    TNetHeaders.Create(
      TNetHeader.Create(LHeaderName, 'Value-2')
    )
  );

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Get('/').WithHeaders(LHeaders).WasRequested;
    end,
    ETestFailure
  );
end;

procedure TWebMockAssertionsTests.WasRequestedWithHeaderString_MatchingRequest_Passes;
var
  LHeaderName, LHeaderValue: string;
begin
  LHeaderName := 'Header-1';
  LHeaderValue := 'Value-1';
  WebClient.Get(
    WebMock.URLFor('/'),
    nil,
    TNetHeaders.Create(
      TNetHeader.Create(LHeaderName, LHeaderValue)
    )
  );

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Get('/').WithHeader(LHeaderName, LHeaderValue).WasRequested;
    end,
    ETestPass
  );
end;

procedure TWebMockAssertionsTests.WasRequestedWithHeaderString_NotMatchingRequest_Fails;
var
  LHeaderName: string;
begin
  LHeaderName := 'Header-1';
  WebClient.Get(
    WebMock.URLFor('/'),
    nil,
    TNetHeaders.Create(
      TNetHeader.Create(LHeaderName, 'Value-1')
    )
  );

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Get('/').WithHeader(LHeaderName, 'Value-2').WasRequested;
    end,
    ETestFailure
  );
end;

procedure TWebMockAssertionsTests.WasRequestedWithQueryParam_MatchingRequest_Passes;
var
  LParamName, LParamValue: string;
begin
  LParamName := 'Param1';
  LParamValue := 'Value1';
  WebClient.Get(WebMock.URLFor('/') + Format('?%s=%s', [LParamName, LParamValue]));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Get('/').WithQueryParam(LParamName, LParamValue).WasRequested;
    end,
    ETestPass
  );
end;

procedure TWebMockAssertionsTests.WasRequestedWithQueryParam_NotMatchingRequest_Fails;
var
  LParamName, LParamValue: string;
begin
  LParamName := 'Param1';
  LParamValue := 'Value1';
  WebClient.Get(WebMock.URLFor('/'));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Get('/').WithQueryParam(LParamName, LParamValue).WasRequested;
    end,
    ETestFailure
  );
end;

procedure TWebMockAssertionsTests.WasRequested_WithRegExURIMatchingRequest_Passes;
begin
  WebClient.Get(WebMock.URLFor('/resource/1'));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Request('GET', TRegEx.Create('/resource/\d+')).WasRequested;
    end,
    ETestPass
  );
end;

procedure TWebMockAssertionsTests.WasRequested_WithRegExURINotMatchingRequest_Fails;
begin
  WebClient.Get(WebMock.URLFor('/resource/a'));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Request('GET', TRegEx.Create('/resource/\d+')).WasRequested;
    end,
    ETestFailure
  );
end;

procedure TWebMockAssertionsTests.WasRequested_WithStringURIMatchingRequest_Passes;
begin
  WebClient.Get(WebMock.URLFor('/'));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Request('GET', '/').WasRequested;
    end,
    ETestPass
  );
end;

procedure TWebMockAssertionsTests.WasRequested_WithStringURINotMatchingRequest_Fails;
begin
  WebClient.Get(WebMock.URLFor('/'));

  Assert.WillRaise(
    procedure
    begin
      WebMock.Assert.Request('GET', '/resource').WasRequested;
    end,
    ETestFailure
  );
end;

procedure TWebMockAssertionsTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockAssertionsTests.TearDown;
begin
  WebMock.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockAssertionsTests);
end.
