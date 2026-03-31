/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

-- FULL REFRESHE OF PFY DATA FOLLOWING DEPLOYMENT --- 
--EXECUTE [PowerBI].[sp-pbi-refresh-all-data] @pr1 = 1;
Begin Tran Add20262027FinancialYear
-- Update all records to set CurrentYear = 0
UPDATE [PowerBI].[dss-pbi-financialyear]
SET [CurrentYear] = NULL;    
GO

IF NOT EXISTS ( SELECT 1 FROM [PowerBI].[dss-pbi-financialyear] WHERE [FinancialYear] = '2026-2027' )
BEGIN

INSERT INTO [PowerBI].[dss-pbi-financialyear]
           ([FinancialYear]
           ,[StartDateTime]
           ,[EndDateTime]
           ,[Comments],[CurrentYear])
     VALUES
           ('2026-2027'
           ,'2026-04-01 00:00:00.0000000'
           ,'2027-03-31 23:59:00.0000000'
           ,'September 2027',1)
END
ELSE
BEGIN
    UPDATE [PowerBI].[dss-pbi-financialyear]
    SET [CurrentYear] = 1
    WHERE [FinancialYear] = '2026-2027';
END
Commit
