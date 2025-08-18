CREATE VIEW [PowerBI].[v-dss-pbi-conversionrate-outcomes] 
AS 
    SELECT 
        [TouchpointID] 
        ,[Outcome ID] 
        ,oaf.[Date] 
        ,SUM([Outcome number]) AS [Outcome number] 
    FROM [PowerBI].[v-dss-pbi-outcomeactualfact] as oaf
	inner join PowerBI.[v-dss-pbi-date] as pd on pd.Date= oaf.Date and pd.CurrentYear = 1
    GROUP BY 
        [TouchpointID] 
        ,[Outcome ID] 
        ,oaf.[Date] 
;
GO