unit ProductController;

interface

uses
  Horse, System.JSON, ProductService;

type
  TProductController = class
  private
    FService: TProductService;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RegisterRoutes;
  end;

implementation

uses
  System.SysUtils;

constructor TProductController.Create;
begin
  FService := TProductService.Create;
end;

destructor TProductController.Destroy;
begin
  FService.Free;
  inherited;
end;

procedure TProductController.RegisterRoutes;
begin
  THorse.Get('/products', procedure(Req: THorseRequest; Res: THorseResponse)
  var
    Products: TJSONArray;
  begin
    try
      Products := FService.GetAllProducts;
      Res.Send<TJSONArray>(Products); // JHonson handles serialization
    except
      on E: Exception do
        Res.Send<TJSONObject>(TJSONObject.Create.AddPair('error', E.Message)).Status(500);
    end;
  end);

  THorse.Get('/products/:id', procedure(Req: THorseRequest; Res: THorseResponse)
  var
    Id: Integer;
    Product: TJSONObject;
  begin
    try
      Id := Req.Params['id'].ToInteger;
      Product := FService.GetProductById(Id);
      if Product = nil then
        Res.Send<TJSONObject>(TJSONObject.Create.AddPair('error', 'Product not found')).Status(404)
      else
        Res.Send<TJSONObject>(Product);
    except
      on E: Exception do
        Res.Send<TJSONObject>(TJSONObject.Create.AddPair('error', E.Message)).Status(500);
    end;
  end);

  THorse.Post('/products', procedure(Req: THorseRequest; Res: THorseResponse)
  var
    JSONObj: TJSONObject;
  begin
    try
      JSONObj := Req.Body<TJSONObject>; // JHonson parses JSON
      FService.AddProduct(
        JSONObj.GetValue<string>('name'),
        JSONObj.GetValue<string>('description'),
        JSONObj.GetValue<Double>('price'),
        JSONObj.GetValue<Integer>('stock')
      );
      Res.Status(201);
    except
      on E: Exception do
        Res.Send<TJSONObject>(TJSONObject.Create.AddPair('error', E.Message)).Status(500);
    end;
  end);

  THorse.Put('/products/:id', procedure(Req: THorseRequest; Res: THorseResponse)
  var
    Id: Integer;
    JSONObj: TJSONObject;
  begin
    try
      Id := Req.Params['id'].ToInteger;
      JSONObj := Req.Body<TJSONObject>;
      FService.UpdateProduct(
        Id,
        JSONObj.GetValue<string>('name'),
        JSONObj.GetValue<string>('description'),
        JSONObj.GetValue<Double>('price'),
        JSONObj.GetValue<Integer>('stock')
      );
      Res.Status(200);
    except
      on E: Exception do
        Res.Send<TJSONObject>(TJSONObject.Create.AddPair('error', E.Message)).Status(500);
    end;
  end);

  THorse.Delete('/products/:id', procedure(Req: THorseRequest; Res: THorseResponse)
  var
    Id: Integer;
  begin
    try
      Id := Req.Params['id'].ToInteger;
      FService.DeleteProduct(Id);
      Res.Status(204);
    except
      on E: Exception do
        Res.Send<TJSONObject>(TJSONObject.Create.AddPair('error', E.Message)).Status(500);
    end;
  end);
end;

end.
