unit WebMock.XMLValueMatcher.Tests;

interface

uses
  DUnitX.TestFramework,
  WebMock.XMLMatcher;
type
  [TestFixture]
  TWebMockXMLValueMatcherTests = class(TObject)
  public
    [Test]
    procedure Create_Always_RequiresPathAndValue;
    [Test]
    procedure ValueMatcher_WhenInitializedWithStringValue_ReturnsStringMatcher;
    [Test]
    procedure ValueMatcher_WhenInitializedWithPatternValue_ReturnsRegExMatcher;
    [Test]
    procedure IsMatch_MatchingNodeText_ReturnsTrue;
    [Test]
    procedure IsMatch_NotMatchingNodeText_ReturnsFalse;
  end;

implementation

uses
  System.RegularExpressions,
  WebMock.StringRegExMatcher,
  WebMock.StringWildcardMatcher,
  Xml.XMLDoc,
  Xml.xmldom,
  Xml.XMLIntf,
  Xml.omnixmldom;

{ TWebMockXMLValueMatcherTests }

procedure TWebMockXMLValueMatcherTests.Create_Always_RequiresPathAndValue;
var
  LMatcher: TWebMockXMLValueMatcher;
begin
  LMatcher := TWebMockXMLValueMatcher.Create('APath', '*');
  LMatcher.Free;
  Assert.Pass('Create takes path and value');
end;

procedure TWebMockXMLValueMatcherTests.IsMatch_MatchingNodeText_ReturnsTrue;
var
  XMLDoc: IXMLDocument;
  LMatcher: IWebMockXMLValueMatcher;
begin
  DefaultDOMVendor := GetDOMVendor(sOmniXmlVendor).Description;
  XMLDoc := LoadXMLData('<Key>Value</Key>');
  LMatcher := TWebMockXMLValueMatcher.Create('/Key', 'Value');

  Assert.IsTrue(LMatcher.IsMatch(XMLDoc.DOMDocument));
end;

procedure TWebMockXMLValueMatcherTests.IsMatch_NotMatchingNodeText_ReturnsFalse;
var
  XMLDoc: IXMLDocument;
  LMatcher: IWebMockXMLValueMatcher;
begin
  DefaultDOMVendor := GetDOMVendor(sOmniXmlVendor).Description;
  XMLDoc := LoadXMLData('<Key>Other Value</Key>');
  LMatcher := TWebMockXMLValueMatcher.Create('/Key', 'Value');

  Assert.IsFalse(LMatcher.IsMatch(XMLDoc.DOMDocument));
end;

procedure TWebMockXMLValueMatcherTests.ValueMatcher_WhenInitializedWithPatternValue_ReturnsRegExMatcher;
var
  LMatcher: TWebMockXMLValueMatcher;
begin
  LMatcher := TWebMockXMLValueMatcher.Create('/Path', TRegEx.Create('.*'));

  Assert.IsTrue(LMatcher.ValueMatcher is TWebMockStringRegExMatcher);

  LMatcher.Free;
end;

procedure TWebMockXMLValueMatcherTests.ValueMatcher_WhenInitializedWithStringValue_ReturnsStringMatcher;
var
  LMatcher: TWebMockXMLValueMatcher;
begin
  LMatcher := TWebMockXMLValueMatcher.Create('/Path', 'Value');

  Assert.IsTrue(LMatcher.ValueMatcher is TWebMockStringWildcardMatcher);

  LMatcher.Free;
end;

end.
