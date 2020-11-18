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

unit WebMock.Response;

interface

uses
  System.Classes,
  WebMock.ResponseBodySource, WebMock.ResponseStatus;

type
  TWebMockResponse = class(TObject)
  private
    FBodySource: IWebMockResponseBodySource;
    FHeaders: TStringList;
    FStatus: TWebMockResponseStatus;
  public
    constructor Create(const AStatus: TWebMockResponseStatus = nil);
    destructor Destroy; override;
    function ToString: string; override;
    function WithBody(const AContent: string;
      const AContentType: string = 'text/plain; charset=utf-8'): TWebMockResponse;
    function WithBodyFile(const AFileName: string;
      const AContentType: string = ''): TWebMockResponse;
    function WithHeader(AHeaderName, AHeaderValue: string): TWebMockResponse;
    function WithHeaders(AHeaders: TStrings): TWebMockResponse;
    property BodySource: IWebMockResponseBodySource read FBodySource write FBodySource;
    property Headers: TStringList read FHeaders write FHeaders;
    property Status: TWebMockResponseStatus read FStatus write FStatus;
  end;

implementation

{ TWebMockResponse }

uses
  System.SysUtils,
  WebMock.ResponseContentFile, WebMock.ResponseContentString;

constructor TWebMockResponse.Create(const AStatus
  : TWebMockResponseStatus = nil);
begin
  inherited Create;
  FBodySource := TWebMockResponseContentString.Create;
  FHeaders := TStringList.Create;
  if Assigned(AStatus) then
    FStatus := AStatus
  else
    FStatus := TWebMockResponseStatus.OK;
end;

destructor TWebMockResponse.Destroy;
begin
  FHeaders.Free;
  FStatus.Free;
  inherited;
end;

function TWebMockResponse.ToString: string;
begin
  Result := Format('%s', [Status.ToString]);
end;

function TWebMockResponse.WithBody(const AContent: string;
  const AContentType: string = 'text/plain; charset=utf-8'): TWebMockResponse;
begin
  BodySource := TWebMockResponseContentString.Create(AContent, AContentType);

  Result := Self;
end;

function TWebMockResponse.WithBodyFile(const AFileName: string;
  const AContentType: string = ''): TWebMockResponse;
begin
  BodySource := TWebMockResponseContentFile.Create(AFileName, AContentType);

  Result := Self;
end;

function TWebMockResponse.WithHeader(AHeaderName,
  AHeaderValue: string): TWebMockResponse;
begin
  Headers.Values[AHeaderName] := AHeaderValue;

  Result := Self;
end;

function TWebMockResponse.WithHeaders(AHeaders: TStrings): TWebMockResponse;
begin
  Headers.AddStrings(AHeaders);

  Result := Self;
end;

end.
