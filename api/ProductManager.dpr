program ProductManager;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Horse,
  Main in 'Main.pas',
  ProductController in 'controllers\ProductController.pas',
  ProductService in 'services\ProductService.pas',
  ProductRepository in 'repositories\ProductRepository.pas';

begin
  try
    StartServer;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.