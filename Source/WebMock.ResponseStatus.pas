{******************************************************************************}
{                                                                              }
{           Delphi-WebMocks                                                    }
{                                                                              }
{           Copyright (c) 2019-2020 Richard Hatherall                          }
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

unit WebMock.ResponseStatus;

interface

type
  TWebMockResponseStatusCode = (
    Continue = 100,
    SwitchingProtocols = 101,
    Processing = 102,

    OK = 200,
    Created = 201,
    Accepted = 202,
    NonAuthoritativeInformation = 203,
    NoContent = 204,
    ResetContent = 205,
    PartialContent = 206,
    MultiStatus = 207,
    AlreadyReported = 208,
    IMUsed = 209,

    MultipleChoices = 300,
    MovedPermanently =  301,
    Found = 302,
    SeeOther = 303,
    NotModified = 304,
    UseProxy = 305,
    TemporaryRedirect = 307,
    PermanentRedirect = 308,

    BadRequest = 400,
    Unauthorized = 401,
    PaymentRequired = 402,
    Forbidden = 403,
    NotFound = 404,
    MethodNotAllowed = 405,
    NotAcceptable = 406,
    ProxyAuthenticationRequired = 407,
    RequestTimeout = 408,
    Conflict = 409,
    Gone = 410,
    LengthRequired = 411,
    PreconditionFailed = 412,
    PayloadTooLarge = 413,
    RequestURITooLong = 414,
    UnsupportedMediaType = 415,
    RequestedRangeNotSatisfiable = 416,
    ExpectationFailed = 417,
    ImATeapot = 418,
    MisdirectedRequest = 421,
    UnprocessableEntity = 422,
    Locked = 423,
    FailedDependency = 424,
    UpgradeRequired = 426,
    PreconditionRequired = 428,
    TooManyRequests = 429,
    RequestHeaderFieldsTooLarge = 431,
    UnavailableForLegalReasons = 451,

    InternalServerError = 500,
    NotImplemented = 501,
    BadGateway = 502,
    ServiceUnavailable = 503,
    GatewayTimeout = 504,
    HTTPVersionNotSupported = 505,
    VariantAlsoNegotiates = 506,
    InsufficientStorage = 507,
    LoopDetected = 508,
    NotExtended = 510,
    NetworkAuthenticationRequired = 511,
    NetworkConnectTimeoutError = 599
  );

  TWebMockResponseStatus = record
    Code: Integer;
    Text: string;
  public
    constructor Create(const ACode: Integer; const AText: string);
    function ToString: string;

    class operator Implicit(const ACode: Integer): TWebMockResponseStatus;
    class operator Implicit(const ACode: TWebMockResponseStatusCode): TWebMockResponseStatus;
    class operator Implicit(const AResponseStatus: TWebMockResponseStatus): string;

    // Informational
    class function Continue: TWebMockResponseStatus; static;
    class function SwitchingProtocols: TWebMockResponseStatus; static;
    class function Processing: TWebMockResponseStatus; static;

    // Success
    class function OK: TWebMockResponseStatus; static;
    class function Created: TWebMockResponseStatus; static;
    class function Accepted: TWebMockResponseStatus; static;
    class function NonAuthoritativeInformation: TWebMockResponseStatus; static;
    class function NoContent: TWebMockResponseStatus; static;
    class function ResetContent: TWebMockResponseStatus; static;
    class function PartialContent: TWebMockResponseStatus; static;
    class function MultiStatus: TWebMockResponseStatus; static;
    class function AlreadyReported: TWebMockResponseStatus; static;
    class function IMUsed: TWebMockResponseStatus; static;

    // Redirection
    class function MultipleChoices: TWebMockResponseStatus; static;
    class function MovedPermanently: TWebMockResponseStatus; static;
    class function Found: TWebMockResponseStatus; static;
    class function SeeOther: TWebMockResponseStatus; static;
    class function NotModified: TWebMockResponseStatus; static;
    class function UseProxy: TWebMockResponseStatus; static;
    class function TemporaryRedirect: TWebMockResponseStatus; static;
    class function PermanentRedirect: TWebMockResponseStatus; static;

    // Client Error
    class function BadRequest: TWebMockResponseStatus; static;
    class function Unauthorized: TWebMockResponseStatus; static;
    class function PaymentRequired: TWebMockResponseStatus; static;
    class function Forbidden: TWebMockResponseStatus; static;
    class function NotFound: TWebMockResponseStatus; static;
    class function MethodNotAllowed: TWebMockResponseStatus; static;
    class function NotAcceptable: TWebMockResponseStatus; static;
    class function ProxyAuthenticationRequired: TWebMockResponseStatus; static;
    class function RequestTimeout: TWebMockResponseStatus; static;
    class function Conflict: TWebMockResponseStatus; static;
    class function Gone: TWebMockResponseStatus; static;
    class function LengthRequired: TWebMockResponseStatus; static;
    class function PreconditionFailed: TWebMockResponseStatus; static;
    class function PayloadTooLarge: TWebMockResponseStatus; static;
    class function RequestURITooLong: TWebMockResponseStatus; static;
    class function UnsupportedMediaType: TWebMockResponseStatus; static;
    class function RequestedRangeNotSatisfiable: TWebMockResponseStatus; static;
    class function ExpectationFailed: TWebMockResponseStatus; static;
    class function ImATeapot: TWebMockResponseStatus; static;
    class function MisdirectedRequest: TWebMockResponseStatus; static;
    class function UnprocessableEntity: TWebMockResponseStatus; static;
    class function Locked: TWebMockResponseStatus; static;
    class function FailedDependency: TWebMockResponseStatus; static;
    class function UpgradeRequired: TWebMockResponseStatus; static;
    class function PreconditionRequired: TWebMockResponseStatus; static;
    class function TooManyRequests: TWebMockResponseStatus; static;
    class function RequestHeaderFieldsTooLarge: TWebMockResponseStatus; static;
    class function UnavailableForLegalReasons: TWebMockResponseStatus; static;

    // Server Error
    class function InternalServerError: TWebMockResponseStatus; static;
    class function NotImplemented: TWebMockResponseStatus; static;
    class function BadGateway: TWebMockResponseStatus; static;
    class function ServiceUnavailable: TWebMockResponseStatus; static;
    class function GatewayTimeout: TWebMockResponseStatus; static;
    class function HTTPVersionNotSupported: TWebMockResponseStatus; static;
    class function VariantAlsoNegotiates: TWebMockResponseStatus; static;
    class function InsufficientStorage: TWebMockResponseStatus; static;
    class function LoopDetected: TWebMockResponseStatus; static;
    class function NotExtended: TWebMockResponseStatus; static;
    class function NetworkAuthenticationRequired: TWebMockResponseStatus; static;
    class function NetworkConnectTimeoutError: TWebMockResponseStatus; static;
  end;


implementation

{ TWebMockResponseStatus }

uses
  System.SysUtils;

class function TWebMockResponseStatus.Accepted: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(202, '');
end;

class function TWebMockResponseStatus.AlreadyReported: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(208, '');
end;

class function TWebMockResponseStatus.BadGateway: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(502, '');
end;

class function TWebMockResponseStatus.BadRequest: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(400, '');
end;

class function TWebMockResponseStatus.Conflict: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(409, '');
end;

class function TWebMockResponseStatus.Continue: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(100, '');
end;

constructor TWebMockResponseStatus.Create(const ACode: Integer;
  const AText: string);
begin
  Code := ACode;
  Text := AText;
end;

class function TWebMockResponseStatus.Created: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(201, '');
end;

class function TWebMockResponseStatus.ExpectationFailed: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(417, '');
end;

class function TWebMockResponseStatus.FailedDependency: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(424, '');
end;

class function TWebMockResponseStatus.Forbidden: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(403, '');
end;

class function TWebMockResponseStatus.Found: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(302, '');
end;

class function TWebMockResponseStatus.GatewayTimeout: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(504, '');
end;

class function TWebMockResponseStatus.Gone: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(410, '');
end;

class function TWebMockResponseStatus.VariantAlsoNegotiates: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(506, '');
end;

class function TWebMockResponseStatus.HTTPVersionNotSupported: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(505, '');
end;

class function TWebMockResponseStatus.ImATeapot: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(418, '');
end;

class operator TWebMockResponseStatus.Implicit(
  const AResponseStatus: TWebMockResponseStatus): string;
begin
  Result := AResponseStatus.ToString;
end;

class operator TWebMockResponseStatus.Implicit(
  const ACode: TWebMockResponseStatusCode): TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(Ord(ACode), '');
end;

class operator TWebMockResponseStatus.Implicit(
  const ACode: Integer): TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(ACode, '');
end;

class function TWebMockResponseStatus.IMUsed: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(226, '');
end;

class function TWebMockResponseStatus.InsufficientStorage: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(507, '');
end;

class function TWebMockResponseStatus.InternalServerError: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(500, '');
end;

class function TWebMockResponseStatus.LengthRequired: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(411, '');
end;

class function TWebMockResponseStatus.Locked: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(423, '');
end;

class function TWebMockResponseStatus.LoopDetected: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(508, '');
end;

class function TWebMockResponseStatus.MethodNotAllowed: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(405, '');
end;

class function TWebMockResponseStatus.MisdirectedRequest: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(421, '');
end;

class function TWebMockResponseStatus.MovedPermanently: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(301, '');
end;

class function TWebMockResponseStatus.MultipleChoices: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(300, '');
end;

class function TWebMockResponseStatus.MultiStatus: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(207, '');
end;

class function TWebMockResponseStatus.NetworkAuthenticationRequired: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(511, '');
end;

class function TWebMockResponseStatus.NetworkConnectTimeoutError: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(599, '');
end;

class function TWebMockResponseStatus.NoContent: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(204, '');
end;

class function TWebMockResponseStatus.NonAuthoritativeInformation: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(203, '');
end;

class function TWebMockResponseStatus.NotAcceptable: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(406, '');
end;

class function TWebMockResponseStatus.NotExtended: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(510, '');
end;

class function TWebMockResponseStatus.NotFound: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(404, '');
end;

class function TWebMockResponseStatus.NotImplemented: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(501, '');
end;

class function TWebMockResponseStatus.NotModified: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(304, '');
end;

class function TWebMockResponseStatus.OK: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(200, '');
end;

class function TWebMockResponseStatus.PartialContent: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(206, '');
end;

class function TWebMockResponseStatus.PayloadTooLarge: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(413, '');
end;

class function TWebMockResponseStatus.PaymentRequired: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(402, '');
end;

class function TWebMockResponseStatus.PermanentRedirect: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(308, '');
end;

class function TWebMockResponseStatus.PreconditionFailed: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(412, '');
end;

class function TWebMockResponseStatus.PreconditionRequired: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(428, '');
end;

class function TWebMockResponseStatus.Processing: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(102, '');
end;

class function TWebMockResponseStatus.ProxyAuthenticationRequired: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(407, '');
end;

class function TWebMockResponseStatus.RequestHeaderFieldsTooLarge: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(431, '');
end;

class function TWebMockResponseStatus.RequestedRangeNotSatisfiable: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(416, '');
end;

class function TWebMockResponseStatus.RequestTimeout: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(408, '');
end;

class function TWebMockResponseStatus.RequestURITooLong: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(414, '');
end;

class function TWebMockResponseStatus.ResetContent: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(205, '');
end;

class function TWebMockResponseStatus.SeeOther: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(303, '');
end;

class function TWebMockResponseStatus.ServiceUnavailable: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(503, '');
end;

class function TWebMockResponseStatus.SwitchingProtocols: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(101, '');
end;

class function TWebMockResponseStatus.TemporaryRedirect: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(307, '');
end;

class function TWebMockResponseStatus.TooManyRequests: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(429, '');
end;

function TWebMockResponseStatus.ToString: string;
begin
  Result := Format('%d %s', [Code, Text]);
end;

class function TWebMockResponseStatus.Unauthorized: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(401, '');
end;

class function TWebMockResponseStatus.UnavailableForLegalReasons: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(451, '');
end;

class function TWebMockResponseStatus.UnprocessableEntity: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(422, '');
end;

class function TWebMockResponseStatus.UnsupportedMediaType: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(415, '');
end;

class function TWebMockResponseStatus.UpgradeRequired: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(426, '');
end;

class function TWebMockResponseStatus.UseProxy: TWebMockResponseStatus;
begin
  Result := TWebMockResponseStatus.Create(305, '');
end;

end.
