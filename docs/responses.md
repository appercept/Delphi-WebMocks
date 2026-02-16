# Configuring Responses

## Response Status Codes

By default a response status will be `200 OK` for a stubbed request. If a
request is made to `TWebMock` without a registered stub it will respond
`501 Not Implemented`. To specify the response status use `ToRespond`.

```Delphi
WebMock.StubRequest('GET', '/').ToRespond(TWebMockResponseStatus.NotFound);
```

## Response Headers

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

## Response Content: String Values

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

## Response Content: Fixture Files

When stubbing responses with binary or large content it is likely easier to
provide the content as a file. This can be achieved using `WithBodyFile`
which has the same signature as `WithBody` but the first argument is the
path to a file.

```Delphi
WebMock.StubRequest('GET', '/').WithBodyFile('image.jpg');
```

The Delphi-WebMocks will attempt to set the content-type according to the file
extension. If the file type is unknown then the content-type will default to
`application/octet-stream`. The content-type can be overridden with the second
argument. e.g.

```Delphi
WebMock.StubRequest('GET', '/').WithBodyFile('file.myext', 'application/xml');
```

**NOTE:** One "gotcha" accessing files in tests is the location of the file will
be relative to the test executable which, by default, using the Windows 32-bit
compiler will be output to the `Win32\Debug` folder. To correctly reference a
file named `Content.txt` in the project folder, the path will be
`..\..\Content.txt`.

## Dynamic Responses

Sometimes it is useful to dynamically respond to a request. For example:

```Delphi
WebMock.StubRequest('*', '*')
  .ToRespondWith(
    procedure (const ARequest: IWebMockHTTPRequest;
               const AResponse: IWebMockResponseBuilder)
    begin
      AResponse
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
