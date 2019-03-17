unit Delphi.WebMock.RequestStub.Tests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock.RequestStub;

type

  [TestFixture]
  TWebMockRequestStubTests = class(TObject)
  private
    StubbedRequest: IWebMockRequestStub;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  end;

implementation

{ TWebMockRequestStubTests }

procedure TWebMockRequestStubTests.Setup;
begin
  StubbedRequest := TWebMockRequestStub.Create;
end;

procedure TWebMockRequestStubTests.TearDown;
begin
  StubbedRequest := nil;
end;

end.
