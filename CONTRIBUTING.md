# Contributing to WebMocks

Bug reports, feature requests, and pull requests are welcome.

## Reporting issues

Open an issue on GitHub. If you're reporting a bug, include the Delphi version,
target platform, and a minimal reproduction if possible.

## Development setup

1. Install [TestInsight](https://bitbucket.org/sglienke/testinsight/wiki/Home)
   into RAD Studio (Delphi 10.3 or later) if you haven't already.
2. Fork and clone the repository.
3. Open `WebMocks.groupproj` in RAD Studio.
4. Build and run the `WebMocks.Tests` project.

The `Source/` directory contains the library. The `Tests/` directory contains
unit tests for individual classes and `Tests/Features/` contains integration
tests that make real HTTP requests against a local `TWebMock` instance.

## Submitting changes

1. Create a branch from `develop`.
2. Make your changes. Add or update tests as appropriate.
3. Make sure all tests pass.
4. Open a pull request against `develop`.

Keep pull requests focused on a single change. Include tests that cover your
changes — if you're fixing a bug, add a test that fails without the fix.
