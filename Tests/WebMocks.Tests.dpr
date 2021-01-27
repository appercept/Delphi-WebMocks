program WebMocks.Tests;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}

uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  WebMock.Tests in 'WebMock.Tests.pas',
  WebMock in '..\Source\WebMock.pas',
  TestHelpers in 'TestHelpers.pas',
  WebMock.Static.RequestStub.Tests in 'WebMock.Static.RequestStub.Tests.pas',
  WebMock.Static.RequestStub in '..\Source\WebMock.Static.RequestStub.pas',
  WebMock.HTTP.RequestMatcher.Tests in 'WebMock.HTTP.RequestMatcher.Tests.pas',
  WebMock.HTTP.RequestMatcher in '..\Source\WebMock.HTTP.RequestMatcher.pas',
  Mock.Indy.HTTPRequestInfo in 'Mock.Indy.HTTPRequestInfo.pas',
  WebMock.ResponseStatus.Tests in 'WebMock.ResponseStatus.Tests.pas',
  WebMock.ResponseStatus in '..\Source\WebMock.ResponseStatus.pas',
  WebMock.Response.Tests in 'WebMock.Response.Tests.pas',
  WebMock.Response in '..\Source\WebMock.Response.pas',
  WebMock.ResponseContentString.Tests in 'WebMock.ResponseContentString.Tests.pas',
  WebMock.ResponseContentString in '..\Source\WebMock.ResponseContentString.pas',
  WebMock.ResponseBodySource in '..\Source\WebMock.ResponseBodySource.pas',
  WebMock.ResponseContentFile.Tests in 'WebMock.ResponseContentFile.Tests.pas',
  WebMock.ResponseContentFile in '..\Source\WebMock.ResponseContentFile.pas',
  WebMock.Matching.Tests in 'Features\WebMock.Matching.Tests.pas',
  WebMock.StringWildcardMatcher.Tests in 'WebMock.StringWildcardMatcher.Tests.pas',
  WebMock.StringWildcardMatcher in '..\Source\WebMock.StringWildcardMatcher.pas',
  WebMock.StringMatcher in '..\Source\WebMock.StringMatcher.pas',
  WebMock.StringRegExMatcher.Tests in 'WebMock.StringRegExMatcher.Tests.pas',
  WebMock.StringRegExMatcher in '..\Source\WebMock.StringRegExMatcher.pas',
  WebMock.ResponsesWithHeaders.Tests in 'Features\WebMock.ResponsesWithHeaders.Tests.pas',
  WebMock.ResponsesWithBody.Tests in 'Features\WebMock.ResponsesWithBody.Tests.pas',
  WebMock.MatchingBody.Tests in 'Features\WebMock.MatchingBody.Tests.pas',
  WebMock.StringAnyMatcher.Tests in 'WebMock.StringAnyMatcher.Tests.pas',
  WebMock.StringAnyMatcher in '..\Source\WebMock.StringAnyMatcher.pas',
  WebMock.History.Tests in 'Features\WebMock.History.Tests.pas',
  WebMock.HTTP.Messages in '..\Source\WebMock.HTTP.Messages.pas',
  WebMock.HTTP.Request.Tests in 'WebMock.HTTP.Request.Tests.pas',
  WebMock.HTTP.Request in '..\Source\WebMock.HTTP.Request.pas',
  WebMock.Responses.Tests in 'Features\WebMock.Responses.Tests.pas',
  WebMock.Assertions.Tests in 'Features\WebMock.Assertions.Tests.pas',
  WebMock.Assertion in '..\Source\WebMock.Assertion.pas',
  WebMock.Assertion.Tests in 'WebMock.Assertion.Tests.pas',
  WebMock.DynamicMatching.Tests in 'Features\WebMock.DynamicMatching.Tests.pas',
  WebMock.Dynamic.RequestStub.Tests in 'WebMock.Dynamic.RequestStub.Tests.pas',
  WebMock.Dynamic.RequestStub in '..\Source\WebMock.Dynamic.RequestStub.pas',
  WebMock.RequestStub in '..\Source\WebMock.RequestStub.pas',
  WebMock.Static.Responder.Tests in 'WebMock.Static.Responder.Tests.pas',
  WebMock.Static.Responder in '..\Source\WebMock.Static.Responder.pas',
  WebMock.Responder in '..\Source\WebMock.Responder.pas',
  WebMock.ResponseBuilder.Tests in 'WebMock.ResponseBuilder.Tests.pas',
  WebMock.DynamicResponses.Tests in 'Features\WebMock.DynamicResponses.Tests.pas',
  WebMock.Dynamic.Responder.Tests in 'WebMock.Dynamic.Responder.Tests.pas',
  WebMock.Dynamic.Responder in '..\Source\WebMock.Dynamic.Responder.pas',
  WebMock.FormDataMatcher.Tests in 'WebMock.FormDataMatcher.Tests.pas',
  WebMock.FormDataMatcher in '..\Source\WebMock.FormDataMatcher.pas',
  WebMock.FormFieldMatcher.Tests in 'WebMock.FormFieldMatcher.Tests.pas',
  WebMock.FormFieldMatcher in '..\Source\WebMock.FormFieldMatcher.pas',
  WebMock.MatchingJSON.Tests in 'Features\WebMock.MatchingJSON.Tests.pas',
  WebMock.JSONMatcher in '..\Source\WebMock.JSONMatcher.pas',
  WebMock.JSONMatcher.Tests in 'WebMock.JSONMatcher.Tests.pas',
  WebMock.JSONValueMatcher.Tests in 'WebMock.JSONValueMatcher.Tests.pas';

var
  Runner: ITestRunner;
  Results: IRunResults;
  Logger: ITestLogger;
  NUnitLogger: ITestLogger;

begin
{$IFDEF TESTINSIGHT}
  ReportMemoryLeaksOnShutdown := True;
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
