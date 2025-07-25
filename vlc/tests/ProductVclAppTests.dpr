program ProductManagerTests;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DUnitX.Loggers.Console,
  DUnitX.TestFramework,
  FireDAC.Stan.Intf,
  FireDAC.Comp.Client,
  FireDAC.Phys.SQLite, // Added for SQLite driver
  TestProductService in 'TestProductService.pas',
  ProductService,
  ProductRepository;

var
  Runner: ITestRunner;
  Logger: ITestLogger;

begin
  try
    // Register SQLite driver
    FDPhysManager.Driver['SQLite'] := TFDPhysSQLiteDriver.Create(nil);
    try
      TDUnitX.CheckCommandLine;
      Runner := TDUnitX.CreateRunner;
      Runner.UseRTTI := True;
      Logger := TDUnitXConsoleLogger.Create(True); // Verbose output
      Runner.AddLogger(Logger);
      Runner.FailsOnNoAsserts := True;

      // Explicitly register test fixture
      TDUnitX.RegisterTestFixture(TestProductService);
      WriteLn('Registered Test Fixture: TTestProductService');

      // Run tests
      Runner.Execute;

      {$IFNDEF CI}
      WriteLn('Press any key to exit...');
      ReadLn;
      {$ENDIF}
    finally
      FDPhysManager.Driver['SQLite'].Free;
    end;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
end.
