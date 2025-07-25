unit ProductRepository;

interface

uses
  System.JSON,
  System.SysUtils,
  System.IOUtils,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Phys.PG,
  FireDAC.Comp.Client;

type
  TProductRepository = class
  private
    FConnection: TFDConnection;
    FOwnsConnection: Boolean;
  public
    constructor Create; overload;
    constructor Create(AConnection: TFDConnection); overload;
    destructor Destroy; override;
    function GetAll: TJSONArray;
    function GetById(Id: Integer): TJSONObject;
    procedure Add(Name, Description: string; Price: Double; Stock: Integer);
    procedure Update(Id: Integer; Name, Description: string; Price: Double; Stock: Integer);
    procedure Delete(Id: Integer);
  end;

implementation


constructor TProductRepository.Create;
begin
  FConnection := TFDConnection.Create(nil);
  FConnection.Params.Add('DriverID=PG');
  FConnection.Params.Add('Server=localhost');
  FConnection.Params.Add('Port=5432');
  FConnection.Params.Add('Database=productdb');
  FConnection.Params.Add('User_Name=postgres');
  FConnection.Params.Add('Password=your-password');
  FConnection.Connected := True;
  FOwnsConnection := True;
end;

constructor TProductRepository.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;
  FOwnsConnection := False;
end;

destructor TProductRepository.Destroy;
begin
  if FOwnsConnection then
    FConnection.Free;
  inherited;
end;

function TProductRepository.GetAll: TJSONArray;
var
  Query: TFDQuery;
  JSONObj: TJSONObject;
begin
  Result := TJSONArray.Create;
  try
    Query := TFDQuery.Create(nil);
    try
      Query.Connection := FConnection;
      Query.SQL.Text := 'SELECT * FROM products';
      Query.Open;
      while not Query.Eof do
      begin
        JSONObj := TJSONObject.Create;
        try
          JSONObj.AddPair('id', TJSONNumber.Create(Query.FieldByName('id').AsInteger));
          JSONObj.AddPair('name', Query.FieldByName('name').AsString);
          JSONObj.AddPair('description', Query.FieldByName('description').AsString);
          JSONObj.AddPair('price', TJSONNumber.Create(Query.FieldByName('price').AsFloat));
          JSONObj.AddPair('stock', TJSONNumber.Create(Query.FieldByName('stock').AsInteger));
          Result.AddElement(JSONObj);
        except
          JSONObj.Free;
          raise;
        end;
        Query.Next;
      end;
    finally
      Query.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TProductRepository.GetById(Id: Integer): TJSONObject;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'SELECT * FROM products WHERE id = :id';
    Query.ParamByName('id').AsInteger := Id;
    Query.Open;
    if not Query.Eof then
    begin
      Result := TJSONObject.Create;
      try
        Result.AddPair('id', TJSONNumber.Create(Query.FieldByName('id').AsInteger));
        Result.AddPair('name', Query.FieldByName('name').AsString);
        Result.AddPair('description', Query.FieldByName('description').AsString);
        Result.AddPair('price', TJSONNumber.Create(Query.FieldByName('price').AsFloat));
        Result.AddPair('stock', TJSONNumber.Create(Query.FieldByName('stock').AsInteger));
      except
        Result.Free;
        raise;
      end;
    end;
  finally
    Query.Free;
  end;
end;

procedure TProductRepository.Add(Name, Description: string; Price: Double; Stock: Integer);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'INSERT INTO products (name, description, price, stock) VALUES (:name, :description, :price, :stock)';
    Query.ParamByName('name').AsString := Name;
    Query.ParamByName('description').AsString := Description;
    Query.ParamByName('price').AsFloat := Price;
    Query.ParamByName('stock').AsInteger := Stock;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

procedure TProductRepository.Update(Id: Integer; Name, Description: string; Price: Double; Stock: Integer);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'UPDATE products SET name = :name, description = :description, price = :price, stock = :stock WHERE id = :id';
    Query.ParamByName('id').AsInteger := Id;
    Query.ParamByName('name').AsString := Name;
    Query.ParamByName('description').AsString := Description;
    Query.ParamByName('price').AsFloat := Price;
    Query.ParamByName('stock').AsInteger := Stock;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

procedure TProductRepository.Delete(Id: Integer);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'DELETE FROM products WHERE id = :id';
    Query.ParamByName('id').AsInteger := Id;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

end.
