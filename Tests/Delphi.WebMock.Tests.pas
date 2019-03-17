unit Delphi.WebMock.Tests;

interface
uses
  DUnitX.TestFramework,
  Delphi.WebMock;

type

  [TestFixture]
  TWebMockTests = class(TObject)
  private
    WebMock: TWebMock;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Test_Create_WithNoArguments_StartsListeningOnPort8080;
    [Test]
    procedure Test_Create_WithPort_StartsListeningOnPortPort;
    [Test]
    procedure Test_BaseURL_ByDefault_ReturnsLocalHostURLWithDefaultPort;
    [Test]
    procedure Test_BaseURL_WhenPortIsNotDefault_ReturnsLocalHostURLWithPort;
  end;

implementation

uses
  IdHTTP,
  TestHelpers;

procedure TWebMockTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TWebMockTests.TearDown;
begin
  WebMock.Free;
end;

procedure TWebMockTests.Test_BaseURL_ByDefault_ReturnsLocalHostURLWithDefaultPort;
begin
  Assert.AreEqual('http://127.0.0.1:8080/', WebMock.BaseURL);
end;

procedure TWebMockTests.Test_BaseURL_WhenPortIsNotDefault_ReturnsLocalHostURLWithPort;
begin
  WebMock.Free;
  WebMock := TWebMock.Create(8088);

  Assert.AreEqual('http://127.0.0.1:8088/', WebMock.BaseURL);
end;

procedure TWebMockTests.Test_Create_WithNoArguments_StartsListeningOnPort8080;
var
  LResponse: TIdHTTPResponse;
begin
  LResponse := Get('http://localhost:8080/');

  Assert.AreEqual('Delphi WebMocks', LResponse.Server);
end;

procedure TWebMockTests.Test_Create_WithPort_StartsListeningOnPortPort;
var
  LResponse: TIdHTTPResponse;
begin
  WebMock.Free;

  WebMock := TWebMock.Create(8088);
  LResponse := Get('http://localhost:8088/');

  Assert.AreEqual('Delphi WebMocks', LResponse.Server);
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockTests);
end.
