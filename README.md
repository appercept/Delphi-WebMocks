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
#### Request matching by HTTP method and document path
The simplest form of request matching and starting point for all request stubs
is by HTTP method and document path. For example stubbing the HTTP verb `GET` to
the server root `/` is achieved by:
```Delphi
WebMock.StubRequest('GET', '/');
```

The use of a single wild-card character `*` can be used to match _any_ request.
For example, to match all `POST` requests regardless of document path you can
use:
```Delphi
WebMock.StubRequest('POST', '*');
```

Similarly, to match any HTTP method for a given path you can use:
```Delphi
WebMock.StubRequest('*', '/path');
```

It is perfectly possible to have a catch-all of `*` and `*` for both HTTP method
and document path.

#### Request matching by header value
HTTP request headers can be matched like:
```Delphi
WebMock.StubRequest('*', '*').WithHeader('Header-Name', 'Header-Value');
```

Matching multiple headers can be achieved in 2 ways. The first is to simply
chain `WithHeader` calls e.g.:
```Delphi
WebMock.StubRequest('*', '*')
  .WithHeader('Header-1', 'Header-Value-1')
  .WithHeader('Header-2', 'Header-Value-2');
```

Alternatively, `WithHeaders` accepts a `TStringList` of key-value pairs e.g.:
```Delphi
var
  Headers: TStringList;

begin
  Headers := TStringList.Create;
  Headers.Values['Header-1'] := 'Value-1';
  Headers.Values['Header-2'] := 'Value-2';

  WebMock.StubRequest('*', '*').WithHeaders(Headers);
end;
```

#### Matching request document path or headers by regular-expression
Matching a request by regular-expression can be useful for stubbing dynamic
routes for a ReSTful resource involving a resource name and an unknown resource
ID such as `/resource/999`. Such a request could be stubbed by:
```Delphi
WebMock.StubRequest('GET', TRegEx.Create('^/resource/\d+$'));
```

Matching headers can similarly by achieved by:
```Delphi
WebMock.StubRequest('*', '*')
  .WithHeader('Accept', TRegEx.Create('video/.+'));
```

NOTE: Be sure to add `System.RegularExpressions` to your uses clause.

#### Stubbed Response Codes
By default a response status will be `200 OK` for a stubbed request. If a
request is made to `TWebMock` without a registered stub it will respond
`501 Not Implemented`. To specify the response status use `ToReturn`.
```Delphi
WebMock.StubRequest('GET', '/').ToReturn(TWebMockResponseStatus.NotFound);
```

#### Stubbed Response Headers
Headers can be added to a response stub like:
```Delphi
WebMock.StubRequest('*', '*')
  .AndReturn.WithHeader('Header1', 'Value1');
```

As with request header matching multiple headers can be specified either through
method chaining or by using the `WithHeaders` method.
```Delphi
  WebMock.StubRequest('*', '*')
    .AndReturn.WithHeader('Header1', 'Value1')
    .AndReturn.WithHeader('Header2', 'Value2');

/* or */

var
  Headers: TStringList;
begin
  Headers := TStringList.Create;
  Headers.Values['Header1'] := 'Value1';
  Headers.Values['Header2'] := 'Value2';

  WebMock.StubRequest('*', '*')
    .AndReturn.WithHeaders(Headers);
end;
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
    - [x] ~~Regular Expressions~~
    - [x] ~~Simple wild-card `*`~~
  - [x] Headers by:
    - [x] ~~Exact Matching~~
    - [x] ~~Regular Expressions~~
  - [ ] Content by:
    - [ ] Exact Matching
    - [ ] Regular Expressions
* [x] ~~Static Response Stubs~~
  - [x] ~~Status Codes~~
  - [x] ~~Content~~
    - [x] ~~Simple Text~~
    - [x] ~~Fixture Files~~
  - [x] ~~Headers~~
* [ ] Request History
* [ ] Assertions/Expectations
* [ ] Dynamic Response Stubs
* [ ] Dynamic Port Binding

## License
Copyright ©2019 Richard Hatherall <richard@appercept.com>

See [LICENSE](LICENSE) for details.
