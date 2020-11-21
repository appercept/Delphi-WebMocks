{******************************************************************************}
{                                                                              }
{           Delphi-WebMocks                                                    }
{                                                                              }
{           Copyright (c) 2020 Richard Hatherall                               }
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

unit WebMock.RequestStub;

interface

uses
  System.Classes,
  System.Net.HttpClient,
  WebMock.HTTP.Messages,
  WebMock.Responder,
  WebMock.Response;

type
  IWebMockRequestStub = interface(IInterface)
    ['{AA474C0C-CA37-44CF-A66A-3B024CC79BE6}']
    function IsMatch(ARequest: IWebMockHTTPRequest): Boolean;
    function GetResponder: IWebMockResponder;
    procedure SetResponder(const AResponder: IWebMockResponder);
    function ToString: string;
    property Responder: IWebMockResponder read GetResponder write SetResponder;
  end;

implementation

end.
