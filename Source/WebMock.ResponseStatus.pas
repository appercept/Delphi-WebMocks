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

unit WebMock.ResponseStatus;

{$WARN DUPLICATE_CTOR_DTOR OFF}

interface

type
  TWebMockResponseStatus = class(TObject)
  private
    FCode: Integer;
    FText: string;
  public
    constructor Create(const ACode: Integer = 0; const AText: string = '');
    function ToString: string; override;

    // Informational Constructors
    constructor Continue;
    constructor SwitchingProtocols;
    constructor Processing;

    // Success Constructors
    constructor OK;
    constructor Created;
    constructor Accepted;
    constructor NonAuthoritativeInformation;
    constructor NoContent;
    constructor ResetContent;
    constructor PartialContent;
    constructor MultiStatus;
    constructor AlreadyReported;
    constructor IMUsed;

    // Redirection Constructors
    constructor MultipleChoices;
    constructor MovedPermanently;
    constructor Found;
    constructor SeeOther;
    constructor NotModified;
    constructor UseProxy;
    constructor TemporaryRedirect;
    constructor PermanentRedirect;

    // Client Error Constructors
    constructor BadRequest;
    constructor Unauthorized;
    constructor PaymentRequired;
    constructor Forbidden;
    constructor NotFound;
    constructor MethodNotAllowed;
    constructor NotAcceptable;
    constructor ProxyAuthenticationRequired;
    constructor RequestTimeout;
    constructor Conflict;
    constructor Gone;
    constructor LengthRequired;
    constructor PreconditionFailed;
    constructor PayloadTooLarge;
    constructor RequestURITooLong;
    constructor UnsupportedMediaType;
    constructor RequestedRangeNotSatisfiable;
    constructor ExpectationFailed;
    constructor ImATeapot;
    constructor MisdirectedRequest;
    constructor UnprocessableEntity;
    constructor Locked;
    constructor FailedDependency;
    constructor UpgradeRequired;
    constructor PreconditionRequired;
    constructor TooManyRequests;
    constructor RequestHeaderFieldsTooLarge;
    constructor UnavailableForLegalReasons;

    // Server Error Constructors
    constructor InternalServerError;
    constructor NotImplemented;
    constructor BadGateway;
    constructor ServiceUnavailable;
    constructor GatewayTimeout;
    constructor HTTPVersionNotSupported;
    constructor VariantAlsoNegotiates;
    constructor InsufficientStorage;
    constructor LoopDetected;
    constructor NotExtended;
    constructor NetworkAuthenticationRequired;
    constructor NetworkConnectTimeoutError;

    property Code: Integer read FCode;
    property Text: string read FText;
  end;

implementation

{ TWebMockResponseStatus }

uses
  System.SysUtils;

constructor TWebMockResponseStatus.Accepted;
begin
  Create(202);
end;

constructor TWebMockResponseStatus.AlreadyReported;
begin
  Create(208);
end;

constructor TWebMockResponseStatus.BadGateway;
begin
  Create(502);
end;

constructor TWebMockResponseStatus.BadRequest;
begin
  Create(400);
end;

constructor TWebMockResponseStatus.Conflict;
begin
  Create(409);
end;

constructor TWebMockResponseStatus.Continue;
begin
  Create(100);
end;

constructor TWebMockResponseStatus.Create(const ACode: Integer = 0;
  const AText: string = '');
begin
  inherited Create;
  FCode := ACode;
  FText := AText;
end;

constructor TWebMockResponseStatus.Created;
begin
  Create(201);
end;

constructor TWebMockResponseStatus.ExpectationFailed;
begin
  Create(417);
end;

constructor TWebMockResponseStatus.FailedDependency;
begin
  Create(424);
end;

constructor TWebMockResponseStatus.Forbidden;
begin
  Create(403);
end;

constructor TWebMockResponseStatus.Found;
begin
  Create(302);
end;

constructor TWebMockResponseStatus.GatewayTimeout;
begin
  Create(504);
end;

constructor TWebMockResponseStatus.Gone;
begin
  Create(410);
end;

constructor TWebMockResponseStatus.VariantAlsoNegotiates;
begin
  Create(506);
end;

constructor TWebMockResponseStatus.HTTPVersionNotSupported;
begin
  Create(505);
end;

constructor TWebMockResponseStatus.ImATeapot;
begin
  Create(418);
end;

constructor TWebMockResponseStatus.IMUsed;
begin
  Create(226);
end;

constructor TWebMockResponseStatus.InsufficientStorage;
begin
  Create(507);
end;

constructor TWebMockResponseStatus.InternalServerError;
begin
  Create(500);
end;

constructor TWebMockResponseStatus.LengthRequired;
begin
  Create(411);
end;

constructor TWebMockResponseStatus.Locked;
begin
  Create(423);
end;

constructor TWebMockResponseStatus.LoopDetected;
begin
  Create(508);
end;

constructor TWebMockResponseStatus.MethodNotAllowed;
begin
  Create(405);
end;

constructor TWebMockResponseStatus.MisdirectedRequest;
begin
  Create(421);
end;

constructor TWebMockResponseStatus.MovedPermanently;
begin
  Create(301);
end;

constructor TWebMockResponseStatus.MultipleChoices;
begin
  Create(300);
end;

constructor TWebMockResponseStatus.MultiStatus;
begin
  Create(207);
end;

constructor TWebMockResponseStatus.NetworkAuthenticationRequired;
begin
  Create(511);
end;

constructor TWebMockResponseStatus.NetworkConnectTimeoutError;
begin
  Create(599);
end;

constructor TWebMockResponseStatus.NoContent;
begin
  Create(204);
end;

constructor TWebMockResponseStatus.NonAuthoritativeInformation;
begin
  Create(203);
end;

constructor TWebMockResponseStatus.NotAcceptable;
begin
  Create(406);
end;

constructor TWebMockResponseStatus.NotExtended;
begin
  Create(510);
end;

constructor TWebMockResponseStatus.NotFound;
begin
  Create(404);
end;

constructor TWebMockResponseStatus.NotImplemented;
begin
  Create(501);
end;

constructor TWebMockResponseStatus.NotModified;
begin
  Create(304);
end;

constructor TWebMockResponseStatus.OK;
begin
  Create(200);
end;

constructor TWebMockResponseStatus.PartialContent;
begin
  Create(206);
end;

constructor TWebMockResponseStatus.PayloadTooLarge;
begin
  Create(413);
end;

constructor TWebMockResponseStatus.PaymentRequired;
begin
  Create(402);
end;

constructor TWebMockResponseStatus.PermanentRedirect;
begin
  Create(308);
end;

constructor TWebMockResponseStatus.PreconditionFailed;
begin
  Create(412);
end;

constructor TWebMockResponseStatus.PreconditionRequired;
begin
  Create(428);
end;

constructor TWebMockResponseStatus.Processing;
begin
  Create(102);
end;

constructor TWebMockResponseStatus.ProxyAuthenticationRequired;
begin
  Create(407);
end;

constructor TWebMockResponseStatus.RequestHeaderFieldsTooLarge;
begin
  Create(431);
end;

constructor TWebMockResponseStatus.RequestedRangeNotSatisfiable;
begin
  Create(416);
end;

constructor TWebMockResponseStatus.RequestTimeout;
begin
  Create(408);
end;

constructor TWebMockResponseStatus.RequestURITooLong;
begin
  Create(414);
end;

constructor TWebMockResponseStatus.ResetContent;
begin
  Create(205);
end;

constructor TWebMockResponseStatus.SeeOther;
begin
  Create(303);
end;

constructor TWebMockResponseStatus.ServiceUnavailable;
begin
  Create(503);
end;

constructor TWebMockResponseStatus.SwitchingProtocols;
begin
  Create(101);
end;

constructor TWebMockResponseStatus.TemporaryRedirect;
begin
  Create(307);
end;

constructor TWebMockResponseStatus.TooManyRequests;
begin
  Create(429);
end;

function TWebMockResponseStatus.ToString: string;
begin
  Result := Format('%d', [Code]);
end;

constructor TWebMockResponseStatus.Unauthorized;
begin
  Create(401);
end;

constructor TWebMockResponseStatus.UnavailableForLegalReasons;
begin
  Create(451);
end;

constructor TWebMockResponseStatus.UnprocessableEntity;
begin
  Create(422);
end;

constructor TWebMockResponseStatus.UnsupportedMediaType;
begin
  Create(415);
end;

constructor TWebMockResponseStatus.UpgradeRequired;
begin
  Create(426);
end;

constructor TWebMockResponseStatus.UseProxy;
begin
  Create(305);
end;

end.
