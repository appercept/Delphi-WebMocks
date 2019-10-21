unit Delphi.WebMock.History.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock,
  System.Classes,
  System.SysUtils;

type
  [TestFixture]
  TWebMockHistoryTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure History_AfterStubbedRequest_IncreasesCount;
    [Test]
    procedure History_AfterUnStubbedRequest_IncreasesCount;
    [Test]
    procedure History_AfterRequest_ContainsMatchingRequest;
  end;

implementation

{ TWebMockHistoryTests }

uses
  Delphi.WebMock.HTTP.Messages,
  System.Generics.Collections,
  TestHelpers;

procedure TWebMockHistoryTests.History_AfterRequest_ContainsMatchingRequest;
var
  LastRequest: IWebMockHTTPRequest;
begin
  WebClient.Get(WebMock.URLFor('resource'));

  LastRequest := WebMock.History.Last;
  Assert.AreEqual('GET', LastRequest.Method);
  Assert.AreEqual('/resource', LastRequest.RequestURI);
end;

procedure TWebMockHistoryTests.History_AfterStubbedRequest_IncreasesCount;
var
  ExpectedHistoryCount: Integer;
begin
  ExpectedHistoryCount := WebMock.History.Count + 1;
  WebMock.StubRequest('GET', '/stubbed');

  WebClient.Get(WebMock.URLFor('stubbed'));

  Assert.AreEqual(ExpectedHistoryCount, WebMock.History.Count);
end;

procedure TWebMockHistoryTests.History_AfterUnStubbedRequest_IncreasesCount;
var
  ExpectedHistoryCount: Integer;
begin
  ExpectedHistoryCount := WebMock.History.Count + 1;

  WebClient.Get(WebMock.URLFor('not-stubbed'));

  Assert.AreEqual(ExpectedHistoryCount, WebMock.History.Count);
end;

procedure TWebMockHistoryTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockHistoryTests.TearDown;
begin
  WebMock.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockHistoryTests);
end.
