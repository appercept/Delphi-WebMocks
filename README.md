![Delphi compatibility](https://img.shields.io/badge/Delphi%20compatability-10.3%20or%20newer-brightgreen)
![Platform compatibility](https://img.shields.io/badge/platform-Linux64%20%7C%20macOS64%20%7C%20Win32%20%7C%20Win64-lightgrey)
![License](https://img.shields.io/github/license/appercept/Delphi-WebMocks)
![Lines of Code](https://tokei.rs/b1/github/appercept/Delphi-WebMocks)

# WebMocks ![GitHub release (latest by date)](https://img.shields.io/github/v/release/appercept/Delphi-WebMocks) ![GitHub commits since latest release (by SemVer)](https://img.shields.io/github/commits-since/appercept/Delphi-WebMocks/latest?sort=semver) ![GitHub Release Date](https://img.shields.io/github/release-date/appercept/Delphi-WebMocks)

Library for stubbing and setting expectations on HTTP requests in Delphi with
[DUnitX](https://github.com/VSoftTechnologies/DUnitX).

WebMocks is built by [Appercept](https://www.appercept.com). We wrote it to
test-drive the
[Appercept AWS SDK for Delphi](https://www.appercept.com/products/aws-sdk-delphi)
and still use it every day.

## Requirements

- [Delphi](https://www.embarcadero.com/products/delphi) 10.3 (Rio) or later\*
- [DUnitX](https://github.com/VSoftTechnologies/DUnitX)
- [Indy](https://www.indyproject.org)

\* WebMocks was developed in Delphi 10.3 (Rio) and 10.4 (Sydney) and until
version 3.0 was compatible back to XE8. As WebMocks makes use of the
`System.Net` library introduced with XE8 it will not be compatible with earlier
versions. Should you require installing on Delphi versions prior to 10.3 you
should install version
[2.0.0](https://github.com/appercept/Delphi-WebMocks/releases/tag/2.0.0).

## Installation: GetIt

[WebMocks](https://getitnow.embarcadero.com/webmocks/) is available
through Embarcadero's package manager for Delphi
[GetIt](https://getitnow.embarcadero.com/). If you have a recent version of
Delphi including GetIt then this should be the preferred installation method.

## Installation: Delphinus-Support

WebMocks should now be listed in
[Delphinus](https://github.com/Memnarch/Delphinus) package manager.

Be sure to restart Delphi after installing via Delphinus otherwise the units may
not be found in your test projects.

## Installation: Manual

1. Download and extract the
   [latest release](https://github.com/appercept/Delphi-WebMocks/releases/latest).
2. In "Tools > Options" under the "Language / Delphi / Library" add the
   extracted `Source` directory to the "Library path" and "Browsing path".

## Quick Start

```Delphi
// Stub a request
WebMock.StubRequest('GET', '/endpoint');

// Point your code at the mock server
Subject.EndpointURL := WebMock.URLFor('endpoint');

// Assert the request was made
WebMock.Assert.Get('/endpoint').WasRequested;
```

WebMocks spins up a local HTTP server that your code talks to like any real
service. Stub responses, then assert that the requests you expected actually
happened.

For a gentle introduction, see the article series
[Testing HTTP clients in Delphi with DUnitX and WebMocks](https://dev.to/rhatherall/testing-http-clients-in-delphi-with-dunitx-and-webmocks-25ck)
and the accompanying
[Delphi-WebMocks-Demos](https://github.com/appercept/Delphi-WebMocks-Demos).

## Upgrading from versions prior to 2.0.0

Version 2 has dropped the `Delphi.` namespace from all units. Any projects
upgrade to version 2 or later will need to drop the `Delphi.` prefix from any
included WebMocks units.

## Setup

In your test unit file a couple of simple steps are required.

1. Add `WebMock` to your interface `uses`.
2. In your `TestFixture` class use `Setup` and `TearDown` to create/destroy an
   instance of `TWebMock`.

### Full Example

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

By default `TWebMock` will bind to a port dynamically assigned starting at `8080`.
This behaviour can be overridden by specifying a port at creation.

```Delphi
WebMock := TWebMock.Create(8088);
```

The use of `WebMock.URLFor` function within your tests is to simplify
constructing a valid URL. The `Port` property contains the current bound port
and `BaseURL` property contains a valid URL for the server root.

## Documentation

Detailed API documentation with examples is available in the [`docs/`](docs/)
folder:

- **[Stubbing Requests](docs/stubbing.md)** — matching by method, URI, headers,
  body, form-data, JSON, XML, regular expressions, and predicate functions
- **[Configuring Responses](docs/responses.md)** — status codes, headers, string
  and file body content, and dynamic responses
- **[Request Assertions](docs/assertions.md)** — request history, the fluent
  assertion API, and negative assertions

## Development Dependencies (Optional)

- [TestInsight](https://bitbucket.org/sglienke/testinsight/wiki/Home) is
  required to run the Delphi-WebMocks test suite, so, if you're considering
  contributing and need to run the test suite, install it. If you do TDD in
  Delphi I would recommend installing and using it in your own projects.

## Semantic Versioning

This project follows [Semantic Versioning](https://semver.org).

## License

Copyright ©2019-2024 Richard Hatherall <richard@appercept.com>

WebMocks is distributed under the terms of the Apache License (Version 2.0).

See [LICENSE](LICENSE) for details.
