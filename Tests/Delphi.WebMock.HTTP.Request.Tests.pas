unit Delphi.WebMock.HTTP.Request.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock.HTTP.Request;

type
  [TestFixture]
  TWebMockHTTPRequestTests = class(TObject)
  private
    Request: TWebMockHTTPRequest;
  public
    [Test]
    procedure Create_WhenGivenIndyRequestInfo_Succeeds;
    [Test]
    procedure StartLine_WhenInitializedWithIndyRequestInfo_ReturnsRawHTTPCommand;
    [Test]
    procedure RequestLine_WhenInitializedWithIndyRequestInfo_ReturnsRawHTTPCommand;
    [Test]
    procedure RequestURI_WhenInitializedWithIndyRequestInfo_ReturnsURI;
    [Test]
    procedure Method_WhenInitializedWithIndyRequestInfo_ReturnsCommand;
    [Test]
    procedure HTTPVersion_WhenInitializedWithIndyRequestInfo_ReturnsVersion;
    [Test]
    procedure Headers_WhenInitializedWithIndyRequestInfo_ReturnsListMatchingRawHeaders;
    [Test]
    procedure Body_WhenInitializedWithIndyRequestInfo_ReturnsStreamWithMatchingContents;
  end;

implementation

{ TWebMockHTTPRequestTests }

uses
  IdCustomHTTPServer,
  Mock.Indy.HTTPRequestInfo,
  System.Classes;

procedure TWebMockHTTPRequestTests.Body_WhenInitializedWithIndyRequestInfo_ReturnsStreamWithMatchingContents;
var
  LIndyRequestInfo: TMockIdHTTPRequestInfo;
begin
  LIndyRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/');
  LIndyRequestInfo.PostStream := TStringStream.Create('OK');

  Request := TWebMockHTTPRequest.Create(LIndyRequestInfo);

  Assert.AreEqual(LIndyRequestInfo.PostStream, Request.Body);

  Request.Free;
  LIndyRequestInfo.Free;
end;

procedure TWebMockHTTPRequestTests.Create_WhenGivenIndyRequestInfo_Succeeds;
var
  LIndyRequestInfo: TMockIdHTTPRequestInfo;
begin
  LIndyRequestInfo := TMockIdHTTPRequestInfo.Mock;

  Assert.WillNotRaiseAny(
    procedure
    begin
      Request := TWebMockHTTPRequest.Create(LIndyRequestInfo);
    end);

  Request.Free;
  LIndyRequestInfo.Free;
end;

procedure TWebMockHTTPRequestTests.Headers_WhenInitializedWithIndyRequestInfo_ReturnsListMatchingRawHeaders;
var
  LExpectedHeaders: TStringList;
  LIndyRequestInfo: TMockIdHTTPRequestInfo;
begin
  LExpectedHeaders := TStringList.Create;
  LExpectedHeaders.AddPair('Header-1', 'Value-1');
  LExpectedHeaders.AddPair('Header-2', 'Value-2');
  LIndyRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/');
  LIndyRequestInfo.RawHeaders.AddStrings(LExpectedHeaders);

  Request := TWebMockHTTPRequest.Create(LIndyRequestInfo);

  Assert.AreEqual(LExpectedHeaders, Request.Headers);

  Request.Free;
  LIndyRequestInfo.Free;
  LExpectedHeaders.Free;
end;

procedure TWebMockHTTPRequestTests.HTTPVersion_WhenInitializedWithIndyRequestInfo_ReturnsVersion;
var
  LIndyRequestInfo: TMockIdHTTPRequestInfo;
begin
  LIndyRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/');

  Request := TWebMockHTTPRequest.Create(LIndyRequestInfo);

  Assert.AreEqual(LIndyRequestInfo.Version, Request.HTTPVersion);

  Request.Free;
  LIndyRequestInfo.Free;
end;

procedure TWebMockHTTPRequestTests.Method_WhenInitializedWithIndyRequestInfo_ReturnsCommand;
var
  LIndyRequestInfo: TMockIdHTTPRequestInfo;
begin
  LIndyRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/');

  Request := TWebMockHTTPRequest.Create(LIndyRequestInfo);

  Assert.AreEqual(LIndyRequestInfo.Command, Request.Method);

  Request.Free;
  LIndyRequestInfo.Free;
end;

procedure TWebMockHTTPRequestTests.RequestLine_WhenInitializedWithIndyRequestInfo_ReturnsRawHTTPCommand;
var
  LIndyRequestInfo: TMockIdHTTPRequestInfo;
begin
  LIndyRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/');

  Request := TWebMockHTTPRequest.Create(LIndyRequestInfo);

  Assert.AreEqual(LIndyRequestInfo.RawHTTPCommand, Request.RequestLine);

  Request.Free;
  LIndyRequestInfo.Free;
end;

procedure TWebMockHTTPRequestTests.RequestURI_WhenInitializedWithIndyRequestInfo_ReturnsURI;
var
  LIndyRequestInfo: TMockIdHTTPRequestInfo;
begin
  LIndyRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/');

  Request := TWebMockHTTPRequest.Create(LIndyRequestInfo);

  Assert.AreEqual(LIndyRequestInfo.URI, Request.RequestURI);

  Request.Free;
  LIndyRequestInfo.Free;
end;

procedure TWebMockHTTPRequestTests.StartLine_WhenInitializedWithIndyRequestInfo_ReturnsRawHTTPCommand;
var
  LIndyRequestInfo: TMockIdHTTPRequestInfo;
begin
  LIndyRequestInfo := TMockIdHTTPRequestInfo.Mock('GET', '/');

  Request := TWebMockHTTPRequest.Create(LIndyRequestInfo);

  Assert.AreEqual(LIndyRequestInfo.RawHTTPCommand, Request.StartLine);

  Request.Free;
  LIndyRequestInfo.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockHTTPRequestTests);
end.
