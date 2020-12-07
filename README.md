![Delphi compatibility](https://img.shields.io/badge/Delphi-XE8%20or%20newer-brightgreen)
![Platform compatibility](https://img.shields.io/badge/platform-Linux64%20%7C%20macOS64%20%7C%20Win32%20%7C%20Win64-lightgrey)
![License](https://img.shields.io/github/license/appercept/Delphi-WebMocks)
![Lines of Code](https://tokei.rs/b1/github/appercept/Delphi-WebMocks)

# WebMocks ![GitHub release (latest by date)](https://img.shields.io/github/v/release/appercept/Delphi-WebMocks) ![GitHub commits since latest release (by SemVer)](https://img.shields.io/github/commits-since/appercept/Delphi-WebMocks/latest?sort=semver) ![GitHub Release Date](https://img.shields.io/github/release-date/appercept/Delphi-WebMocks)
Library for stubbing and setting expectations on HTTP requests in Delphi with
[DUnitX](https://github.com/VSoftTechnologies/DUnitX).

## Requirements
* [Delphi](https://www.embarcadero.com/products/delphi) XE8 or later*
* [DUnitX](https://github.com/VSoftTechnologies/DUnitX)
* [Indy](https://www.indyproject.org)

\* WebMocks was developed in Delphi 10.3 (Rio) and 10.4 (Sydney). WebMocks has
been reported working on 10.1 (Berlin). I'd be interested to hear from anyone
working on other versions. As WebMocks makes use of the `System.Net`
library introduced with XE8 it will not be compatible with earlier versions.

## Installation: Delphinus-Support
WebMocks should now be listed in
[Delphinus](https://github.com/Memnarch/Delphinus) package manager.

Be sure to restart Delphi after installing via Delphinus otherwise the units may
not be found in your test projects.

## Installation: Manual
1. Download and extract the latest version
   [2.0.0](https://github.com/appercept/Delphi-WebMocks/archive/2.0.0.zip).
2. In "Tools > Options" under the "Language / Delphi / Library" add the
   extracted `Source` directory to the "Library path" and "Browsing path".

## Upgrading from versions prior to 2.0.0
Version 2 has dropped the `Delphi.` namespace from all units. Any projects
upgrade to version 2 or later will need to drop the `Delphi.` prefix from any
included WebMocks units.

## Setup
In your test unit file a couple of simple steps are required.
1. Add `WebMock` to your interface `uses`.
2. In your `TestFixture` class use `Setup` and `TearDown` to create/destroy an
  instance of `TWebMock`.

### Example Unit Test with TWebMock
```Delphi
unit MyTestObjectTests;

interface

uses
  DUnitX.TestFramework,
  MyObjectUnit,
  WebMock;

type
  TMyObjectTests = class(TObject)
  private
    WebMock: TWebMock;
    Subject: TMyObject;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestGet;
  end;

implementation

procedure TMyObjectTests.Setup;
begin
  WebMock := TWebMock.Create;
end;

procedure TMyObjectTests.TearDown;
begin
  WebMock.Free;
end;

procedure TMyObjectTests.TestGet;
begin
  // Arrange
  // Stub the request
  WebMock.StubRequest('GET', '/endpoint');

  // Create your subject and point it at the endpoint
  Subject := TMyObject.Create;
  Subject.EndpointURL := WebMock.URLFor('endpoint');

  // Act
  Subject.Get;

  // Assert: check your subject behaved correctly
  Assert.IsTrue(Subject.ReceivedResponse);
end;

initialization
  TDUnitX.RegisterTestFixture(TMyObjectTests);
end.
```

By default `TWebMock` will bind to a port dynamically assigned start at `8080`.
This behaviour can be overriden by specifying a port at creation.
```Delphi
WebMock := TWebMock.Create(8088);
```

The use of `WebMock.URLFor` function within your tests is to simplify
constructing a valid URL. The `Port` property contains the current bound port
and `BaseURL` property contains a valid URL for the server root.

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
WebMock.StubRequest('*', '*').WithHeader('Name', 'Value');
```

Matching multiple headers can be achieved in 2 ways. The first is to simply
chain `WithHeader` calls e.g.:
```Delphi
WebMock.StubRequest('*', '*')
  .WithHeader('Header-1', 'Value-1')
  .WithHeader('Header-2', 'Value-2');
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

#### Request matching by header value
HTTP request can be matched by content like:
```Delphi
WebMock.StubRequest('*', '*').WithBody('String content.');
```

#### Matching request document path, headers, or content by regular-expression
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

Matching content can be performed like:
```Delphi
WebMock.StubRequest('*', '*')
  .WithBody(TRegEx.Create('Hello'));
```

NOTE: Be sure to add `System.RegularExpressions` to your uses clause.

#### Request matching by predicate function
If matching logic is required to be more complex than the simple matching, a
predicate function can be provided in the test to allow custom inspection/logic
for matching a request. The anonymous predicate function will receive an
`IWebMockHTTPRequest` object for inspecting the request. If the predicate
function returns `True` then the stub will be regarded as a match, if returning
`False` it will not be matched.

Example stub with predicate function:
```Delphi
WebMock.StubRequest(
  function(ARequest: IWebMockHTTPRequest): Boolean
  begin
    Result := True; // Return False to ignore request.
  end
);
```

#### Stubbed Response Codes
By default a response status will be `200 OK` for a stubbed request. If a
request is made to `TWebMock` without a registered stub it will respond
`501 Not Implemented`. To specify the response status use `ToRespond`.
```Delphi
WebMock.StubRequest('GET', '/').ToRespond(TWebMockResponseStatus.NotFound);
```

#### Stubbed Response Headers
Headers can be added to a response stub like:
```Delphi
WebMock.StubRequest('*', '*')
  .ToRespond.WithHeader('Header-1', 'Value-1');
```

As with request header matching multiple headers can be specified either through
method chaining or by using the `WithHeaders` method.
```Delphi
  WebMock.StubRequest('*', '*').ToRespond
    .WithHeader('Header-1', 'Value-1')
    .WithHeader('Header-2', 'Value-2');

/* or */

var
  Headers: TStringList;
begin
  Headers := TStringList.Create;
  Headers.Values['Header-1'] := 'Value-1';
  Headers.Values['Header-2'] := 'Value-2';

  WebMock.StubRequest('*', '*')
    .ToRespond.WithHeaders(Headers);
end;
```

#### Stubbed Response Content: String Values
By default a stubbed response returns a zero length body with content-type
`text/plain`. Simple response content that is easily represented as a `string`
can be set with `WithBody`.
```Delphi
WebMock.StubRequest('GET', '/')
  .ToRespond.WithBody('Text To Return');
```

If you want to return a specific content-type it can be specified as the second
argument e.g.
```Delphi
WebMock.StubRequest('GET', '/')
  .ToRespond.WithBody('{ "status": "ok" }', 'application/json');
```

#### Stubbed Response Content: Fixture Files
When stubbing responses with binary or large content it is likely easier to
provide the content as a file. This can be acheived using `WithBodyFile`
which has the same signature as `WithBody` but the first argument is the
path to a file.
```Delphi
WebMock.StubRequest('GET', '/').WithBodyFile('image.jpg');
```

The Delphi-WebMocks will attempt to set the content-type according to the file
extension. If the file type is unknown then the content-type will default to
`application/octet-stream`. The content-type can be overriden with the second
argument. e.g.
```Delphi
WebMock.StubRequest('GET', '/').WithBodyFile('file.myext', 'application/xml');
```

**NOTE:** One "gotcha" accessing files in tests is the location of the file will
be relative to the test executable which, by default, using the Windows 32-bit
compiler will be output to the `Win32\Debug` folder. To correctly reference a
file named `Content.txt` in the project folder, the path will be
`..\..\Content.txt`.

#### Dynamic Responses
Sometimes it is useful to dynamically respond to a request. For example:
```Delphi
WebMock.StubRequest('*', '*')
  .ToRespondWith(
    procedure (const ARequest: IWebMockHTTPRequest;
               const AResponse: IWebMockResponseBuilder)
    begin
      AReponse
        .WithStatus(202)
        .WithHeader('header-1', 'a-value')
        .WithBody('Some content...');
    end
  );
```

This enables testing of features that require deeper inspection of the request
or to reflect values from the request back in the response. For example:
```Delphi
WebMock.StubRequest('GET', '/echo_header')
  .ToRespondWith(
    procedure (const ARequest: IWebMockHTTPRequest;
               const AResponse: IWebMockHTTPResponseBuilder)
    begin
      AResponse.WithHeader('my-header', ARequest.Headers.Values['my-header']);
    end
  );
```

It can also be useful for simulating failures for a number of attempts before
returning a success. For example:
```Delphi
var LRequestCount := 0;
WebMock.StubRequest('GET', '/busy_endpoint')
  .ToRespondWith(
    procedure (const ARequest: IWebMockHTTPRequest;
               const AResponse: IWebMockHTTPResponseBuilder)
    begin
      Inc(LRequestCount);
      if LRequestCount < 3 then
        AResponse.WithStatus(408, 'Request Timeout')
      else
        AResponse.WithStatus(200, 'OK');
    end
  );
```

### Resetting Registered Stubs
If you need to clear the current registered stubs you can call
`ResetStubRegistry` or `Reset` on the instance of TWebMock. The general `Reset`
method will return the TWebMock instance to a blank state including emptying the
stub registry. The more specific `ResetStubRegistry` will as suggested clear
only the stub registry.

## Request History
Each and every request made of the TWebMock instance is recorded in the
`History` property. History entries contain all the key web request information:
Method; RequestURI; Headers; and Body.

It is possible to write assertions based upon the request history e.g.:
```Delphi
WebClient.Get(WebMock.URLFor('document'));

Assert.AreEqual('GET', WebMock.History.Last.Method);
Assert.AreEqual('/document', WebMock.History.Last.RequestURI);
```

**NOTE:** Should you find yourself writing assertions in this manor you should
take a look at [Request Assertions](#request-assertions) which provides a more
concise way of defining these assertions.

### Resetting Request History
If you need to clear request history you can call `ResetHistory` or `Reset` on
the instance of TWebMock. The general `Reset` method will return the TWebMock
instance to a blank state including emptying the history. The more specific
`ResetHistory` will as suggested clear only the history.

## Request Assertions
In addition to using DUnitX assertions to validate your code behaved as expected
you can also use request assertions to check whether requests you expect your
code to perform where executed as expected.

A simple request assertion:
```Delphi
WebClient.Get(WebMock.URLFor('/'));

WebMock.Assert.Get('/').WasRequested; // Passes
```

As with request stubbing you can match requests by HTTP Method, URI, Query
Parameters, Headers, and Body content.
```Delphi
WebMock.Assert
  .Patch('/resource`)
  .WithQueryParam('ParamName', 'Value')
  .WithHeader('Content-Type', 'application/json')
  .WithBody('{ "resource": { "propertyA": "Value" } }')
  .WasRequested;
```

### Negative Assertions
Anything that can be asserted positively (`WasRequested`) can also be asserted
negatively with `WasNotRequested`. This is useful to check your code is not
performing extra unwanted requests.

## Development Dependencies (Optional)
* [TestInsight](https://bitbucket.org/sglienke/testinsight/wiki/Home) is
  required to run the Delphi-WebMocks test suite, so, if you're considering
  contributing and need to run the test suite, install it. If you do TDD in
  Delphi I would recommend installing and using it in your own projects.

## Semantic Versioning
This project follows [Semantic Versioning](https://semver.org).

## License
Copyright ©2019-2020 Richard Hatherall <richard@appercept.com>

WebMocks is distributed under the terms of the Apache License (Version 2.0).

See [LICENSE](LICENSE) for details.
