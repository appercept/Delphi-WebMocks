﻿{******************************************************************************}
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

unit WebMock.HTTP.Request;

interface

uses
  IdCustomHTTPServer,
  IdHeaderList,
  System.Classes,
  WebMock.HTTP.Messages;

type
  TWebMockHTTPRequest = class(TInterfacedObject, IWebMockHTTPRequest)
  private
    FBody: TStream;
    FHeaders: TStringList;
    FHTTPVersion: string;
    FMethod: string;
    FStartLine: string;
    FRequestURI: string;
    function CloneHeaders(AHeaders: TIdHeaderList): TStringList;
  public
    constructor Create(ARequestInfo: TIdHTTPRequestInfo);
    destructor Destroy; override;
    function GetStartLine: string;
    function GetMethod: string;
    function GetRequestURI: string;
    function GetHTTPVersion: string;
    function GetHeaders: TStrings;
    function GetBody: TStream;
    property Body: TStream read GetBody;
    property Headers: TStrings read GetHeaders;
    property HTTPVersion: string read GetHTTPVersion;
    property Method: string read GetMethod;
    property StartLine: string read GetStartLine;
    property RequestLine: string read GetStartLine;
    property RequestURI: string read GetRequestURI;
  end;

implementation

{ TWebMockHTTPRequest }

function TWebMockHTTPRequest.CloneHeaders(AHeaders: TIdHeaderList): TStringList;
begin
  Result := TStringList.Create;
  AHeaders.ConvertToStdValues(Result);
end;

constructor TWebMockHTTPRequest.Create(ARequestInfo: TIdHTTPRequestInfo);
begin
  inherited Create;
  if Assigned(ARequestInfo.PostStream) then
  begin
    FBody := TMemoryStream.Create;
    Body.CopyFrom(ARequestInfo.PostStream, 0);
  end;
  FHeaders := CloneHeaders(ARequestInfo.RawHeaders);
  FHTTPVersion := ARequestInfo.Version;
  FMethod := ARequestInfo.Command;
  FRequestURI := ARequestInfo.URI;
  FStartLine := ARequestInfo.RawHTTPCommand;
end;

destructor TWebMockHTTPRequest.Destroy;
begin
  FBody.Free;
  FHeaders.Free;
  inherited;
end;

function TWebMockHTTPRequest.GetBody: TStream;
begin
  Result := FBody;
end;

function TWebMockHTTPRequest.GetHeaders: TStrings;
begin
  Result := FHeaders;
end;

function TWebMockHTTPRequest.GetHTTPVersion: string;
begin
  Result := FHTTPVersion;
end;

function TWebMockHTTPRequest.GetMethod: string;
begin
  Result := FMethod;
end;

function TWebMockHTTPRequest.GetRequestURI: string;
begin
  Result := FRequestURI;
end;

function TWebMockHTTPRequest.GetStartLine: string;
begin
  Result := FStartLine;
end;

end.
