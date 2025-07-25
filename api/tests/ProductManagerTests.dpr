program ProductManagerTests;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DUnitX.Loggers.Console,
  DUnitX.TestFramework,
  FireDAC.Stan.Intf,
  FireDAC.Comp.Client,
  FireDAC.Phys,
  FireDAC.Phys.SQLite,
  TestProductService in 'TestProductService.pas',
  ProductService in '..\ProductService.pas',
  ProductRepository in '..\ProductRepository.pas';

var
  Runner: ITestRunner;
  Logger: ITestLogger;
  SQLiteDriverLink: TFDPhysSQLiteDriverLink;

begin
  try
    WriteLn('Starting ProductManagerTests');
    SQLiteDriverLink := TFDPhysSQLiteDriverLink.Create(nil);
    try
      TDUnitX.CheckCommandLine;
      Runner := TDUnitX.CreateRunner;
      Runner.UseRTTI := True;
      Logger := TDUnitXConsoleLogger.Create(True);
      Runner.AddLogger(Logger);
      Runner.FailsOnNoAsserts := True;

      TDUnitX.RegisterTestFixture(TTestProductService);
      WriteLn('Registered Test Fixture: TTestProductService');

      Runner.Execute;
      WriteLn('Tests executed');
    finally
      SQLiteDriverLink.Free;
    end;
  except
    on E: Exception do
      WriteLn('Test execution failed: ' + E.ClassName + ': ' + E.Message);
  end;

  {$IFNDEF CI}
  WriteLn('Press any key to exit...');
  ReadLn;
  {$ENDIF}
end.
