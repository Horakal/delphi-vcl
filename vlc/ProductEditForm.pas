unit ProductEditForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TTProductEditForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EditName: TEdit;
    EditDescription: TEdit;
    EditPrice: TEdit;
    EditStock: TEdit;
    BtnSave: TButton;
    BtnCancel: TButton;
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
  end;

var
  TProductEditForm: TTProductEditForm;

implementation

{$R *.dfm}

procedure TTProductEditForm.BtnSaveClick(Sender: TObject);
var
  Price: Double;
  Stock: Integer;
begin
  if EditName.Text = '' then
  begin
    ShowMessage('Nome do produto nao pode ser vazio.');
    Exit;
  end;
  if not TryStrToFloat(EditPrice.Text, Price) or (Price < 0) then
  begin
    ShowMessage('Preço precisa ser positivo.');
    Exit;
  end;
  if not TryStrToInt(EditStock.Text, Stock) or (Stock < 0) then
  begin
    ShowMessage('Stock precisa ser positivo.');
    Exit;
  end;
  ModalResult := mrOk;
end;

procedure TTProductEditForm.BtnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.