CREATE VIEW [PowerBI].[v-dss-pbi-summaryaverage] 
AS 
    SELECT 
        DN.[TouchpointID] 
        ,DN.[Date]
        ,DN.[Outcome ID] 
        ,CASE WHEN ISNULL(DN.[Outcome number], 0) = 0 THEN 0 ELSE (NM.[Outcome Finance] / DN.[Outcome number]) END AS [MonthAverage] 
        ,CASE WHEN ISNULL(DN.[YTD OutcomeNumber], 0) = 0 THEN 0 ELSE (NM.[YTD OutcomeFinance] / DN.[YTD OutcomeNumber]) END AS [YTDAverage] 
    FROM 
    (
        SELECT 
            [TouchpointID]
            ,[Date]
            ,SUM([Outcome Finance]) AS [Outcome Finance] 
            ,SUM([YTD OutcomeFinance]) AS [YTD OutcomeFinance] 
        FROM [PowerBI].[v-dss-pbi-outcomeactualtotals] 
        GROUP BY 
            [TouchpointID]
            ,[Date]
    ) AS NM
    INNER JOIN 
    (
        SELECT 
            [TouchpointID]
            ,[Date]
            ,[Outcome ID]
            ,SUM([Outcome number]) AS [Outcome number]
            ,SUM([YTD OutcomeNumber]) AS [YTD OutcomeNumber] 
        FROM [PowerBI].[v-dss-pbi-outcomeactualfact] 
        GROUP BY 
            [TouchpointID]
            ,[Date] 
            ,[Outcome ID]
    ) AS DN 
    ON DN.[TouchpointID] = NM.TouchpointID
    AND DN.[Date] = NM.[Date] 
;
GO
