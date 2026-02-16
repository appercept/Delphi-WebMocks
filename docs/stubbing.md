# Stubbing Requests

## Request matching by HTTP method and document path

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

## Request matching by header value

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

## Request matching by body content

HTTP request can be matched by content like:

```Delphi
WebMock.StubRequest('*', '*').WithBody('String content.');
```

## Request matching by form-data

HTTP requests can be matched by form-data as submitted with `content-type` of
`application/x-www-form-urlencoded`. Multiple matching field values can be
combined. For example:

```Delphi
WebMock.StubRequest('*', '*')
  .WithFormData('AField', 'A value.')
  .WithFormData('AOtherField', 'Another value.');
```

To simply match the presence of a field, a wildcard `*` can be passed for the
value.

NOTE: You cannot match form-data (`WithFormData`) and body content (`WithBody`)
at the same time. Specifying both will result in the latest call overwriting the
previous matcher.

## Matching by regular-expression

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

Matching form-data content can be performed like:

```Delphi
WebMock.StubRequest('*', '*')
  .WithFormData('AField', TRegEx.Create('.*'));
```

NOTE: Be sure to add `System.RegularExpressions` to your uses clause.

## Request matching by JSON

HTTP requests can be matched by JSON data as submitted with `content-type` of
`application/json` using `WithJSON`. Multiple matching field values can be
combined. For example:

```Delphi
WebMock.StubRequest('*', '*')
  .WithJSON('ABoolean', True)
  .WithJSON('AFloat', 0.123)
  .WithJSON('AInteger', 1)
  .WithJSON('AString', 'value');
```

The first argument can be a path. For example, in the following JSON, the path
`objects[0].key` would match `value 1`.

```JSON
{
  "objects": [
    { "key": "value 1" },
    { "key": "value 2" }
  ]
}
```

NOTE: Strings patterns can be matched by passing a regular expression as the
second argument. For example:

```Delphi
WebMock.StubRequest('*', '*')
  .WithJSON('objects[0].key', TRegEx.Create('value\s\d+'));
```

## Request matching by XML

HTTP request can be matched by XML data values submitted. For example:

```Delphi
WebMock.StubRequest('*', '*')
  .WithXML('/Object/Attr1', 'Value 1');
```

The first argument is an XPath expression. The previous example would make a
positive match against the following document:

```XML
<?xml version="1.0" encoding="UTF-8"?>
<Object>
  <Attr1>Value 1</Attr1>
</Object>
```

The second argument can be a boolean, floating point, integer, or string
value.

## Request matching by predicate function

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

## Resetting Registered Stubs

If you need to clear the current registered stubs you can call
`ResetStubRegistry` or `Reset` on the instance of TWebMock. The general `Reset`
method will return the TWebMock instance to a blank state including emptying the
stub registry. The more specific `ResetStubRegistry` will as suggested clear
only the stub registry.
