# Request Assertions

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

**NOTE:** Should you find yourself writing assertions in this manner you should
take a look at the assertion API below which provides a more concise way of
defining these assertions.

### Resetting Request History

If you need to clear request history you can call `ResetHistory` or `Reset` on
the instance of TWebMock. The general `Reset` method will return the TWebMock
instance to a blank state including emptying the history. The more specific
`ResetHistory` will as suggested clear only the history.

## Assertion API

In addition to using DUnitX assertions to validate your code behaved as expected
you can also use request assertions to check whether requests you expect your
code to perform where executed as expected.

A simple request assertion:

```Delphi
WebClient.Get(WebMock.URLFor('/'));

WebMock.Assert.Get('/').WasRequested; // Passes
```

As with request stubbing you can match requests by HTTP Method, URI, Query
Parameters, Headers, and Body content (including `WithJSON` and `WithXML`).

```Delphi
WebMock.Assert
  .Patch('/resource')
  .WithQueryParam('ParamName', 'Value')
  .WithHeader('Content-Type', 'application/json')
  .WithBody('{ "resource": { "propertyA": "Value" } }')
  .WasRequested;
```

## Negative Assertions

Anything that can be asserted positively (`WasRequested`) can also be asserted
negatively with `WasNotRequested`. This is useful to check your code is not
performing extra unwanted requests.
