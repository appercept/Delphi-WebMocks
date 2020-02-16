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

unit Delphi.WebMock.Static.RequestStub;

interface

uses
  Delphi.WebMock.HTTP.Messages, Delphi.WebMock.HTTP.RequestMatcher,
  Delphi.WebMock.RequestStub, Delphi.WebMock.Response,
  Delphi.WebMock.ResponseStatus,
  IdCustomHTTPServer,
  System.Classes, System.Generics.Collections, System.RegularExpressions;

type
  TWebMockStaticRequestStub = class(TInterfacedObject, IWebMockRequestStub)
  private
    FMatcher: TWebMockHTTPRequestMatcher;
    FResponse: TWebMockResponse;
  public
    constructor Create(AMatcher: TWebMockHTTPRequestMatcher);
    destructor Destroy; override;
    function ToRespond(AResponseStatus: TWebMockResponseStatus = nil)
      : TWebMockResponse;
    function WithBody(const AContent: string): TWebMockStaticRequestStub; overload;
    function WithBody(const APattern: TRegEx): TWebMockStaticRequestStub; overload;
    function WithHeader(AName, AValue: string): TWebMockStaticRequestStub; overload;
    function WithHeader(AName: string; APattern: TRegEx)
      : TWebMockStaticRequestStub; overload;
    function WithHeaders(AHeaders: TStringList): TWebMockStaticRequestStub;

    // IWebMockRequestStub
    function IsMatch(ARequest: IWebMockHTTPRequest): Boolean;
    function GetResponse: TWebMockResponse;
    procedure SetResponse(const AResponse: TWebMockResponse);
    function ToString: string; override;
    property Response: TWebMockResponse read GetResponse write SetResponse;

    property Matcher: TWebMockHTTPRequestMatcher read FMatcher;
  end;

implementation

uses
  Delphi.WebMock.StringWildcardMatcher, Delphi.WebMock.StringRegExMatcher,
  System.SysUtils;

{ TWebMockRequestStub }

constructor TWebMockStaticRequestStub.Create(AMatcher: TWebMockHTTPRequestMatcher);
begin
  inherited Create;
  FMatcher := AMatcher;
  FResponse := TWebMockResponse.Create;
end;

destructor TWebMockStaticRequestStub.Destroy;

begin
  FResponse.Free;
  FMatcher.Free;
  inherited;
end;

function TWebMockStaticRequestStub.GetResponse: TWebMockResponse;
begin
  Result := FResponse;
end;

function TWebMockStaticRequestStub.IsMatch(
  ARequest: IWebMockHTTPRequest): Boolean;
begin
  Result := Matcher.IsMatch(ARequest);
end;

procedure TWebMockStaticRequestStub.SetResponse(
  const AResponse: TWebMockResponse);
begin

end;

function TWebMockStaticRequestStub.ToRespond(
  AResponseStatus: TWebMockResponseStatus = nil): TWebMockResponse;
begin
  if Assigned(AResponseStatus) then
    Response.Status := AResponseStatus;

  Result := Response;
end;

function TWebMockStaticRequestStub.ToString: string;
begin
  Result := Format('%s' + ^I + '%s', [Matcher.ToString, Response.ToString]);
end;

function TWebMockStaticRequestStub.WithHeader(AName, AValue: string): TWebMockStaticRequestStub;
begin
  Matcher.Headers.AddOrSetValue(
    AName,
    TWebMockStringWildcardMatcher.Create(AValue)
  );

  Result := Self;
end;

function TWebMockStaticRequestStub.WithBody(
  const AContent: string): TWebMockStaticRequestStub;
begin
  Matcher.Body := TWebMockStringWildcardMatcher.Create(AContent);

  Result := Self;
end;

function TWebMockStaticRequestStub.WithBody(
  const APattern: TRegEx): TWebMockStaticRequestStub;
begin
  Matcher.Body := TWebMockStringRegExMatcher.Create(APattern);

  Result := Self;
end;

function TWebMockStaticRequestStub.WithHeader(AName: string;
  APattern: TRegEx): TWebMockStaticRequestStub;
begin
  Matcher.Headers.AddOrSetValue(
    AName,
    TWebMockStringRegExMatcher.Create(APattern)
  );

  Result := Self;
end;

function TWebMockStaticRequestStub.WithHeaders(AHeaders: TStringList): TWebMockStaticRequestStub;
var
  I: Integer;
begin
  for I := 0 to AHeaders.Count - 1 do
    WithHeader(AHeaders.Names[I], AHeaders.ValueFromIndex[I]);

  Result := Self;
end;

end.
