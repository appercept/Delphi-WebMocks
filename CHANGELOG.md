# Changelog

## [3.2.1](https://github.com/appercept/Delphi-WebMocks/tree/3.2.1) (2024-04-18)

[Full Changelog](https://github.com/appercept/Delphi-WebMocks/compare/3.2.0...3.2.1)

**Fixed bugs:**

- Only the first WebMock.Assert in a test yields correct assertion result [\#58](https://github.com/appercept/Delphi-WebMocks/issues/58)
- Setting content-length response header does not set response content length correctly [\#56](https://github.com/appercept/Delphi-WebMocks/issues/56)
- WithQueryParam assertion is not correctly testing duplicates [\#54](https://github.com/appercept/Delphi-WebMocks/issues/54)
- The History interface does not work as documented [\#53](https://github.com/appercept/Delphi-WebMocks/issues/53)

**Merged pull requests:**

- fix: Restore History interface [\#60](https://github.com/appercept/Delphi-WebMocks/pull/60) ([rhatherall](https://github.com/rhatherall))
- fix: Allow multiple assertions [\#59](https://github.com/appercept/Delphi-WebMocks/pull/59) ([rhatherall](https://github.com/rhatherall))
- fix: Allow setting Content-Length by header [\#57](https://github.com/appercept/Delphi-WebMocks/pull/57) ([rhatherall](https://github.com/rhatherall))
- fix: Allow duplicate query parameter matching [\#55](https://github.com/appercept/Delphi-WebMocks/pull/55) ([rhatherall](https://github.com/rhatherall))

## [3.2.0](https://github.com/appercept/Delphi-WebMocks/tree/3.2.0) (2022-06-20)

[Full Changelog](https://github.com/appercept/Delphi-WebMocks/compare/3.1.0...3.2.0)

**Implemented enhancements:**

- Add support for matching JSON content by RegEx [\#52](https://github.com/appercept/Delphi-WebMocks/pull/52) ([rhatherall](https://github.com/rhatherall))
- Add support for matching content by XML values [\#51](https://github.com/appercept/Delphi-WebMocks/pull/51) ([rhatherall](https://github.com/rhatherall))
- Add support for asserting HEAD requests [\#48](https://github.com/appercept/Delphi-WebMocks/pull/48) ([rhatherall](https://github.com/rhatherall))

**Fixed bugs:**

- Plain query parameters \(without values\) can cause exceptions [\#49](https://github.com/appercept/Delphi-WebMocks/issues/49)

**Closed issues:**

- It is not currently possible to make assertions on HEAD requests [\#47](https://github.com/appercept/Delphi-WebMocks/issues/47)

**Merged pull requests:**

- Fix exception matching query params with no value [\#50](https://github.com/appercept/Delphi-WebMocks/pull/50) ([rhatherall](https://github.com/rhatherall))

## [3.1.0](https://github.com/appercept/Delphi-WebMocks/tree/3.1.0) (2021-03-09)

[Full Changelog](https://github.com/appercept/Delphi-WebMocks/compare/3.0.1...3.1.0)

**Implemented enhancements:**

- Add support for matching requests by query params [\#46](https://github.com/appercept/Delphi-WebMocks/pull/46) ([rhatherall](https://github.com/rhatherall))

## [3.0.1](https://github.com/appercept/Delphi-WebMocks/tree/3.0.1) (2021-02-08)

[Full Changelog](https://github.com/appercept/Delphi-WebMocks/compare/3.0.0...3.0.1)

**Fixed bugs:**

- Windows Defender Firewall prompts on first run [\#44](https://github.com/appercept/Delphi-WebMocks/issues/44)

**Merged pull requests:**

- Bind to localhost only [\#45](https://github.com/appercept/Delphi-WebMocks/pull/45) ([rhatherall](https://github.com/rhatherall))

## [3.0.0](https://github.com/appercept/Delphi-WebMocks/tree/3.0.0) (2021-01-27)

[Full Changelog](https://github.com/appercept/Delphi-WebMocks/compare/2.0.0...3.0.0)

**Implemented enhancements:**

- Assertion matching by URL query parameters [\#41](https://github.com/appercept/Delphi-WebMocks/issues/41)
- Request content matching by Form-Data [\#20](https://github.com/appercept/Delphi-WebMocks/issues/20)
- Request matching by JSON values

**Fixed bugs:**

- Test failure due to platform line endings [\#43](https://github.com/appercept/Delphi-WebMocks/issues/43)
- Request history is not persisting query parameters [\#42](https://github.com/appercept/Delphi-WebMocks/issues/42)

## [2.0.0](https://github.com/appercept/Delphi-WebMocks/tree/2.0.0) (2020-11-25)

[Full Changelog](https://github.com/appercept/Delphi-WebMocks/compare/1.3.0...2.0.0)

**Implemented enhancements:**

- Dynamic response stubs [\#16](https://github.com/appercept/Delphi-WebMocks/issues/16)
- Add support for dynamic responses [\#40](https://github.com/appercept/Delphi-WebMocks/pull/40) ([rhatherall](https://github.com/rhatherall))
- Remove packages for Delphinus installation [\#39](https://github.com/appercept/Delphi-WebMocks/pull/39) ([rhatherall](https://github.com/rhatherall))
- Remove `Delphi.` unit prefix [\#38](https://github.com/appercept/Delphi-WebMocks/pull/38) ([rhatherall](https://github.com/rhatherall))

**Fixed bugs:**

- Unsupported Authorisation Scheme error when setting Authorization header [\#34](https://github.com/appercept/Delphi-WebMocks/issues/34)
- Repeated calls to stubs with content causes exception [\#32](https://github.com/appercept/Delphi-WebMocks/issues/32)

**Closed issues:**

- Packages are not required for Delphinus installation [\#37](https://github.com/appercept/Delphi-WebMocks/issues/37)
- Remove `Delphi.` namespace prefix [\#36](https://github.com/appercept/Delphi-WebMocks/issues/36)

**Merged pull requests:**

- Allow any authorization header values for stubs [\#35](https://github.com/appercept/Delphi-WebMocks/pull/35) ([rhatherall](https://github.com/rhatherall))
- Use fresh content streams for successive requests [\#33](https://github.com/appercept/Delphi-WebMocks/pull/33) ([rhatherall](https://github.com/rhatherall))

## [1.3.0](https://github.com/appercept/Delphi-WebMocks/tree/1.3.0) (2020-10-07)

[Full Changelog](https://github.com/appercept/Delphi-WebMocks/compare/1.2.2...1.3.0)

**Implemented enhancements:**

- Add auto-port allocation [\#31](https://github.com/appercept/Delphi-WebMocks/pull/31) ([rhatherall](https://github.com/rhatherall))

**Closed issues:**

- In large projects you can frequently hit port clashes [\#30](https://github.com/appercept/Delphi-WebMocks/issues/30)

## [1.2.2](https://github.com/appercept/Delphi-WebMocks/tree/1.2.2) (2020-07-25)

[Full Changelog](https://github.com/appercept/Delphi-WebMocks/compare/1.2.1...1.2.2)

**Fixed bugs:**

- Delphinus installation needs packages [\#29](https://github.com/appercept/Delphi-WebMocks/issues/29)

## [1.2.1](https://github.com/appercept/Delphi-WebMocks/tree/1.2.1) (2020-07-23)

[Full Changelog](https://github.com/appercept/Delphi-WebMocks/compare/1.2.0...1.2.1)

**Fixed bugs:**

- Cannot browse to source when installed via Delphinus [\#28](https://github.com/appercept/Delphi-WebMocks/issues/28)

## [1.2.0](https://github.com/appercept/Delphi-WebMocks/tree/1.2.0) (2020-07-23)

[Full Changelog](https://github.com/appercept/Delphi-WebMocks/compare/1.1.0...1.2.0)

**Implemented enhancements:**

- Add Delphinus support [\#26](https://github.com/appercept/Delphi-WebMocks/pull/26) ([rhatherall](https://github.com/rhatherall))

**Fixed bugs:**

- Project is not showing in Delphinus [\#27](https://github.com/appercept/Delphi-WebMocks/issues/27)

**Closed issues:**

- Delphinus support would be good [\#25](https://github.com/appercept/Delphi-WebMocks/issues/25)
- Delphi 10.4 Sydney has been released [\#24](https://github.com/appercept/Delphi-WebMocks/issues/24)

## [1.1.0](https://github.com/appercept/Delphi-WebMocks/tree/1.1.0) (2020-02-16)

[Full Changelog](https://github.com/appercept/Delphi-WebMocks/compare/1.0.1...1.1.0)

**Implemented enhancements:**

- Dynamic request matchers [\#22](https://github.com/appercept/Delphi-WebMocks/issues/22)
- Add dynamic request matching [\#23](https://github.com/appercept/Delphi-WebMocks/pull/23) ([rhatherall](https://github.com/rhatherall))
- Enable TestInsight [\#21](https://github.com/appercept/Delphi-WebMocks/pull/21) ([rhatherall](https://github.com/rhatherall))

## [1.0.1](https://github.com/appercept/Delphi-WebMocks/tree/1.0.1) (2019-11-12)

[Full Changelog](https://github.com/appercept/Delphi-WebMocks/compare/1.0.0...1.0.1)

**Fixed bugs:**

- Some warnings in Berlin [\#17](https://github.com/appercept/Delphi-WebMocks/issues/17)

**Merged pull requests:**

- Clean up warning \(W1010\) and silence warnings \(W1029\) [\#18](https://github.com/appercept/Delphi-WebMocks/pull/18) ([rhatherall](https://github.com/rhatherall))

## [1.0.0](https://github.com/appercept/Delphi-WebMocks/tree/1.0.0) (2019-11-03)

[Full Changelog](https://github.com/appercept/Delphi-WebMocks/compare/0.2.0...1.0.0)

**Implemented enhancements:**

- Request assertions [\#15](https://github.com/appercept/Delphi-WebMocks/issues/15)
- TWebMockTestsClient should be replaced with THTTPClient [\#13](https://github.com/appercept/Delphi-WebMocks/issues/13)
- Add `URLFor` method [\#12](https://github.com/appercept/Delphi-WebMocks/issues/12)
- Replace usages of Indy HTTP terms with terms used in the RFCs [\#11](https://github.com/appercept/Delphi-WebMocks/issues/11)
- Request history logging [\#10](https://github.com/appercept/Delphi-WebMocks/issues/10)

**Merged pull requests:**

- Replace TWebMockTestsClient with THTTPClient [\#14](https://github.com/appercept/Delphi-WebMocks/pull/14) ([rhatherall](https://github.com/rhatherall))

## [0.2.0](https://github.com/appercept/Delphi-WebMocks/tree/0.2.0) (2019-09-13)

[Full Changelog](https://github.com/appercept/Delphi-WebMocks/compare/0.1.0...0.2.0)

**Implemented enhancements:**

- Request content matching by regular-expressions [\#9](https://github.com/appercept/Delphi-WebMocks/issues/9)
- Request content matching by value [\#8](https://github.com/appercept/Delphi-WebMocks/issues/8)
- Response headers [\#7](https://github.com/appercept/Delphi-WebMocks/issues/7)
- Request header matching by regular-expressions [\#5](https://github.com/appercept/Delphi-WebMocks/issues/5)
- Request path matching by regular-expressions [\#4](https://github.com/appercept/Delphi-WebMocks/issues/4)
- Delphi 10.3.2 is out [\#2](https://github.com/appercept/Delphi-WebMocks/issues/2)
- Request header matching by value [\#1](https://github.com/appercept/Delphi-WebMocks/issues/1)
- Upgrade project format to Delphi 10.3.2 [\#3](https://github.com/appercept/Delphi-WebMocks/pull/3) ([rhatherall](https://github.com/rhatherall))

**Closed issues:**

- Documentation of request header matching is missing from README [\#6](https://github.com/appercept/Delphi-WebMocks/issues/6)

## [0.1.0](https://github.com/appercept/Delphi-WebMocks/tree/0.1.0) (2019-07-17)

[Full Changelog](https://github.com/appercept/Delphi-WebMocks/compare/5fe706284917ad4b8908ecc9c1c4c97b3d41b434...0.1.0)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
