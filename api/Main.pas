unit Main;

interface

uses
  Horse, Horse.Jhonson,ProductController;

procedure StartServer;

implementation

procedure StartServer;
var
  Controller: TProductController;
begin
  THorse.Use(Jhonson());
  Controller := TProductController.Create;
  try
    Controller.RegisterRoutes;
    THorse.Listen(9000, procedure
    begin
      Writeln('Server is running on port 9000');
    end);
  finally
    Controller.Free;
  end;
end;

end.