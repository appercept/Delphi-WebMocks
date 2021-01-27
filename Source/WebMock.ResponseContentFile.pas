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

unit WebMock.ResponseContentFile;

interface

uses IdCustomHTTPServer, System.Classes, WebMock.ResponseBodySource;

type
  TWebMockResponseContentFile = class(TInterfacedObject, IWebMockResponseBodySource)
  private
    FContentStream: TStream;
    FContentType: string;

    class var FMIMETable: TIdThreadSafeMimeTable;
    class constructor Create;
    class destructor Destroy;

    function GetContentStream: TStream;
    function GetContentType: string;
    function InferContentType(const AFileName: string): string;
    procedure LoadContentFromFile(const AFileName: string);
  public
    constructor Create(const AFileName: string; const AContentType: string = '');
    destructor Destroy; override;
    property ContentStream: TStream read GetContentStream;
    property ContentType: string read GetContentType;
  end;

implementation

uses
  System.SysUtils;

{ TWebMockResponseContentFile }

constructor TWebMockResponseContentFile.Create(const AFileName: string; const AContentType: string = '');
begin
  inherited Create;
  FContentStream := TMemoryStream.Create;
  LoadContentFromFile(AFileName);
  if AContentType.IsEmpty then
    FContentType := InferContentType(AFileName)
  else
    FContentType := AContentType;
end;

destructor TWebMockResponseContentFile.Destroy;
begin
  FContentStream.Free;
  inherited;
end;

class constructor TWebMockResponseContentFile.Create;
begin
  FMIMETable := TIdThreadSafeMimeTable.Create(False);
end;

class destructor TWebMockResponseContentFile.Destroy;
begin
  FMIMETable.Free;
end;

function TWebMockResponseContentFile.GetContentStream: TStream;
var
  LContentStream: TMemoryStream;
begin
  LContentStream := TMemoryStream.Create;
  LContentStream.CopyFrom(FContentStream, 0);
  Result := LContentStream;
end;

function TWebMockResponseContentFile.GetContentType: string;
begin
  Result := FContentType;
end;

function TWebMockResponseContentFile.InferContentType(const AFileName: string): string;
begin
  Result := FMIMETable.GetFileMIMEType(AFileName);
end;

procedure TWebMockResponseContentFile.LoadContentFromFile(
  const AFileName: string);
var
  LFileStream: TFileStream;
begin
  if not FileExists(AFileName) then
    Exit;

  LFileStream := TFileStream.Create(AFileName, fmOpenRead);
  FContentStream.CopyFrom(LFileStream, 0);
  LFileStream.Free;
end;

end.
