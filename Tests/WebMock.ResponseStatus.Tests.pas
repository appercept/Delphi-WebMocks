{******************************************************************************}
{                                                                              }
{           Delphi-WebMocks                                                    }
{                                                                              }
{           Copyright (c) 2019 Richard Hatherall                               }
{                                                                              }
{           richard@appercept.com                                              }
{           https://appercept.com                                              }
{                                                                              }
{******************************************************************************}
{                                                                              }
{   Licensed under the Apache License, Version 2.0 (the "License");            }
{   you may not use this file except in compliance with the License.           }
{   You may obtain a copy of the License at                                    }
{                                                                              }
{       http://www.apache.org/licenses/LICENSE-2.0                             }
{                                                                              }
{   Unless required by applicable law or agreed to in writing, software        }
{   distributed under the License is distributed on an "AS IS" BASIS,          }
{   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   }
{   See the License for the specific language governing permissions and        }
{   limitations under the License.                                             }
{                                                                              }
{******************************************************************************}

unit WebMock.ResponseStatus.Tests;

interface

uses
  DUnitX.TestFramework,
  WebMock.ResponseStatus;

type

  [TestFixture]
  TWebMockResponseStatusTests = class(TObject)
  private
    WebMockResponseStatus: TWebMockResponseStatus;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure Create_GivenAStatus_CreatesResponseWithStatus;

    [Test]
    procedure Continue_Always_CreatesResponseWithStatus100;
    [Test]
    procedure SwitchingProtocols_Always_CreatesResponseWithStatus101;
    [Test]
    procedure Processing_Always_CreatesResponseWithStatus102;

    [Test]
    procedure OK_Always_CreatesResponseWithStatus200;
    [Test]
    procedure Created_Always_CreatesResponseWithStatus201;
    [Test]
    procedure Accepted_Always_CreatesResponseWithStatus202;
    [Test]
    procedure NonAuthoritativeInformation_Always_CreatesResponseWithStatus203;
    [Test]
    procedure NoContent_Always_CreatesResponseWithStatus204;
    [Test]
    procedure ResetContent_Always_CreatesResponseWithStatus205;
    [Test]
    procedure PartialContent_Always_CreatesResponseWithStatus206;
    [Test]
    procedure MultiStatus_Always_CreatesResponseWithStatus207;
    [Test]
    procedure AlreadyReported_Always_CreatesResponseWithStatus208;
    [Test]
    procedure IMUsed_Always_CreatesResponseWithStatus226;

    [Test]
    procedure MultipleChoices_Always_CreatesResponseWithStatus300;
    [Test]
    procedure MovedPermanently_Always_CreatesResponseWithStatus301;
    [Test]
    procedure Found_Always_CreatesResponseWithStatus302;
    [Test]
    procedure SeeOther_Always_CreatesResponseWithStatus303;
    [Test]
    procedure NotModified_Always_CreatesResponseWithStatus304;
    [Test]
    procedure UseProxy_Always_CreatesResponseWithStatus305;
    [Test]
    procedure TemporaryRedirect_Always_CreatesResponseWithStatus307;
    [Test]
    procedure PermanentRedirect_Always_CreatesResponseWithStatus308;

    [Test]
    procedure BadRequest_Always_CreatesResponseWithStatus400;
    [Test]
    procedure Unauthorized_Always_CreatesResponseWithStatus401;
    [Test]
    procedure PaymentRequired_Always_CreatesResponseWithStatus402;
    [Test]
    procedure Forbidden_Always_CreatesResponseWithStatus403;
    [Test]
    procedure NotFound_Always_CreatesResponseWithStatus404;
    [Test]
    procedure MethodNotAllowed_Always_CreatesResponseWithStatus405;
    [Test]
    procedure NotAcceptable_Always_CreatesResponseWithStatus406;
    [Test]
    procedure ProxyAuthenticationRequired_Always_CreatesResponseWithStatus407;
    [Test]
    procedure RequestTimeout_Always_CreatesResponseWithStatus408;
    [Test]
    procedure Conflict_Always_CreatesResponseWithStatus409;
    [Test]
    procedure Gone_Always_CreatesResponseWithStatus410;
    [Test]
    procedure LengthRequired_Always_CreatesResponseWithStatus411;
    [Test]
    procedure PreconditionFailed_Always_CreatesResponseWithStatus412;
    [Test]
    procedure PayloadTooLarge_Always_CreatesResponseWithStatus413;
    [Test]
    procedure RequestURITooLong_Always_CreatesResponseWithStatus414;
    [Test]
    procedure UnsupportedMediaType_Always_CreatesResponseWithStatus415;
    [Test]
    procedure RequestedRangeNotSatisfiable_Always_CreatesResponseWithStatus416;
    [Test]
    procedure ExpectationFailed_Always_CreatesResponseWithStatus417;
    [Test]
    procedure ImATeapot_Always_CreatesResponseWithStatus418;
    [Test]
    procedure MisdirectedRequest_Always_CreatesResponseWithStatus421;
    [Test]
    procedure UnprocessableEntity_Always_CreatesResponseWithStatus422;
    [Test]
    procedure Locked_Always_CreatesResponseWithStatus423;
    [Test]
    procedure FailedDependency_Always_CreatesResponseWithStatus424;
    [Test]
    procedure UpgradeRequired_Always_CreatesResponseWithStatus426;
    [Test]
    procedure PreconditionRequired_Always_CreatesResponseWithStatus428;
    [Test]
    procedure TooManyRequests_Always_CreatesResponseWithStatus429;
    [Test]
    procedure RequestHeaderFieldsTooLarge_Always_CreatesResponseWithStatus431;
    [Test]
    procedure UnavailableForLegalReasons_Always_CreatesResponseWithStatus451;

    [Test]
    procedure InternalServerError_Always_CreatesResponseWithStatus500;
    [Test]
    procedure NotImplemented_Always_CreatesResponseWithStatus501;
    [Test]
    procedure BadGateway_Always_CreatesResponseWithStatus502;
    [Test]
    procedure ServiceUnavailable_Always_CreatesResponseWithStatus503;
    [Test]
    procedure GatewayTimeout_Always_CreatesResponseWithStatus504;
    [Test]
    procedure HTTPVersionNotSupported_Always_CreatesResponseWithStatus505;
    [Test]
    procedure VariantAlsoNegotiates_Always_CreatesResponseWithStatus506;
    [Test]
    procedure InsufficientStorage_Always_CreatesResponseWithStatus507;
    [Test]
    procedure LoopDetected_Always_CreatesResponseWithStatus508;
    [Test]
    procedure NotExtended_Always_CreatesResponseWithStatus510;
    [Test]
    procedure NetworkAuthenticationRequired_Always_CreatesResponseWithStatus511;
    [Test]
    procedure NetworkConnectTimeoutError_Always_CreatesResponseWithStatus599;
  end;

implementation

{ TWebMockResponseStatusTests }

procedure TWebMockResponseStatusTests.Setup;
begin

end;

procedure TWebMockResponseStatusTests.TearDown;
begin
  WebMockResponseStatus.Free;
end;

procedure TWebMockResponseStatusTests.Accepted_Always_CreatesResponseWithStatus202;
begin
  WebMockResponseStatus := TWebMockResponseStatus.Accepted;

  Assert.AreEqual(202, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.AlreadyReported_Always_CreatesResponseWithStatus208;
begin
  WebMockResponseStatus := TWebMockResponseStatus.AlreadyReported;

  Assert.AreEqual(208, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.BadGateway_Always_CreatesResponseWithStatus502;
begin
  WebMockResponseStatus := TWebMockResponseStatus.BadGateway;

  Assert.AreEqual(502, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.BadRequest_Always_CreatesResponseWithStatus400;
begin
  WebMockResponseStatus := TWebMockResponseStatus.BadRequest;

  Assert.AreEqual(400, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.Conflict_Always_CreatesResponseWithStatus409;
begin
  WebMockResponseStatus := TWebMockResponseStatus.Conflict;

  Assert.AreEqual(409, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.Continue_Always_CreatesResponseWithStatus100;
begin
  WebMockResponseStatus := TWebMockResponseStatus.Continue;

  Assert.AreEqual(100, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.Created_Always_CreatesResponseWithStatus201;
begin
  WebMockResponseStatus := TWebMockResponseStatus.Created;

  Assert.AreEqual(201, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.Create_GivenAStatus_CreatesResponseWithStatus;
begin
  WebMockResponseStatus := TWebMockResponseStatus.Create(200);

  Assert.AreEqual(200, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.ExpectationFailed_Always_CreatesResponseWithStatus417;
begin
  WebMockResponseStatus := TWebMockResponseStatus.ExpectationFailed;

  Assert.AreEqual(417, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.FailedDependency_Always_CreatesResponseWithStatus424;
begin
  WebMockResponseStatus := TWebMockResponseStatus.FailedDependency;

  Assert.AreEqual(424, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.Forbidden_Always_CreatesResponseWithStatus403;
begin
  WebMockResponseStatus := TWebMockResponseStatus.Forbidden;

  Assert.AreEqual(403, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.Found_Always_CreatesResponseWithStatus302;
begin
  WebMockResponseStatus := TWebMockResponseStatus.Found;

  Assert.AreEqual(302, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.GatewayTimeout_Always_CreatesResponseWithStatus504;
begin
  WebMockResponseStatus := TWebMockResponseStatus.GatewayTimeout;

  Assert.AreEqual(504, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.Gone_Always_CreatesResponseWithStatus410;
begin
  WebMockResponseStatus := TWebMockResponseStatus.Gone;

  Assert.AreEqual(410, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.HTTPVersionNotSupported_Always_CreatesResponseWithStatus505;
begin
  WebMockResponseStatus := TWebMockResponseStatus.HTTPVersionNotSupported;

  Assert.AreEqual(505, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.ImATeapot_Always_CreatesResponseWithStatus418;
begin
  WebMockResponseStatus := TWebMockResponseStatus.ImATeapot;

  Assert.AreEqual(418, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.IMUsed_Always_CreatesResponseWithStatus226;
begin
  WebMockResponseStatus := TWebMockResponseStatus.IMUsed;

  Assert.AreEqual(226, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.InsufficientStorage_Always_CreatesResponseWithStatus507;
begin
  WebMockResponseStatus := TWebMockResponseStatus.InsufficientStorage;

  Assert.AreEqual(507, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.InternalServerError_Always_CreatesResponseWithStatus500;
begin
  WebMockResponseStatus := TWebMockResponseStatus.InternalServerError;

  Assert.AreEqual(500, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.LengthRequired_Always_CreatesResponseWithStatus411;
begin
  WebMockResponseStatus := TWebMockResponseStatus.LengthRequired;

  Assert.AreEqual(411, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.Locked_Always_CreatesResponseWithStatus423;
begin
  WebMockResponseStatus := TWebMockResponseStatus.Locked;

  Assert.AreEqual(423, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.LoopDetected_Always_CreatesResponseWithStatus508;
begin
  WebMockResponseStatus := TWebMockResponseStatus.LoopDetected;

  Assert.AreEqual(508, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.MethodNotAllowed_Always_CreatesResponseWithStatus405;
begin
  WebMockResponseStatus := TWebMockResponseStatus.MethodNotAllowed;

  Assert.AreEqual(405, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.MisdirectedRequest_Always_CreatesResponseWithStatus421;
begin
  WebMockResponseStatus := TWebMockResponseStatus.MisdirectedRequest;

  Assert.AreEqual(421, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.MovedPermanently_Always_CreatesResponseWithStatus301;
begin
  WebMockResponseStatus := TWebMockResponseStatus.MovedPermanently;

  Assert.AreEqual(301, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.MultipleChoices_Always_CreatesResponseWithStatus300;
begin
  WebMockResponseStatus := TWebMockResponseStatus.MultipleChoices;

  Assert.AreEqual(300, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.MultiStatus_Always_CreatesResponseWithStatus207;
begin
  WebMockResponseStatus := TWebMockResponseStatus.MultiStatus;

  Assert.AreEqual(207, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.NetworkAuthenticationRequired_Always_CreatesResponseWithStatus511;
begin
  WebMockResponseStatus := TWebMockResponseStatus.NetworkAuthenticationRequired;

  Assert.AreEqual(511, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.NetworkConnectTimeoutError_Always_CreatesResponseWithStatus599;
begin
  WebMockResponseStatus := TWebMockResponseStatus.NetworkConnectTimeoutError;

  Assert.AreEqual(599, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.NoContent_Always_CreatesResponseWithStatus204;
begin
  WebMockResponseStatus := TWebMockResponseStatus.NoContent;

  Assert.AreEqual(204, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.NonAuthoritativeInformation_Always_CreatesResponseWithStatus203;
begin
  WebMockResponseStatus := TWebMockResponseStatus.NonAuthoritativeInformation;

  Assert.AreEqual(203, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.NotAcceptable_Always_CreatesResponseWithStatus406;
begin
  WebMockResponseStatus := TWebMockResponseStatus.NotAcceptable;

  Assert.AreEqual(406, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.NotExtended_Always_CreatesResponseWithStatus510;
begin
  WebMockResponseStatus := TWebMockResponseStatus.NotExtended;

  Assert.AreEqual(510, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.NotFound_Always_CreatesResponseWithStatus404;
begin
  WebMockResponseStatus := TWebMockResponseStatus.NotFound;

  Assert.AreEqual(404, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.NotImplemented_Always_CreatesResponseWithStatus501;
begin
  WebMockResponseStatus := TWebMockResponseStatus.NotImplemented;

  Assert.AreEqual(501, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.NotModified_Always_CreatesResponseWithStatus304;
begin
  WebMockResponseStatus := TWebMockResponseStatus.NotModified;

  Assert.AreEqual(304, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.OK_Always_CreatesResponseWithStatus200;
begin
  WebMockResponseStatus := TWebMockResponseStatus.OK;

  Assert.AreEqual(200, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.PartialContent_Always_CreatesResponseWithStatus206;
begin
  WebMockResponseStatus := TWebMockResponseStatus.PartialContent;

  Assert.AreEqual(206, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.PayloadTooLarge_Always_CreatesResponseWithStatus413;
begin
  WebMockResponseStatus := TWebMockResponseStatus.PayloadTooLarge;

  Assert.AreEqual(413, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.PaymentRequired_Always_CreatesResponseWithStatus402;
begin
  WebMockResponseStatus := TWebMockResponseStatus.PaymentRequired;

  Assert.AreEqual(402, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.PermanentRedirect_Always_CreatesResponseWithStatus308;
begin
  WebMockResponseStatus := TWebMockResponseStatus.PermanentRedirect;

  Assert.AreEqual(308, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.PreconditionFailed_Always_CreatesResponseWithStatus412;
begin
  WebMockResponseStatus := TWebMockResponseStatus.PreconditionFailed;

  Assert.AreEqual(412, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.PreconditionRequired_Always_CreatesResponseWithStatus428;
begin
  WebMockResponseStatus := TWebMockResponseStatus.PreconditionRequired;

  Assert.AreEqual(428, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.Processing_Always_CreatesResponseWithStatus102;
begin
  WebMockResponseStatus := TWebMockResponseStatus.Processing;

  Assert.AreEqual(102, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.ProxyAuthenticationRequired_Always_CreatesResponseWithStatus407;
begin
  WebMockResponseStatus := TWebMockResponseStatus.ProxyAuthenticationRequired;

  Assert.AreEqual(407, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.RequestedRangeNotSatisfiable_Always_CreatesResponseWithStatus416;
begin
  WebMockResponseStatus := TWebMockResponseStatus.RequestedRangeNotSatisfiable;

  Assert.AreEqual(416, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.RequestHeaderFieldsTooLarge_Always_CreatesResponseWithStatus431;
begin
  WebMockResponseStatus := TWebMockResponseStatus.RequestHeaderFieldsTooLarge;

  Assert.AreEqual(431, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.RequestTimeout_Always_CreatesResponseWithStatus408;
begin
  WebMockResponseStatus := TWebMockResponseStatus.RequestTimeout;

  Assert.AreEqual(408, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.RequestURITooLong_Always_CreatesResponseWithStatus414;
begin
  WebMockResponseStatus := TWebMockResponseStatus.RequestURITooLong;

  Assert.AreEqual(414, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.ResetContent_Always_CreatesResponseWithStatus205;
begin
  WebMockResponseStatus := TWebMockResponseStatus.ResetContent;

  Assert.AreEqual(205, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.SeeOther_Always_CreatesResponseWithStatus303;
begin
  WebMockResponseStatus := TWebMockResponseStatus.SeeOther;

  Assert.AreEqual(303, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.ServiceUnavailable_Always_CreatesResponseWithStatus503;
begin
  WebMockResponseStatus := TWebMockResponseStatus.ServiceUnavailable;

  Assert.AreEqual(503, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.SwitchingProtocols_Always_CreatesResponseWithStatus101;
begin
  WebMockResponseStatus := TWebMockResponseStatus.SwitchingProtocols;

  Assert.AreEqual(101, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.TemporaryRedirect_Always_CreatesResponseWithStatus307;
begin
  WebMockResponseStatus := TWebMockResponseStatus.TemporaryRedirect;

  Assert.AreEqual(307, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.TooManyRequests_Always_CreatesResponseWithStatus429;
begin
  WebMockResponseStatus := TWebMockResponseStatus.TooManyRequests;

  Assert.AreEqual(429, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.Unauthorized_Always_CreatesResponseWithStatus401;
begin
  WebMockResponseStatus := TWebMockResponseStatus.Unauthorized;

  Assert.AreEqual(401, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.UnavailableForLegalReasons_Always_CreatesResponseWithStatus451;
begin
  WebMockResponseStatus := TWebMockResponseStatus.UnavailableForLegalReasons;

  Assert.AreEqual(451, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.UnprocessableEntity_Always_CreatesResponseWithStatus422;
begin
  WebMockResponseStatus := TWebMockResponseStatus.UnprocessableEntity;

  Assert.AreEqual(422, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.UnsupportedMediaType_Always_CreatesResponseWithStatus415;
begin
  WebMockResponseStatus := TWebMockResponseStatus.UnsupportedMediaType;

  Assert.AreEqual(415, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.UpgradeRequired_Always_CreatesResponseWithStatus426;
begin
  WebMockResponseStatus := TWebMockResponseStatus.UpgradeRequired;

  Assert.AreEqual(426, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.UseProxy_Always_CreatesResponseWithStatus305;
begin
  WebMockResponseStatus := TWebMockResponseStatus.UseProxy;

  Assert.AreEqual(305, WebMockResponseStatus.Code);
end;

procedure TWebMockResponseStatusTests.VariantAlsoNegotiates_Always_CreatesResponseWithStatus506;
begin
  WebMockResponseStatus := TWebMockResponseStatus.VariantAlsoNegotiates;

  Assert.AreEqual(506, WebMockResponseStatus.Code);
end;

initialization
  TDUnitX.RegisterTestFixture(TWebMockResponseStatusTests);
end.
