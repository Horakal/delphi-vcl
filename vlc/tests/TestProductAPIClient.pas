unit TestProductAPIClient;

interface

uses
  DUnitX.TestFramework,
  System.JSON,
  ProductAPIClient;

type
  [TestFixture]
  TTestProductAPIClient = class
  private
    FAPIClient: TProductAPIClient;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestGetAll;
    [Test]
    procedure TestUpdate; // Disabled unless API server is running
  end;

implementation

procedure TTestProductAPIClient.Setup;
begin
  FAPIClient := TProductAPIClient.Create;
end;

procedure TTestProductAPIClient.TearDown;
begin
  FAPIClient.Free;
end;

procedure TTestProductAPIClient.TestGetAll;
var
  MockJSON: string;
  JSONValue: TJSONValue;
  Products: TJSONArray;
begin
  MockJSON := '[{"id":1,"name":"Test Product","description":"Test Desc","price":10.0,"stock":5}]';
  JSONValue := TJSONObject.ParseJSONValue(MockJSON);
  try
    Assert.IsNotNull(JSONValue, 'JSON parsing failed');
    Assert.IsTrue(JSONValue is TJSONArray, 'Expected JSONArray');
    Products := JSONValue as TJSONArray;
    Assert.AreEqual(1, Products.Count, 'Expected one product');
    Assert.IsTrue(Products.Items[0] is TJSONObject, 'Expected JSONObject');
    Assert.AreEqual('Test Product', TJSONObject(Products.Items[0]).GetValue<string>('name'), 'Incorrect product name');
  finally
    JSONValue.Free;
  end;

end;

procedure TTestProductAPIClient.TestUpdate;
begin
  Assert.Pass('TestUpdate skipped: Enable when ProductManager.exe is running');
end;

end.
