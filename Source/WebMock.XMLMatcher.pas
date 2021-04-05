unit WebMock.XMLMatcher;

interface

uses
  System.Generics.Collections,
  System.RegularExpressions,
  WebMock.StringMatcher,
  Xml.xmldom,
  Xml.XMLIntf;

type

  IWebMockXMLValueMatcher = interface(IInterface)
    ['{98312A88-8A99-45AE-9189-2A9C69CBF2FA}']
    function IsMatch(const ANode: IDOMDocument): Boolean;
  end;

  TWebMockXMLValueMatcher = class(TInterfacedObject, IWebMockXMLValueMatcher)
  private
    FXPath: string;
    FValueMatcher: IStringMatcher;
  public
    constructor Create(const AXPath, AValue: string); overload;
    constructor Create(const AXPath: string; APattern: TRegEx); overload;
    property XPath: string read FXPath;
    property ValueMatcher: IStringMatcher read FValueMatcher;

    { IWebMockXMLValueMatcher }
    function IsMatch(const ADocument: IDOMDocument): Boolean;
  end;

  TWebMockXMLMatcher = class(TInterfacedObject, IStringMatcher)
  private
    FValueMatchers: TList<IWebMockXMLValueMatcher>;
    function GetValueMatchers: TList<IWebMockXMLValueMatcher>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(const AXPath, AValue: string); overload;
    procedure Add(const AXPath: string; const APattern: TRegEx); overload;
    property ValueMatchers: TList<IWebMockXMLValueMatcher> read GetValueMatchers;

    { IStringMatcher }
    function IsMatch(AValue: string): Boolean;
    function ToString: string; override;
  end;

implementation

uses
  System.SysUtils,
  WebMock.StringRegExMatcher,
  WebMock.StringWildcardMatcher,
  Xml.XMLDoc,
  Xml.omnixmldom;

{ TWebMockXMLMatcher }

procedure TWebMockXMLMatcher.Add(const AXPath, AValue: string);
begin
  ValueMatchers.Add(TWebMockXMLValueMatcher.Create(AXPath, AValue));
end;

procedure TWebMockXMLMatcher.Add(const AXPath: string; const APattern: TRegEx);
begin
  ValueMatchers.Add(TWebMockXMLValueMatcher.Create(AXPath, APattern));
end;

constructor TWebMockXMLMatcher.Create;
begin
  inherited;
  FValueMatchers := TList<IWebMockXMLValueMatcher>.Create;
end;

destructor TWebMockXMLMatcher.Destroy;
begin
  FValueMatchers.Free;
  inherited;
end;

function TWebMockXMLMatcher.GetValueMatchers: TList<IWebMockXMLValueMatcher>;
begin
  Result := FValueMatchers;
end;

function TWebMockXMLMatcher.IsMatch(AValue: string): Boolean;
var
  XMLDoc: IXMLDocument;
  LMatcher: IWebMockXMLValueMatcher;
begin
  DefaultDOMVendor := GetDOMVendor(sOmniXmlVendor).Description;
  XMLDoc := LoadXMLData(AValue);

  for LMatcher in ValueMatchers do
  begin
    if not LMatcher.IsMatch(XMLDoc.DOMDocument) then
      Exit(False);
  end;

  Result := True;
end;

function TWebMockXMLMatcher.ToString: string;
begin
  Result := '<XML>';
end;

{ TWebMockXMLValueMatcher }

constructor TWebMockXMLValueMatcher.Create(const AXPath, AValue: string);
begin
  inherited Create;
  FXPath := AXPath;
  FValueMatcher := TWebMockStringWildcardMatcher.Create(AValue);
end;

constructor TWebMockXMLValueMatcher.Create(const AXPath: string;
  APattern: TRegEx);
begin
  inherited Create;
  FXPath := AXPath;
  FValueMatcher := TWebMockStringRegExMatcher.Create(APattern);
end;

function TWebMockXMLValueMatcher.IsMatch(const ADocument: IDOMDocument): Boolean;
var
  LDOMNodeSelect: IDOMNodeSelect;
  LNode, LValueNode: IDOMNode;
begin
  if not Assigned(ADocument) or not Supports(ADocument, IDOMNodeSelect, LDOMNodeSelect) then
    Exit(False);

  LNode := LDOMNodeSelect.selectNode(XPath);
  if not Assigned(LNode) or not LNode.hasChildNodes then
    Exit(False);

  LValueNode := LNode.childNodes[0];

  Result := ValueMatcher.IsMatch(LValueNode.nodeValue);
end;

end.
