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

unit WebMock.HTTP.Messages;

interface

uses
  System.Classes;

type
  IWebMockHTTPMessage = interface(IInterface)
    ['{04B4BDFB-761E-4E44-8C08-DADF4138C067}']
    function GetStartLine: string;
    function GetHeaders: TStrings;
    function GetBody: TStream;
    property StartLine: string read GetStartLine;
    property Headers: TStrings read GetHeaders;
    property Body: TStream read GetBody;
  end;

  IWebMockHTTPRequest = interface(IWebMockHTTPMessage)
    ['{BE50127E-778C-46C8-B866-96C4124B606F}']
    function GetMethod: string;
    function GetRequestURI: string;
    function GetHTTPVersion: string;
    property RequestLine: string read GetStartLine;
    property Method: string read GetMethod;
    property RequestURI: string read GetRequestURI;
    property HTTPVersion: string read GetHTTPVersion;
  end;

  IWebMockHTTPResponse = interface(IWebMockHTTPMessage)
    ['{C643273B-78EB-4BB8-9DA1-F256FA715BF1}']
    function GetHTTPVersion: string;
    function GetStatusCode: Integer;
    function GetReasonPhrase: string;
    property StatusLine: string read GetStartLine;
    property HTTPVersion: string read GetHTTPVersion;
    property StatusCode: Integer read GetStatusCode;
    property ReasonPhrase: string read GetReasonPhrase;
  end;

implementation

end.
