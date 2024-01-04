CREATE TABLE [PowerBI].[dss-pbi-outcomeactualfactday5] 
(
    [TouchpointID] INT
	,[Outcome ID] INT
	,[Group ID] INT
	,[DATE] DATETIME
	,[Outcome number] DECIMAL(9,2)
	,[YTD OutcomeNumber] DECIMAL(9,2)
	,[Outcome Finance] DECIMAL(11,2)
	,[YTD OutcomeFinance] DECIMAL(11,2)
	PRIMARY KEY ([TouchpointID],  [Outcome ID], [Group ID], [DATE])
)
;

INSERT INTO [PowerBI].[dss-pbi-outcomeactualfactday5] 
SELECT * FROM [PowerBI].[v-dss-pbi-outcomeactualfact]
;

