CREATE VIEW [PowerBI].[v-dss-pbi-outcomeactualtotals] 
AS 
    SELECT 
        [TouchpointID]
        ,[Group ID]
        ,[Date]
        ,SUM([Outcome Finance]) AS [Outcome Finance]
        ,SUM([YTD OutcomeFinance]) AS [YTD OutcomeFinance] 
    FROM [PowerBI].[v-dss-pbi-outcomeactualfact] 
    WHERE [Outcome ID] IN 
    (
        2 --CMO
        ,6 --JLO
        ,8 --CMO Discounted Rate
        ,11 --SF
    )
    GROUP BY 
        [TouchpointID]
        ,[Group ID]
        ,[Date]
    ;
GO