CREATE TABLE [PowerBI].[dss-pbi-manualinputaudit] (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    LoggedOn DATETIME DEFAULT GETDATE() NOT NULL,
    StoredProcedureName VARCHAR(250),    
    InputParameters VARCHAR(2000),
    ActionType VARCHAR(10),  -- INSERT, UPDATE, DELETE
);
