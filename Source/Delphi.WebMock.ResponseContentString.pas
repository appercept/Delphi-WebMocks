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

unit Delphi.WebMock.ResponseContentString;

interface

uses Delphi.WebMock.ResponseBodySource, System.Classes;

type
  TWebMockResponseContentString = class(TInterfacedObject,
    IWebMockResponseBodySource)
  private
    FContentString: string;
    FContentType: string;
    procedure SetContentType(const Value: string);
    function GetContentStream: TStream;
  public
    constructor Create(const AContentString: string = '';
      const AContentType: string = 'text/plain; charset=utf-8');
    function GetContentString: string;
    function GetContentType: string;
    property ContentStream: TStream read GetContentStream;
    property ContentString: string read GetContentString write FContentString;
    property ContentType: string read GetContentType write SetContentType;
  end;

implementation

{ TWebMockResponseContentString }

constructor TWebMockResponseContentString.Create(const AContentString
  : string = ''; const AContentType: string = 'text/plain; charset=utf-8');
begin
  inherited Create;
  FContentString := AContentString;
  FContentType := AContentType;
end;

function TWebMockResponseContentString.GetContentType: string;
begin
  Result := FContentType;
end;

procedure TWebMockResponseContentString.SetContentType(const Value: string);
begin
  FContentType := Value;
end;

function TWebMockResponseContentString.GetContentStream: TStream;
begin
  Result := TStringStream.Create(ContentString);
end;

function TWebMockResponseContentString.GetContentString: string;
begin
  Result := FContentString;
end;

end.
