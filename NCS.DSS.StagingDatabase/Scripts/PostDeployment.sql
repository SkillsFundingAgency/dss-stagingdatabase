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



IF EXISTS(
       SELECT 1
  FROM   sys.columns
  WHERE  NAME = 'PaymentMade'
         AND [object_id] = OBJECT_ID('PowerBI.dss-pbi-actualpaymentsmade')
         AND TYPE_NAME(system_type_id) = 'decimal'
		 and is_nullable=1
   )
BEGIN
	   ALTER TABLE [PowerBI].[dss-pbi-actualpaymentsmade]
    ALTER COLUMN [PaymentMade] [decimal](12, 5) NOT NULL;
END;


IF EXISTS(
       SELECT 1
  FROM   sys.columns
  WHERE  NAME = 'Percentage'
         AND [object_id] = OBJECT_ID('PowerBI.dss-pbi-submission-pattern')
         AND TYPE_NAME(system_type_id) = 'decimal'
		 and is_nullable=1
   )
BEGIN
	   ALTER TABLE [PowerBI].[dss-pbi-submission-pattern]
    ALTER COLUMN [Percentage] [decimal](12, 5) NOT NULL;
END;

-- DROP PROCEDURES AND TABLES FOR DIGITAL IDENTITIES (USED FOR DIGITAL ACTION PLANS)

DROP PROCEDURE IF EXISTS dbo.[Change_Feed_Insert_Update_dss-digitalidentities]
GO

DROP PROCEDURE IF EXISTS dbo.[Import_Cosmos_digitalidentities]
GO

DROP PROCEDURE IF EXISTS dbo.[insert-dss-digitalidentities-history]
GO

DROP TABLE IF EXISTS dbo.[dss-digitalidentities]
GO

DROP TABLE IF EXISTS dbo.[dss-digitalidentities-history]
GO