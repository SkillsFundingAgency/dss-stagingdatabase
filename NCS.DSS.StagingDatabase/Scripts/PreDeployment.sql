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

DROP INDEX IF EXISTS [pbi-dss-actionplans-DAPC] ON [dbo].[dss-actionplans]
Go

CREATE NONCLUSTERED INDEX [pbi-dss-actionplans-DAPC] ON [dbo].[dss-actionplans] ([DateActionPlanCreated]) INCLUDE ([CustomerId], [LastModifiedDate], [CreatedBy])
Go

DROP INDEX IF EXISTS [pbi-dss-outcomes-sessionid] ON [dbo].[dss-outcomes]
Go

CREATE NONCLUSTERED INDEX [pbi-dss-outcomes-sessionid] ON [dbo].[dss-outcomes] ([SessionId], [ActionPlanId])
Go

DROP INDEX IF EXISTS [pbi-dss-outcomes-cust] ON [dbo].[dss-outcomes]
Go

CREATE NONCLUSTERED INDEX [pbi-dss-outcomes-cust] ON [dbo].[dss-outcomes] ([CustomerID]) INCLUDE ([OutcomeEffectiveDate], [OutcomeType])
Go

DROP INDEX IF EXISTS [pbi-dss-outcomes-date] ON [dbo].[dss-outcomes]
Go

CREATE NONCLUSTERED INDEX [pbi-dss-outcomes-date] ON [dbo].[dss-outcomes] ([OutcomeClaimedDate], [OutcomeEffectiveDate]) INCLUDE ([CustomerID], [ActionPlanID], [OutcomeType], [ClaimedPriorityGroup], [IsPriorityCustomer], [TouchPointID], [LastModifiedDate])
GO
