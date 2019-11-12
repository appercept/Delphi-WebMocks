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

unit Delphi.WebMock.RequestStub;

interface

uses
  Delphi.WebMock.HTTP.RequestMatcher, Delphi.WebMock.Response,
  Delphi.WebMock.ResponseStatus,
  IdCustomHTTPServer,
  System.Classes, System.Generics.Collections, System.RegularExpressions;

type
  TWebMockRequestStub = class(TObject)
  private
    FMatcher: TWebMockHTTPRequestMatcher;
    FResponse: TWebMockResponse;
  public
    constructor Create(AMatcher: TWebMockHTTPRequestMatcher);
    destructor Destroy; override;
    function ToString: string; override;
    function ToRespond(AResponseStatus: TWebMockResponseStatus = nil)
      : TWebMockResponse;
    function WithBody(const AContent: string): TWebMockRequestStub; overload;
    function WithBody(const APattern: TRegEx): TWebMockRequestStub; overload;
    /// <summary>
    ///   Works with TMultipartFormData Fields
    /// </summary>
    /// <example>
    ///   <code lang="Delphi">// FogBugz submission
    /// WebMock.StubRequest('POST', '/api')
    ///     .WithBody('cmd', 'new')
    ///     .ToRespond.WithBody('&lt;?xml version="1.0" encoding="UTF-8"?&gt;&lt;response&gt;&lt;case ixBug="459" operations="edit,spam,assign,resolve"&gt;&lt;/case&gt;&lt;/response&gt;');</code>
    /// </example>
    function WithBody(const ADataName, ADataValue: string): TWebMockRequestStub; overload;
    function WithHeader(AName, AValue: string): TWebMockRequestStub; overload;
    function WithHeader(AName: string; APattern: TRegEx) : TWebMockRequestStub; overload;
    function WithHeaders(AHeaders: TStringList): TWebMockRequestStub;
    property Matcher: TWebMockHTTPRequestMatcher read FMatcher;
    property Response: TWebMockResponse read FResponse write FResponse;
  end;

implementation

uses
  Delphi.WebMock.StringWildcardMatcher, Delphi.WebMock.StringRegExMatcher,
  System.SysUtils;

{ TWebMockRequestStub }

constructor TWebMockRequestStub.Create(AMatcher: TWebMockHTTPRequestMatcher);
begin
  inherited Create;
  FMatcher := AMatcher;
  FResponse := TWebMockResponse.Create;
end;

destructor TWebMockRequestStub.Destroy;

begin
  FResponse.Free;
  FMatcher.Free;
  inherited;
end;

function TWebMockRequestStub.ToRespond(
  AResponseStatus: TWebMockResponseStatus = nil): TWebMockResponse;
begin
  if Assigned(AResponseStatus) then
    Response.Status := AResponseStatus;

  Result := Response;
end;

function TWebMockRequestStub.ToString: string;
begin
  Result := Format('%s' + ^I + '%s', [Matcher.ToString, Response.ToString]);
end;

function TWebMockRequestStub.WithHeader(AName, AValue: string): TWebMockRequestStub;
begin
  Matcher.Headers.AddOrSetValue(
    AName,
    TWebMockStringWildcardMatcher.Create(AValue)
  );

  Result := Self;
end;

function TWebMockRequestStub.WithBody(
  const AContent: string): TWebMockRequestStub;
begin
  Matcher.Body := TWebMockStringWildcardMatcher.Create(AContent);

  Result := Self;
end;

function TWebMockRequestStub.WithBody(
  const APattern: TRegEx): TWebMockRequestStub;
begin
  Matcher.Body := TWebMockStringRegExMatcher.Create(APattern);

  Result := Self;
end;

function TWebMockRequestStub.WithBody(const ADataName, ADataValue: string): TWebMockRequestStub;
var LValue: string;
begin
  LValue := 'form-data; name="%s"' + sLineBreak + sLineBreak + '%s' + sLineBreak;
  LValue := Format(LValue, [ADataName, ADataValue]);
  WithBody(TRegEx.Create(LValue));
end;

function TWebMockRequestStub.WithHeader(AName: string;
  APattern: TRegEx): TWebMockRequestStub;
begin
  Matcher.Headers.AddOrSetValue(
    AName,
    TWebMockStringRegExMatcher.Create(APattern)
  );

  Result := Self;
end;

function TWebMockRequestStub.WithHeaders(AHeaders: TStringList): TWebMockRequestStub;
var
  I: Integer;
begin
  for I := 0 to AHeaders.Count - 1 do
    WithHeader(AHeaders.Names[I], AHeaders.ValueFromIndex[I]);

  Result := Self;
end;

end.
