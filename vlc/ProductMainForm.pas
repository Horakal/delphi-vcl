unit ProductMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.ImgList, IdHTTP, IdSSLOpenSSL, System.JSON, ProductEditForm, ProductAPIClient,
  System.ImageList, Vcl.ExtCtrls;

type
  TTProductMainForm = class(TForm)
    ListView1: TListView;
    StatusBar1: TStatusBar;
    EditSearch: TEdit;
    ImageList1: TImageList;
    BtnCreate: TButton;
    BtnEdit: TButton;
    BtnDelete: TButton;
    BtnRefresh: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnCreateClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure EditSearchChange(Sender: TObject);
  private
    FAPIClient: TProductAPIClient;
    procedure LoadProducts(const Filter: string = '');
    procedure UpdateStatusBar(const Message: string);
    function GetSelectedProductID: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  TProductMainForm: TTProductMainForm;

implementation

{$R *.dfm}

constructor TTProductMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAPIClient := TProductAPIClient.Create;
  LoadProducts;
end;

destructor TTProductMainForm.Destroy;
begin
  FAPIClient.Free;
  inherited;
end;

procedure TTProductMainForm.FormCreate(Sender: TObject);
begin

  ListView1.ViewStyle := vsReport;
  ListView1.ReadOnly := True;
  ListView1.RowSelect := True;
  ListView1.Columns.Clear;
  ListView1.Columns.Add.Caption := 'ID';
  ListView1.Columns.Add.Caption := 'Name';
  ListView1.Columns.Add.Caption := 'Description';
  ListView1.Columns.Add.Caption := 'Price';
  ListView1.Columns.Add.Caption := 'Stock';
  ListView1.Columns[0].Width := 50;
  ListView1.Columns[1].Width := 150;
  ListView1.Columns[2].Width := 200;
  ListView1.Columns[3].Width := 80;
  ListView1.Columns[4].Width := 80;
 
  UpdateStatusBar('Pronto');
end;

procedure TTProductMainForm.LoadProducts(const Filter: string = '');
var
  Products: TJSONArray;
  Product: TJSONValue;
  Item: TListItem;
  I: Integer;
  Id: Integer;
begin
  ListView1.Items.Clear;
  try
    Products := FAPIClient.GetAll;
    try
      if Products = nil then
      begin
        StatusBar1.SimpleText := 'Nenhum produto retornado';
        Exit;
      end;
      ListView1.Items.BeginUpdate;
      try
        for I := 0 to Products.Count - 1 do
        begin
          Product := Products.Items[I];
          if not (Product is TJSONObject) then
          begin
            StatusBar1.SimpleText := 'Produto invalido no index' + I.ToString;
            Continue;
          end;
          if TJSONObject(Product).GetValue('id') = nil then
          begin
            StatusBar1.SimpleText := 'Produto sem index ' + I.ToString;
            Continue;
          end;
          Id := TJSONObject(Product).GetValue<Integer>('id');
          Item := ListView1.Items.Add;
          Item.Caption := Id.ToString;
          Item.SubItems.Add(TJSONObject(Product).GetValue<string>('name', ''));
          Item.SubItems.Add(TJSONObject(Product).GetValue<string>('description', ''));
          Item.SubItems.Add(TJSONObject(Product).GetValue<Double>('price', 0).ToString);
          Item.SubItems.Add(TJSONObject(Product).GetValue<Integer>('stock', 0).ToString);
          Item.Data := Pointer(Id);
          if (Filter <> '') and (Pos(UpperCase(Filter), UpperCase(Item.SubItems[0])) = 0) then
            Item.Delete;
        end;
      finally
        ListView1.Items.EndUpdate;
      end;
    finally
      Products.Free;
    end;
  except
    on E: Exception do
      StatusBar1.SimpleText := 'Erro ao carregar produtos: ' + E.Message;
  end;
end;

procedure TTProductMainForm.UpdateStatusBar(const Message: string);
begin
  StatusBar1.SimpleText := Message;
end;

function TTProductMainForm.GetSelectedProductID: Integer;
begin
  if Assigned(ListView1.Selected) then
    Result := StrToIntDef(ListView1.Selected.Caption, 0)
  else
    Result := 0;
end;

procedure TTProductMainForm.BtnCreateClick(Sender: TObject);
var
  EditForm: TTProductEditForm;
  Price: Double;
  Stock: Integer;
begin
  EditForm := TTProductEditForm.Create(nil);
  try
    if EditForm.ShowModal = mrOk then
    begin
      try
        if not TryStrToFloat(EditForm.EditPrice.Text, Price) then
          raise Exception.Create('Preço inválido');
        if not TryStrToInt(EditForm.EditStock.Text, Stock) then
          raise Exception.Create('Stock inválido');
        FAPIClient.Add(EditForm.EditName.Text, EditForm.EditDescription.Text,
          Price, Stock);
        LoadProducts;
      except
        on E: Exception do
        begin
          UpdateStatusBar('Erro ao criar produto: ' + E.Message);
          ShowMessage('Erro ao criar produt: ' + E.Message);
        end;
      end;
    end;
  finally
    EditForm.Free;
  end;
end;

procedure TTProductMainForm.BtnEditClick(Sender: TObject);
var
  EditForm: TTProductEditForm;
  Id: Integer;
begin
  if ListView1.Selected = nil then
  begin
    StatusBar1.SimpleText := 'Nenhum produto selecionado';
    ShowMessage('Selecione algum produto para editar');
    Exit;
  end;
  Id := Integer(ListView1.Selected.Data);

  EditForm := TTProductEditForm.Create(nil);
  try

    EditForm.EditName.Text := ListView1.Selected.SubItems[0];
    EditForm.EditDescription.Text := ListView1.Selected.SubItems[1];
    EditForm.EditPrice.Text := ListView1.Selected.SubItems[2];
    EditForm.EditStock.Text := ListView1.Selected.SubItems[3];
    if EditForm.ShowModal = mrOk then
    begin
      FAPIClient.Update(
        Id,
        EditForm.EditName.Text,
        EditForm.EditDescription.Text,
        StrToFloatDef(EditForm.EditPrice.Text, 0),
        StrToIntDef(EditForm.EditStock.Text, 0)
      );
      LoadProducts;
    end;
  finally
    EditForm.Free;
  end;
end;

procedure TTProductMainForm.BtnDeleteClick(Sender: TObject);
begin
  if GetSelectedProductID = 0 then
  begin
    UpdateStatusBar('Selecione algum produto para deletar');
    ShowMessage('Selecione algum produto para deletar');
    Exit;
  end;

  if MessageDlg('Voce realmente deseja deletar esse produto?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      FAPIClient.Delete(GetSelectedProductID);
      LoadProducts;
    except
      on E: Exception do
      begin
        UpdateStatusBar('Erro deletando produto: ' + E.Message);
        ShowMessage('Erro deletando produto: ' + E.Message);
      end;
    end;
  end;
end;

procedure TTProductMainForm.BtnRefreshClick(Sender: TObject);
begin
  LoadProducts;
end;

procedure TTProductMainForm.ListView1DblClick(Sender: TObject);
begin
  if Assigned(ListView1.Selected) then
    BtnEditClick(Sender);
end;

procedure TTProductMainForm.EditSearchChange(Sender: TObject);
begin
  LoadProducts(EditSearch.Text);
end;

end.
