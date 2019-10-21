unit Delphi.WebMock.MatchingBody.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock,
  System.Classes, System.SysUtils;

type

  [TestFixture]
  TWebMockMatchingBodyTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Request_WithStringMatchingBodyExactly_RespondsOK;
    [Test]
    procedure Request_WithStringNotMatchingBody_RespondsNotImplemented;
    [Test]
    procedure Request_WithPatternMatchingBody_RespondsOK;
    [Test]
    procedure Request_WithPatternNotMatchingBody_RespondsNotImplemented;
  end;

implementation

{ TWebMockMatchingBodyTests }

uses
  System.Net.HttpClient, System.RegularExpressions,
  TestHelpers;

procedure TWebMockMatchingBodyTests.Request_WithPatternMatchingBody_RespondsOK;
var
  LContent: string;
  LResponse: IHTTPResponse;
begin
  LContent := 'Hello world!';

  WebMock.StubRequest('*', '*').WithBody(TRegEx.Create('Hello'));
  LResponse := WebClient.Post(WebMock.BaseURL, TStringStream.Create(LContent));

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TWebMockMatchingBodyTests.Request_WithPatternNotMatchingBody_RespondsNotImplemented;
var
  LContent: string;
  LResponse: IHTTPResponse;
begin
  LContent := 'Hello world!';

  WebMock.StubRequest('*', '*').WithBody(TRegEx.Create('Goodbye'));
  LResponse := WebClient.Post(WebMock.BaseURL, TStringStream.Create(LContent));

  Assert.AreEqual(501, LResponse.StatusCode);
end;

procedure TWebMockMatchingBodyTests.Request_WithStringMatchingBodyExactly_RespondsOK;
var
  LContent: string;
  LResponse: IHTTPResponse;
begin
  LContent := 'Hello world!';

  WebMock.StubRequest('*', '*').WithBody(LContent);
  LResponse := WebClient.Post(WebMock.BaseURL, TStringStream.Create(LContent));

  Assert.AreEqual(200, LResponse.StatusCode);
end;

procedure TWebMockMatchingBodyTests.Request_WithStringNotMatchingBody_RespondsNotImplemented;
var
  LResponse: IHTTPResponse;
begin
  WebMock.StubRequest('*', '*').WithBody('Hello!');
  LResponse := WebClient.Post(WebMock.BaseURL, TStringStream.Create('Goodbye!'));

  Assert.AreEqual(501, LResponse.StatusCode);
end;

procedure TWebMockMatchingBodyTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockMatchingBodyTests.TearDown;
begin
  WebMock.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockMatchingBodyTests);
end.
