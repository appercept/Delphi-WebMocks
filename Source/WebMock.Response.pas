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

unit WebMock.Response;

interface

uses
  System.Classes,
  WebMock.HTTP.Messages,
  WebMock.ResponseBodySource,
  WebMock.ResponseStatus;

type
  IWebMockResponseBuilder = interface(IInterface)
    ['{7F071795-E710-44B6-B799-4BE03ADC954F}']
    function WithBody(const AContent: string;
      const AContentType: string = 'text/plain; charset=utf-8'): IWebMockResponseBuilder;
    function WithBodyFile(const AFileName: string;
      const AContentType: string = ''): IWebMockResponseBuilder;
    function WithHeader(const AHeaderName, AHeaderValue: string): IWebMockResponseBuilder;
    function WithHeaders(const AHeaders: TStrings): IWebMockResponseBuilder;
    function WithStatus(const AStatus: TWebMockResponseStatus): IWebMockResponseBuilder; overload;
    function WithStatus(const AStatusCode: Integer; const AStatusText: string = ''): IWebMockResponseBuilder; overload;
  end;

  TWebMockResponse = class(TInterfacedObject, IWebMockResponseBuilder)
  private type

    TBuilder = class(TInterfacedObject, IWebMockResponseBuilder)
    private
      FResponse: TWebMockResponse;
    public
      constructor Create(const AResponse: TWebMockResponse);
      function WithBody(const AContent: string;
        const AContentType: string = 'text/plain; charset=utf-8'): IWebMockResponseBuilder;
      function WithBodyFile(const AFileName: string;
        const AContentType: string = ''): IWebMockResponseBuilder;
      function WithHeader(const AHeaderName, AHeaderValue: string): IWebMockResponseBuilder;
      function WithHeaders(const AHeaders: TStrings): IWebMockResponseBuilder;
      function WithStatus(const AStatus: TWebMockResponseStatus): IWebMockResponseBuilder; overload;
      function WithStatus(const AStatusCode: Integer; const AStatusText: string = ''): IWebMockResponseBuilder; overload;
      property Response: TWebMockResponse read FResponse;
    end;

  private
    FBuilder: IWebMockResponseBuilder;
    FBodySource: IWebMockResponseBodySource;
    FHeaders: TStringList;
    FStatus: TWebMockResponseStatus;
  public
    constructor Create(const AStatus: TWebMockResponseStatus = nil);
    destructor Destroy; override;
    function ToString: string; override;
    property Builder: IWebMockResponseBuilder read FBuilder implements IWebMockResponseBuilder;
    property BodySource: IWebMockResponseBodySource read FBodySource write FBodySource;
    property Headers: TStringList read FHeaders write FHeaders;
    property Status: TWebMockResponseStatus read FStatus write FStatus;
  end;

implementation

{ TWebMockResponse }

uses
  System.SysUtils,
  WebMock.ResponseContentFile,
  WebMock.ResponseContentString;

constructor TWebMockResponse.Create(const AStatus
  : TWebMockResponseStatus = nil);
begin
  inherited Create;
  FBuilder := TBuilder.Create(Self);
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

{ TWebMockResponse.TBuilder }

constructor TWebMockResponse.TBuilder.Create(const AResponse: TWebMockResponse);
begin
  inherited Create;
  FResponse := AResponse;
end;

function TWebMockResponse.TBuilder.WithBody(const AContent,
  AContentType: string): IWebMockResponseBuilder;
begin
  Response.BodySource := TWebMockResponseContentString.Create(AContent, AContentType);

  Result := Self;
end;


function TWebMockResponse.TBuilder.WithBodyFile(const AFileName,
  AContentType: string): IWebMockResponseBuilder;
begin
  Response.BodySource := TWebMockResponseContentFile.Create(AFileName, AContentType);

  Result := Self;
end;


function TWebMockResponse.TBuilder.WithHeader(const AHeaderName,
  AHeaderValue: string): IWebMockResponseBuilder;
begin
  Response.Headers.Values[AHeaderName] := AHeaderValue;

  Result := Self;
end;


function TWebMockResponse.TBuilder.WithHeaders(
  const AHeaders: TStrings): IWebMockResponseBuilder;
begin
  Response.Headers.AddStrings(AHeaders);

  Result := Self;
end;

function TWebMockResponse.TBuilder.WithStatus(const AStatusCode: Integer;
  const AStatusText: string = ''): IWebMockResponseBuilder;
begin
  Response.Status := TWebMockResponseStatus.Create(AStatusCode, AStatusText);

  Result := Self;
end;

function TWebMockResponse.TBuilder.WithStatus(
  const AStatus: TWebMockResponseStatus): IWebMockResponseBuilder;
begin
  Response.Status := AStatus;

  Result := Self;
end;

end.
