unit ProductAPIClient;

interface

uses
  System.SysUtils, System.JSON,System.Classes, IdHTTP;

type
  TProductAPIClient = class
  private
    FHttp: TIdHTTP;
  public
    constructor Create;
    destructor Destroy; override;
    function GetAll: TJSONArray;
    function GetById(Id: Integer): TJSONObject;
    procedure Add(Name, Description: string; Price: Double; Stock: Integer);
    procedure Update(Id: Integer; Name, Description: string; Price: Double; Stock: Integer);
    procedure Delete(Id: Integer);
  end;

implementation

constructor TProductAPIClient.Create;
begin
  FHttp := TIdHTTP.Create(nil);
  FHttp.IOHandler := nil;
  FHttp.Request.ContentType := 'application/json';
  FHttp.Request.Accept := 'application/json';
  FHttp.HTTPOptions := [hoForceEncodeParams, hoKeepOrigProtocol];
  FHttp.HandleRedirects := True;
end;

destructor TProductAPIClient.Destroy;
begin
  FHttp.Free;
  inherited;
end;

function TProductAPIClient.GetAll: TJSONArray;
var
  Response: string;
  JSONValue: TJSONValue;
begin
  Result := nil;
  try
    Response := FHttp.Get('http://localhost:9000/products');
    JSONValue := TJSONObject.ParseJSONValue(Response);
    try
      if JSONValue = nil then
        raise Exception.Create('Invalid JSON response');
      if JSONValue is TJSONArray then
        Result := JSONValue as TJSONArray
      else if JSONValue is TJSONObject then
      begin
        if TJSONObject(JSONValue).GetValue('error') <> nil then
          raise Exception.Create('API Error: ' + TJSONObject(JSONValue).GetValue<string>('error', 'Unknown error'));
        raise Exception.Create('Response is not a JSON array');
      end
      else
        raise Exception.Create('Invalid JSON array response');
    finally
      if Result <> JSONValue then
        JSONValue.Free;
    end;
  except
    on E: Exception do
      raise Exception.Create('Error fetching products: ' + E.Message);
  end;
end;

function TProductAPIClient.GetById(Id: Integer): TJSONObject;
var
  Response: string;
begin
  Result := nil;
  try
    Response := FHttp.Get('http://localhost:9000/products/' + Id.ToString);
    Result := TJSONObject.ParseJSONValue(Response) as TJSONObject;
    if Result = nil then
      raise Exception.Create('Invalid JSON object response');
  except
    on E: Exception do
      raise Exception.Create('Error fetching product: ' + E.Message);
  end;
end;

procedure TProductAPIClient.Add(Name, Description: string; Price: Double; Stock: Integer);
var
  JSONObj: TJSONObject;
  JSONStream: TStringStream;
  Response: string;
  Http: TIdHTTP;
begin
  Http := TIdHTTP.Create(nil);
  try
    Http.IOHandler := nil;
    Http.Request.ContentType := 'application/json';
    Http.Request.Accept := 'application/json';
    Http.HTTPOptions := [hoForceEncodeParams, hoKeepOrigProtocol];
    Http.HandleRedirects := True;
    JSONObj := TJSONObject.Create;
    try
      JSONObj.AddPair('name', Name);
      JSONObj.AddPair('description', Description);
      JSONObj.AddPair('price', TJSONNumber.Create(Price));
      JSONObj.AddPair('stock', TJSONNumber.Create(Stock));
      JSONStream := TStringStream.Create(JSONObj.ToString, TEncoding.UTF8);
      try
        Response := Http.Post('http://localhost:9000/products', JSONStream);
      finally
        JSONStream.Free;
      end;
    finally
      JSONObj.Free;
    end;
  finally
    Http.Free;
  end;
end;

procedure TProductAPIClient.Update(Id: Integer; Name, Description: string; Price: Double; Stock: Integer);
var
  JSONObj: TJSONObject;
  JSONStream: TStringStream;
  Http: TIdHTTP;
begin
  Http := TIdHTTP.Create(nil);
  try
    Http.IOHandler := nil;
    Http.Request.ContentType := 'application/json';
    Http.Request.Accept := 'application/json';
    Http.HTTPOptions := [hoForceEncodeParams, hoKeepOrigProtocol];
    Http.HandleRedirects := True;
    JSONObj := TJSONObject.Create;
    try
      JSONObj.AddPair('name', Name);
      JSONObj.AddPair('description', Description);
      JSONObj.AddPair('price', TJSONNumber.Create(Price));
      JSONObj.AddPair('stock', TJSONNumber.Create(Stock));
      JSONStream := TStringStream.Create(JSONObj.ToString, TEncoding.UTF8);
      try
        Http.Put('http://localhost:9000/products/' + Id.ToString, JSONStream);
      finally
        JSONStream.Free;
      end;
    finally
      JSONObj.Free;
    end;
  finally
    Http.Free;
  end;
end;

procedure TProductAPIClient.Delete(Id: Integer);
begin
  try
    FHttp.Delete('http://localhost:9000/products/' + Id.ToString);
  except
    on E: Exception do
      raise Exception.Create('Error deleting product: ' + E.Message);
  end;
end;

end.
