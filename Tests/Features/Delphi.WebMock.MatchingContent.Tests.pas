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
    procedure Request_MatchingContentExactly_RespondsOK;
    [Test]
    procedure Request_NotMatchingContent_RespondsNotImplemented;
  end;

implementation

{ TWebMockMatchingContentTests }

uses
  IdHTTP,
  TestHelpers;

procedure TWebMockMatchingContentTests.Request_MatchingContentExactly_RespondsOK;
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

procedure TWebMockMatchingContentTests.Request_NotMatchingContent_RespondsNotImplemented;
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
