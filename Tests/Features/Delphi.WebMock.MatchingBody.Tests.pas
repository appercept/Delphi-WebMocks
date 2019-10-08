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
  IdHTTP,
  TestHelpers,
  System.RegularExpressions;

procedure TWebMockMatchingBodyTests.Request_WithPatternMatchingBody_RespondsOK;
var
  LContent: string;
  LResponse: TIdHTTPResponse;
begin
  LContent := 'Hello world!';

  WebMock.StubRequest('*', '*').WithBody(TRegEx.Create('Hello'));
  LResponse := WebClient.Post(WebMock.BaseURL, LContent);

  Assert.AreEqual(200, LResponse.ResponseCode);

  LResponse.Free;
end;

procedure TWebMockMatchingBodyTests.Request_WithPatternNotMatchingBody_RespondsNotImplemented;
var
  LContent: string;
  LResponse: TIdHTTPResponse;
begin
  LContent := 'Hello world!';

  WebMock.StubRequest('*', '*').WithBody(TRegEx.Create('Goodbye'));
  LResponse := WebClient.Post(WebMock.BaseURL, LContent);

  Assert.AreEqual(501, LResponse.ResponseCode);

  LResponse.Free;
end;

procedure TWebMockMatchingBodyTests.Request_WithStringMatchingBodyExactly_RespondsOK;
var
  LContent: string;
  LResponse: TIdHTTPResponse;
begin
  LContent := 'Hello world!';

  WebMock.StubRequest('*', '*').WithBody(LContent);
  LResponse := WebClient.Post(WebMock.BaseURL, LContent);

  Assert.AreEqual(200, LResponse.ResponseCode);

  LResponse.Free;
end;

procedure TWebMockMatchingBodyTests.Request_WithStringNotMatchingBody_RespondsNotImplemented;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest('*', '*').WithBody('Hello!');
  LResponse := WebClient.Post(WebMock.BaseURL, 'Goodbye!');

  Assert.AreEqual(501, LResponse.ResponseCode);

  LResponse.Free;
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
