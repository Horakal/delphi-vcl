unit TestProductService;

interface

uses
  DUnitX.TestFramework,
  System.JSON,
  System.SysUtils,
  System.IOUtils,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  ProductService,
  ProductRepository;


type
  [TestFixture]
  TTestProductService = class
  private
    FService: TProductService;
    FConnection: TFDConnection;
    procedure LogToFile(const Msg: string);
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestGetAllProducts;
    [Test]
    procedure TestUpdateProduct;
    [Test]
    procedure TestDeleteProduct;
    [Test]
    procedure TestGetByIdProduct;
  end;

implementation

procedure TTestProductService.LogToFile(const Msg: string);
begin
  TFile.AppendAllText('TestProductService.log', FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ': ' + Msg + sLineBreak);
end;

procedure TTestProductService.Setup;
begin
  LogToFile('Setting SQLite connection');
  FConnection := TFDConnection.Create(nil);
  try
    FConnection.DriverName := 'SQLite';
    FConnection.Params.Add('Database=:memory:');
    FConnection.Connected := True;
    LogToFile('Connection active: ' + BoolToStr(FConnection.Connected, True));
    FConnection.ExecSQL('CREATE TABLE products (id INTEGER PRIMARY KEY, name TEXT, description TEXT, price REAL, stock INTEGER)');
    FConnection.StartTransaction;
    try
      FConnection.ExecSQL('INSERT INTO products (id, name, description, price, stock) VALUES (1, ''Test'', ''Test Desc'', 10.0, 5)');
      FConnection.Commit;
      LogToFile('Inserted test product');
    except
      FConnection.Rollback;
      raise;
    end;
    LogToFile('Creating TProductService');
    FService := TProductService.Create(TProductRepository.Create(FConnection));
    LogToFile('TProductService created');
  except
    on E: Exception do
    begin
      LogToFile('Setup failed: ' + E.ClassName + ': ' + E.Message);
      raise;
    end;
  end;
end;

procedure TTestProductService.TearDown;
begin
  try
    LogToFile('Tearing down TProductService');
    if Assigned(FService) then
      FService.Free;
    LogToFile('Tearing down SQLite connection');
    if Assigned(FConnection) then
      FConnection.Free;
    LogToFile('TearDown complete');
  except
    on E: Exception do
    begin
      LogToFile('TearDown failed: ' + E.ClassName + ': ' + E.Message);
      raise;
    end;
  end;
end;

procedure TTestProductService.TestGetAllProducts;
var
  Products: TJSONArray;
begin
  try
    LogToFile('Running TestGetAllProducts');
    Products := FService.GetAllProducts;
    try
      LogToFile('Products retrieved: ' + Products.ToString);
      Assert.IsNotNull(Products, 'Products array is null');
      Assert.AreEqual(1, Products.Count, 'Expected one product');
      Assert.IsNotNull(Products.Items[0], 'First product is null');
      Assert.AreEqual('Test', TJSONObject(Products.Items[0]).GetValue<string>('name'), 'Incorrect product name');
    finally
      Products.Free;
    end;
  except
    on E: Exception do
    begin
      LogToFile('TestGetAllProducts failed: ' + E.ClassName + ': ' + E.Message);
      raise;
    end;
  end;
end;

procedure TTestProductService.TestUpdateProduct;
var
  Products: TJSONArray;
begin
  try
    LogToFile('Running TestUpdateProduct');
    FService.UpdateProduct(1, 'Updated Product', 'Updated Desc', 20.0, 10);
    Products := FService.GetAllProducts;
    try
      LogToFile('Products retrieved: ' + Products.ToString);
      Assert.IsNotNull(Products, 'Products array is null');
      Assert.AreEqual(1, Products.Count, 'Expected one product');
      Assert.IsNotNull(Products.Items[0], 'First product is null');
      Assert.AreEqual('Updated Product', TJSONObject(Products.Items[0]).GetValue<string>('name'), 'Incorrect product name');
      Assert.AreEqual(20.0, TJSONObject(Products.Items[0]).GetValue<Double>('price'), 0.001, 'Incorrect price');
    finally
      Products.Free;
    end;
  except
    on E: Exception do
    begin
      LogToFile('TestUpdateProduct failed: ' + E.ClassName + ': ' + E.Message);
      raise;
    end;
  end;
end;

procedure TTestProductService.TestGetByIdProduct;
var
  Products: TJSONObject;
begin
  try
    LogToFile('Running TestGetByIdProduct');
    Products := FService.GetProductById(1);
    try
      LogToFile('Product retrieved: ' + Products.ToString);
      Assert.IsNotNull(Products, 'Product is null');
      Assert.AreEqual('Test', TJSONObject(Products).GetValue<string>('name'), 'Incorrect product name');
    finally
      Products.Free;
    end;
  except
    on E: Exception do
    begin
      LogToFile('TestGetByIdProduct failed: ' + E.ClassName + ': ' + E.Message);
      raise;
    end;
  end;
end;
procedure TTestProductService.TestDeleteProduct;
begin
  var
  Products: TJSONObject;
begin
  try
    LogToFile('Running TestDeleteProduct');
    FService.DeleteProduct(1);
    Products := FService.GetProductById(1);
    try
      Assert.IsNull(Products, 'Products is not null');
    finally
      Products.Free;
    end;
  except
    on E: Exception do
    begin
      LogToFile('TestDeleteProduct failed: ' + E.ClassName + ': ' + E.Message);
      raise;
    end;
  end;
end;
end;

end.
