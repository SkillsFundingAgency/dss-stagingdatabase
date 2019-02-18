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

INSERT INTO [dss-data-collections-parameters] (ParameterName, ParameterValue) VALUES ('MinAge', '18')
INSERT INTO [dss-data-collections-parameters] (ParameterName, ParameterValue) VALUES ('MaxAge', '100')
INSERT INTO [dss-data-collections-parameters] (ParameterName, ParameterValue) VALUES ('ContractStartDate', '2018/10/01')
