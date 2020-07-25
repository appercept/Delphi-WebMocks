program Delphi.WebMocks.Tests;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}

{$WARN DUPLICATE_CTOR_DTOR OFF}

uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  Delphi.WebMock.Tests in 'Delphi.WebMock.Tests.pas',
  Delphi.WebMock in '..\Source\Delphi.WebMock.pas',
  TestHelpers in 'TestHelpers.pas',
  Delphi.WebMock.Static.RequestStub.Tests in 'Delphi.WebMock.Static.RequestStub.Tests.pas',
  Delphi.WebMock.Static.RequestStub in '..\Source\Delphi.WebMock.Static.RequestStub.pas',
  Delphi.WebMock.HTTP.RequestMatcher.Tests in 'Delphi.WebMock.HTTP.RequestMatcher.Tests.pas',
  Delphi.WebMock.HTTP.RequestMatcher in '..\Source\Delphi.WebMock.HTTP.RequestMatcher.pas',
  Mock.Indy.HTTPRequestInfo in 'Mock.Indy.HTTPRequestInfo.pas',
  Delphi.WebMock.ResponseStatus.Tests in 'Delphi.WebMock.ResponseStatus.Tests.pas',
  Delphi.WebMock.ResponseStatus in '..\Source\Delphi.WebMock.ResponseStatus.pas',
  Delphi.WebMock.Response.Tests in 'Delphi.WebMock.Response.Tests.pas',
  Delphi.WebMock.Response in '..\Source\Delphi.WebMock.Response.pas',
  Delphi.WebMock.ResponseContentString.Tests in 'Delphi.WebMock.ResponseContentString.Tests.pas',
  Delphi.WebMock.ResponseContentString in '..\Source\Delphi.WebMock.ResponseContentString.pas',
  Delphi.WebMock.ResponseBodySource in '..\Source\Delphi.WebMock.ResponseBodySource.pas',
  Delphi.WebMock.ResponseContentFile.Tests in 'Delphi.WebMock.ResponseContentFile.Tests.pas',
  Delphi.WebMock.ResponseContentFile in '..\Source\Delphi.WebMock.ResponseContentFile.pas',
  Delphi.WebMock.Matching.Tests in 'Features\Delphi.WebMock.Matching.Tests.pas',
  Delphi.WebMock.StringWildcardMatcher.Tests in 'Delphi.WebMock.StringWildcardMatcher.Tests.pas',
  Delphi.WebMock.StringWildcardMatcher in '..\Source\Delphi.WebMock.StringWildcardMatcher.pas',
  Delphi.WebMock.StringMatcher in '..\Source\Delphi.WebMock.StringMatcher.pas',
  Delphi.WebMock.StringRegExMatcher.Tests in 'Delphi.WebMock.StringRegExMatcher.Tests.pas',
  Delphi.WebMock.StringRegExMatcher in '..\Source\Delphi.WebMock.StringRegExMatcher.pas',
  Delphi.WebMock.ResponsesWithHeaders.Tests in 'Features\Delphi.WebMock.ResponsesWithHeaders.Tests.pas',
  Delphi.WebMock.ResponsesWithBody.Tests in 'Features\Delphi.WebMock.ResponsesWithBody.Tests.pas',
  Delphi.WebMock.MatchingBody.Tests in 'Features\Delphi.WebMock.MatchingBody.Tests.pas',
  Delphi.WebMock.StringAnyMatcher.Tests in 'Delphi.WebMock.StringAnyMatcher.Tests.pas',
  Delphi.WebMock.StringAnyMatcher in '..\Source\Delphi.WebMock.StringAnyMatcher.pas',
  Delphi.WebMock.History.Tests in 'Features\Delphi.WebMock.History.Tests.pas',
  Delphi.WebMock.HTTP.Messages in '..\Source\Delphi.WebMock.HTTP.Messages.pas',
  Delphi.WebMock.HTTP.Request.Tests in 'Delphi.WebMock.HTTP.Request.Tests.pas',
  Delphi.WebMock.HTTP.Request in '..\Source\Delphi.WebMock.HTTP.Request.pas',
  Delphi.WebMock.Responses.Tests in 'Features\Delphi.WebMock.Responses.Tests.pas',
  Delphi.WebMock.Assertions.Tests in 'Features\Delphi.WebMock.Assertions.Tests.pas',
  Delphi.WebMock.Assertion in '..\Source\Delphi.WebMock.Assertion.pas',
  Delphi.WebMock.Assertion.Tests in 'Delphi.WebMock.Assertion.Tests.pas',
  Delphi.WebMock.DynamicMatching.Tests in 'Features\Delphi.WebMock.DynamicMatching.Tests.pas',
  Delphi.WebMock.Dynamic.RequestStub.Tests in 'Delphi.WebMock.Dynamic.RequestStub.Tests.pas',
  Delphi.WebMock.Dynamic.RequestStub in '..\Source\Delphi.WebMock.Dynamic.RequestStub.pas',
  Delphi.WebMock.RequestStub in '..\Source\Delphi.WebMock.RequestStub.pas';

var
  Runner: ITestRunner;
  Results: IRunResults;
  Logger: ITestLogger;
  NUnitLogger: ITestLogger;

begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    // Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    // Create the test runner
    Runner := TDUnitX.CreateRunner;
    // Tell the runner to use RTTI to find Fixtures
    Runner.UseRTTI := True;
    // tell the runner how we will log things
    // Log to the console window
    Logger := TDUnitXConsoleLogger.Create(True);
    Runner.AddLogger(Logger);
    // Generate an NUnit compatible XML File
    NUnitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    Runner.AddLogger(NUnitLogger);
    Runner.FailsOnNoAsserts := False;
    // When true, Assertions must be made during tests;

    // Run tests
    Results := Runner.Execute;
    if not Results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

{$IFNDEF CI}
    // We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
{$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;

end.
