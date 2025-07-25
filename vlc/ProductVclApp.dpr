program ProductVclApp;

uses
  Vcl.Forms,
  ProductMainForm in 'ProductMainForm.pas' {TProductMainForm},
  ProductEditForm in 'ProductEditForm.pas' {TProductEditForm},
  ProductAPIClient in 'ProductAPIClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TTProductMainForm, TProductMainForm);
  Application.Run;
end.