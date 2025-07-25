unit ProductService;

interface

uses
  System.JSON, ProductRepository;

type
  TProductService = class
  private
    FRepository: TProductRepository;
  public
    constructor Create;   overload;
    constructor Create(ARepository: TProductRepository);overload;
    destructor Destroy; override;
    function GetAllProducts: TJSONArray;
    function GetProductById(Id: Integer): TJSONObject;
    procedure AddProduct(Name, Description: string; Price: Double; Stock: Integer);
    procedure UpdateProduct(Id: Integer; Name, Description: string; Price: Double; Stock: Integer);
    procedure DeleteProduct(Id: Integer);
  end;

implementation

constructor TProductService.Create;
begin
   FRepository := TProductRepository.Create;
end;
constructor TProductService.Create(ARepository: TProductRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

destructor TProductService.Destroy;
begin
  FRepository.Free;
  inherited;
end;

function TProductService.GetAllProducts: TJSONArray;
begin
  Result := FRepository.GetAll;
end;

function TProductService.GetProductById(Id: Integer): TJSONObject;
begin
  Result := FRepository.GetById(Id);
end;

procedure TProductService.AddProduct(Name, Description: string; Price: Double; Stock: Integer);
begin
  FRepository.Add(Name, Description, Price, Stock);
end;

procedure TProductService.UpdateProduct(Id: Integer; Name, Description: string; Price: Double; Stock: Integer);
begin
  FRepository.Update(Id, Name, Description, Price, Stock);
end;

procedure TProductService.DeleteProduct(Id: Integer);
begin
  FRepository.Delete(Id);
end;

end.