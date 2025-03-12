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

EXECUTE [dbo].[usp_CreateReferenceData];

-- FULL REFRESHE OF PFY DATA FOLLOWING DEPLOYMENT --- 
EXECUTE [PowerBI].[sp-pbi-refresh-all-data] @pr1 = 1;

-- Create partition scheme on financial years

CREATE PARTITION FUNCTION financialYearsPF (datetime2)
AS RANGE RIGHT FOR VALUES ('2022-04-01', '2023-04-01','2024-04-01','2025-04-01', '2026-04-01', '2027-04-01')
GO
CREATE PARTITION SCHEME financialYearsScheme 
AS PARTITION financialYearsPF ALL TO ([PRIMARY]) 
GO

-- Indexes for CUSTOMER COUNTS Automated Background Task

CREATE NONCLUSTERED INDEX [nci_dss-employmentprogressions_CustomerId_DateProgressionRecorded]
ON [dbo].[dss-employmentprogressions]([CustomerID], [DateProgressionRecorded]) 
INCLUDE ([EconomicShockStatus], [EconomicShockCode]) 
WITH (ONLINE = ON)
GO

CREATE NONCLUSTERED INDEX [nci_dss-outcomes_ActionPlanId] 
ON [dbo].[dss-outcomes]([ActionPlanId]) 
INCLUDE ([OutcomeEffectiveDate]) 
WITH (ONLINE = ON)
GO

CREATE NONCLUSTERED INDEX [dss-actionplans_DateActionPlanCreated]
ON [dbo].[dss-actionplans] ([DateActionPlanCreated])
INCLUDE ([CreatedBy], [CustomerId], [CustomerSatisfaction], [LastModifiedDate])
WITH (ONLINE = ON);
GO

-- Drop redundant index for dss-prioritygroups

DROP INDEX [dbo].[dss-prioritygroups].[nci_dss-prioritygroups_CustomerId];
GO

--Indexes for OUTCOME TABLES REFRESH Automated Background Task

CREATE NONCLUSTERED INDEX [nci_dss-outcomes_OutcomeType_OutcomeClaimedDate_OutcomeEffectiveDate]
ON [dbo].[dss-outcomes] ([OutcomeType],[OutcomeClaimedDate],[OutcomeEffectiveDate])
INCLUDE ([ActionPlanId], [id], [TouchpointID], [CustomerId], [IsPriorityCustomer], [ClaimedPriorityGroup], [LastModifiedDate])
WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
        ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
  ON financialYearsScheme([OutcomeClaimedDate])
GO

CREATE NONCLUSTERED INDEX [nci_dss-actionplans_id_interactionid] 
ON [dbo].[dss-actionplans]([id],[InteractionId]) 
INCLUDE ([SessionId])
WITH (ONLINE = ON)
GO