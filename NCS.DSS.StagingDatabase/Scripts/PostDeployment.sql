﻿/*
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