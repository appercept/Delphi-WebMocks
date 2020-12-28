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
  System.Generics.Collections,
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

  IWebMockHeaders = interface(IInterface)
    ['{C48A79A4-D42A-4BE0-9531-2BD8D6B93B39}']
    function GetEnumerator: TDictionary<string, string>.TPairEnumerator;
    function GetCount: Integer;
    property Count: Integer read GetCount;
    function GetHeader(const AName: string): string;
    procedure SetHeader(const AName, AValue: string);
    property Values[const Name: string]: string read GetHeader write SetHeader; default;
  end;

  TWebMockHeaders = class(TInterfacedObject, IWebMockHeaders)
  private
    FValues: TDictionary<string, string>;
  public
    constructor Create;
    destructor Destroy; override;

    { IEnumerable }
    function GetEnumerator: TDictionary<string, string>.TPairEnumerator;

    { IWebMockHeaders }
    function GetCount: Integer;
    property Count: Integer read GetCount;
    function GetHeader(const AName: string): string;
    procedure SetHeader(const AName, AValue: string);
    property Headers[const Name: string]: string read GetHeader write SetHeader; default;
  end;

  IWebMockResponse = interface(IInterface)
    ['{5139FE36-3737-466E-8120-8E4FA0460EAE}']
    function ToString: string;
    function GetBuilder: IWebMockResponseBuilder;
    property Builder: IWebMockResponseBuilder read GetBuilder;
    function GetBodySource: IWebMockResponseBodySource;
    property BodySource: IWebMockResponseBodySource read GetBodySource;
    function GetHeaders: IWebMockHeaders;
    property Headers: IWebMockHeaders read GetHeaders;
    function GetStatus: TWebMockResponseStatus;
    property Status: TWebMockResponseStatus read GetStatus;
  end;

  TWebMockResponse = class(TInterfacedObject, IWebMockResponse,
    IWebMockResponseBuilder)
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
    FHeaders: IWebMockHeaders;
    FStatus: TWebMockResponseStatus;
  public
    constructor Create; overload;
    constructor Create(const AStatus: TWebMockResponseStatus); overload;
    function ToString: string; override;

    { IWebMockResponse }
    function GetBuilder: IWebMockResponseBuilder;
    property Builder: IWebMockResponseBuilder read GetBuilder implements IWebMockResponseBuilder;
    function GetBodySource: IWebMockResponseBodySource;
    property BodySource: IWebMockResponseBodySource read GetBodySource write FBodySource;
    function GetHeaders: IWebMockHeaders;
    property Headers: IWebMockHeaders read GetHeaders write FHeaders;
    function GetStatus: TWebMockResponseStatus;
    property Status: TWebMockResponseStatus read GetStatus write FStatus;
  end;

implementation

{ TWebMockResponse }

uses
  System.SysUtils,
  WebMock.ResponseContentFile,
  WebMock.ResponseContentString;

constructor TWebMockResponse.Create(const AStatus
  : TWebMockResponseStatus);
begin
  inherited Create;
  FBuilder := TBuilder.Create(Self);
  FBodySource := TWebMockResponseContentString.Create;
  FHeaders := TWebMockHeaders.Create;
  FStatus := AStatus
end;

constructor TWebMockResponse.Create;
begin
  Create(TWebMockResponseStatus.OK);
end;

function TWebMockResponse.GetBodySource: IWebMockResponseBodySource;
begin
  Result := FBodySource;
end;

function TWebMockResponse.GetBuilder: IWebMockResponseBuilder;
begin
  Result := FBuilder;
end;

function TWebMockResponse.GetHeaders: IWebMockHeaders;
begin
  Result := FHeaders;
end;

function TWebMockResponse.GetStatus: TWebMockResponseStatus;
begin
  Result := FStatus;
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
  Response.Headers[AHeaderName] := AHeaderValue;

  Result := Self;
end;


function TWebMockResponse.TBuilder.WithHeaders(
  const AHeaders: TStrings): IWebMockResponseBuilder;
var
  I: Integer;
begin
  for I := 0 to AHeaders.Count - 1 do
    Response.Headers[AHeaders.Names[I]] := AHeaders.ValueFromIndex[I];

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

{ TWebMockHeaders }

constructor TWebMockHeaders.Create;
begin
  inherited;
  FValues := TDictionary<string, string>.Create;
end;

destructor TWebMockHeaders.Destroy;
begin
  FValues.Free;
  inherited;
end;

function TWebMockHeaders.GetCount: Integer;
begin
  Result := FValues.Count;
end;

function TWebMockHeaders.GetEnumerator: TDictionary<string, string>.TPairEnumerator;
begin
  Result := FValues.GetEnumerator;
end;

function TWebMockHeaders.GetHeader(const AName: string): string;
begin
  Result := FValues[AName];
end;

procedure TWebMockHeaders.SetHeader(const AName, AValue: string);
begin
  FValues.AddOrSetValue(AName, AValue);
end;

end.
