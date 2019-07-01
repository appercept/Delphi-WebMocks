# Delphi-WebMocks
Library for stubbing and setting expectations on HTTP requests in Delphi with [DUnitX](https://github.com/VSoftTechnologies/DUnitX).

Delphi WebMocks

## Setup
In your test unit file a couple of simple steps are required.
1. Add `Delphi.WebMock` to your interface `uses`.
2. In your `TestFixture` class use `Setup` and `TearDown` to create/destroy an
  instance of `TWebMock`.

### Example Unit Test with TWebMock
```Delphi
unit MyTestObjectTests;

interface

uses
  DUnitX.TestFramework,
  Delphi.WebMock,
  MyTestObjectUnit;

type
  TMyTestObjectTests = class(TObject)
  private
    WebMock: TWebMock;
    Subject: TMyTestObject;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestGet;
  end;

implementation

procedure TMyTestObjectTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TMyTestObjectTests.TearDown;
begin
  WebMock.Free;
end;

procedure TMyTestObjectTests.TestGet;
begin
  // Arrange
  // Stub the request
  WebMock.StubRequest('GET', '/endpoint');

  // Point your subject at the endpoint
  Subject := TMyTestObject.Create(WebMock.BaseURL + 'endpoint');

  // Act
  Subject.Get;

  // Assert: check your subject behaved correctly
  Assert.IsTrue(Subject.ReceivedResponse);
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObjectTests);

end.
```

By default `TWebMock` will bind to port `8080`. The port can be specified at
creation.
```Delphi
WebMock := TWebMock.Create(8088);
```

The use of `WebMock.BaseURL` property within your tests is to simplify
constructing a valid URL.

## Examples
### Stubbing
#### Stubbed Response Codes
By default a response status will be `200 OK` for a stubbed request. If a
request is made to `TWebMock` without a registered stub it will respond
`501 Not Implemented`. To specify the response status use `ToReturn`.
```Delphi
WebMock.StubRequest('GET', '/').ToReturn(TWebMockResponseStatus.NotFound);
```

#### Stubbed Response Content: String Values
By default a stubbed response returns a zero length body with content-type
`text/plain`. Simple response content that is easily represented as a `string`
can be set with `WithContent`.
```Delphi
WebMock.StubRequest('GET', '/').WithContent('Text To Return');
```

If you want to return a specific content-type it can be specified as the second
argument e.g.
```Delphi
WebMock.StubRequest('GET', '/').WithContent('{ "status": "ok" }', 'application/json');
```

#### Stubbed Response Content: Fixture Files
When stubbing responses with binary or large content it is likely easier to
provide the content as a file. This can be acheived using `WithContentFile`
which has the same signature as `WithContent` but the first argument is the
path to a file.
```Delphi
WebMock.StubRequest('GET', '/').WithContentFile('image.jpg');
```

The Delphi-WebMocks will attempt to set the content-type according to the file
extension. If the file type is unknown then the content-type will default to
`application/octet-stream`. The content-type can be overriden with the second
argument. e.g.
```Delphi
WebMock.StubRequest('GET', '/').WithContentFile('file.myext', 'application/xml');
```

**NOTE:** One "gotcha" accessing files in tests is the location of the file will
be relative to the test executable which, by default, using the Windows 32-bit
compiler will be output to the `Win32\Debug` folder. To correctly reference a
file named `Content.txt` in the project folder, the path will be
`..\..\Content.txt`.

## Planned Features
* [x] Static Request Matchers
  - [x] ~~HTTP Verbs by:~~
    - [x] ~~Exact Matching~~
    - [x] ~~Simple wild-card `*`~~
  - [x] Path by:
    - [x] ~~Exact Matching~~
    - [ ] Regular Expressions
    - [x] ~~Simple wild-card `*`~~
  - [ ] Headers by:
    - [ ] Exact Matching
    - [ ] Regular Expressions
  - [ ] Content by:
    - [ ] Exact Matching
    - [ ] Regular Expressions
* [x] Static Response Stubs
  - [x] ~~Status Codes~~
  - [x] ~~Content~~
    - [x] ~~Simple Text~~
    - [x] ~~Fixture Files~~
  - [ ] Headers
* [ ] Request History
* [ ] Assertions/Expectations
* [ ] Dynamic Response Stubs
* [ ] Dynamic Port Binding

## License
Copyright ©2019 Richard Hatherall <richard@appercept.com>

See [LICENSE](LICENSE) for details.
