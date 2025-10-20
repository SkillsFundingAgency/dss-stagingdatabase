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

--Aligns the clustered key with that of table design
--can be removed after next powerbi release
ALTER TABLE [PowerBI].[dss-pbi-nationaltarget]
DROP CONSTRAINT [pk-dss-pbi-nationaltarget];

ALTER TABLE [PowerBI].[dss-pbi-nationaltarget]
ADD CONSTRAINT [pk-dss-pbi-nationaltarget] PRIMARY KEY CLUSTERED 
(
	[FinancialYear] ASC,
	[PeriodMonth] ASC,
	[PriorityOrNot] ASC,
	[TargetCategory] ASC
)
WITH (
    STATISTICS_NORECOMPUTE = OFF,
    IGNORE_DUP_KEY = OFF,
    ONLINE = OFF,
    OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
) ON [PRIMARY];

SET ANSI_PADDING ON
GO


