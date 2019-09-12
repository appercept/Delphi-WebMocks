unit Delphi.WebMock.MatchingContent.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock,
  System.Classes, System.SysUtils;

type

  [TestFixture]
  TWebMockMatchingContentTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Request_WithStringMatchingContentExactly_RespondsOK;
    [Test]
    procedure Request_WithStringNotMatchingContent_RespondsNotImplemented;
    [Test]
    procedure Request_WithPatternMatchingContent_RespondsOK;
    [Test]
    procedure Request_WithPatternNotMatchingContent_RespondsNotImplemented;
  end;

implementation

{ TWebMockMatchingContentTests }

uses
  IdHTTP,
  TestHelpers,
  System.RegularExpressions;

procedure TWebMockMatchingContentTests.Request_WithPatternMatchingContent_RespondsOK;
var
  LContent: string;
  LResponse: TIdHTTPResponse;
begin
  LContent := 'Hello world!';

  WebMock.StubRequest('*', '*').WithContent(TRegEx.Create('Hello'));
  LResponse := WebClient.Post(WebMock.BaseURL, LContent);

  Assert.AreEqual(200, LResponse.ResponseCode);

  LResponse.Free;
end;

procedure TWebMockMatchingContentTests.Request_WithPatternNotMatchingContent_RespondsNotImplemented;
var
  LContent: string;
  LResponse: TIdHTTPResponse;
begin
  LContent := 'Hello world!';

  WebMock.StubRequest('*', '*').WithContent(TRegEx.Create('Goodbye'));
  LResponse := WebClient.Post(WebMock.BaseURL, LContent);

  Assert.AreEqual(501, LResponse.ResponseCode);

  LResponse.Free;
end;

procedure TWebMockMatchingContentTests.Request_WithStringMatchingContentExactly_RespondsOK;
var
  LContent: string;
  LResponse: TIdHTTPResponse;
begin
  LContent := 'Hello world!';

  WebMock.StubRequest('*', '*').WithContent(LContent);
  LResponse := WebClient.Post(WebMock.BaseURL, LContent);

  Assert.AreEqual(200, LResponse.ResponseCode);

  LResponse.Free;
end;

procedure TWebMockMatchingContentTests.Request_WithStringNotMatchingContent_RespondsNotImplemented;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.StubRequest('*', '*').WithContent('Hello!');
  LResponse := WebClient.Post(WebMock.BaseURL, 'Goodbye!');

  Assert.AreEqual(501, LResponse.ResponseCode);

  LResponse.Free;
end;

procedure TWebMockMatchingContentTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockMatchingContentTests.TearDown;
begin
  WebMock.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockMatchingContentTests);
end.
