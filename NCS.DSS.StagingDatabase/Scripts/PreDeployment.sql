/*
 Pre-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script.	
 Use SQLCMD syntax to include a file in the pre-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the pre-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

IF COL_LENGTH(N'dbo.dss-diversitydetails',  N'LastModifiedTouchpointId') IS NOT NULL
BEGIN
	EXEC sp_rename 'dbo.dss-diversitydetails.LastModifiedTouchpointId', 'LastModifiedBy', 'COLUMN';  
END;

IF COL_LENGTH(N'dbo.dss-diversitydetails-history',  N'LastModifiedTouchpointId') IS NOT NULL
BEGIN
	EXEC sp_rename 'dbo.dss-diversitydetails-history.LastModifiedTouchpointId', 'LastModifiedBy', 'COLUMN';  
END;

IF COL_LENGTH(N'dbo.dss-collections',  N'TouchpointId') IS NOT NULL
BEGIN
	EXEC sp_rename 'dbo.dss-collections.TouchpointId', 'TouchPointId', 'COLUMN';  
END;

IF COL_LENGTH(N'dbo.dss-collections',  N'TouchpointId') IS NOT NULL
BEGIN
	EXEC sp_rename 'dbo.dss-collections.TouchpointId', 'TouchPointId', 'COLUMN';  
END;


IF EXISTS(
       SELECT 1
       FROM   sys.columns
       WHERE  NAME = 'EconomicShockCode'
              AND [object_id] = OBJECT_ID('dbo.dss-employmentprogressions-history')
              AND TYPE_NAME(system_type_id) = 'int'
   )
BEGIN
	ALTER TABLE [dbo].[dss-employmentprogressions-history] ALTER COLUMN EconomicShockCode VARCHAR (50);
END;
--- ALTER PAYMENTS MADE COLUMN TYPE TO DECIMAL 
IF EXISTS(
       SELECT 1
       FROM   sys.columns
       WHERE  NAME = 'PaymentMade'
              AND [object_id] = OBJECT_ID('PowerBI.dss-pbi-actualpaymentsmade')
              AND TYPE_NAME(system_type_id) = 'int'
   )
BEGIN
	ALTER TABLE [PowerBI].[dss-pbi-actualpaymentsmade] ALTER COLUMN PaymentMade DECIMAL(12,5);
END;

--- ALTER Percentage MADE COLUMN TYPE TO DECIMAL (12,5)
IF EXISTS(
       SELECT 1
  FROM   sys.columns
  WHERE  NAME = 'PaymentMade'
         AND [object_id] = OBJECT_ID('PowerBI.dss-pbi-actualpaymentsmade')
         AND TYPE_NAME(system_type_id) = 'decimal'
		 and Precision =18
		 and Scale =5
   )
BEGIN
	ALTER TABLE [PowerBI].[dss-pbi-submission-pattern] ALTER COLUMN Percentage DECIMAL(12,5);
END;

--- ALTER Percentage MADE COLUMN TYPE TO DECIMAL (12,5)
IF EXISTS(
       SELECT 1
  FROM   sys.columns
  WHERE  NAME = 'Percentage'
         AND [object_id] = OBJECT_ID('PowerBI.dss-pbi-submission-pattern')
         AND TYPE_NAME(system_type_id) = 'decimal'
		 and Precision in (10,18)
		 and Scale in (2,5)
   )
BEGIN
	ALTER TABLE [PowerBI].[dss-pbi-submission-pattern] ALTER COLUMN Percentage DECIMAL(12,5);
END;


--- CREATE TABLES REQUIRED TO STORE PFY DATA -----
:r ./Create_PFYTables.sql

--Increased decimal places to [TargetCategoryValue]
ALTER TABLE [PowerBI].[dss-pbi-nationaltarget]
DROP CONSTRAINT [pk-dss-pbi-nationaltarget];

ALTER TABLE [PowerBI].[dss-pbi-nationaltarget]
ALTER COLUMN [TargetCategoryValue] DECIMAL(8, 5) NOT NULL;

ALTER TABLE [PowerBI].[dss-pbi-nationaltarget]
ADD CONSTRAINT [pk-dss-pbi-nationaltarget] PRIMARY KEY CLUSTERED 
(
    [FinancialYear] ASC,
    [ContractYear] ASC,
    [PeriodMonth] ASC,
    [PriorityOrNot] ASC,
    [TargetCategory] ASC,
    [TargetCategoryValue] ASC
)
WITH (
    STATISTICS_NORECOMPUTE = OFF,
    IGNORE_DUP_KEY = OFF,
    ONLINE = OFF,
    OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
) ON [PRIMARY];

SET ANSI_PADDING ON
GO


