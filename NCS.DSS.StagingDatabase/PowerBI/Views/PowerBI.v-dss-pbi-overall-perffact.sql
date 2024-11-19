CREATE VIEW [PowerBI].[v-dss-pbi-overall-perffact]
AS
SELECT 
    AF.[Outcome ID],
    AF.[Date],
    ROUND((AF.[Outcome number] / IIF(PF.[Profile total] = 0, 1, PF.[Profile total])) * 100, 2) AS [Performance],
    ROUND((AF.[YTD OutcomeNumber] / IIF(PF.[Profile YTD] = 0, 1, PF.[Profile YTD])) * 100, 2) AS [Performance YTD],
    ROUND((AF.[YTD OutcomeNumber] / IIF(SUM_PA.[Profile Full Year] = 0, 1, SUM_PA.[Profile Full Year])) * 100, 2) AS [Performance Full Year],
    ROUND((AF.[Outcome Finance] / IIF(PF.[Financial Profile total] = 0, 1, PF.[Financial Profile total])) * 100, 2) AS [FinancialPerformance],
    ROUND((AF.[YTD OutcomeFinance] / IIF(PF.[Financial Profile YTD] = 0, 1, PF.[Financial Profile YTD])) * 100, 2) AS [FinancialPerformance YTD],
    ROUND((AF.[YTD OutcomeFinance] / IIF(SUM_PA.[Financial Profile Full Year] = 0, 1, SUM_PA.[Financial Profile Full Year])) * 100, 2) AS [FinancialPerformance Full Year]
FROM 
    (
        SELECT 
            [Outcome ID],
            [Date],
            SUM([Outcome number]) AS [Outcome number],
            SUM([YTD OutcomeNumber]) AS [YTD OutcomeNumber],
            SUM([Outcome Finance]) AS [Outcome Finance],
            SUM([YTD OutcomeFinance]) AS [YTD OutcomeFinance]
        FROM [PowerBI].[v-dss-pbi-outcomeactualfact]
        WHERE TouchpointID > 200
        GROUP BY [Outcome ID], [Date]
    ) AS AF
INNER JOIN
    (
        SELECT 
            [Outcome ID],
            [Date],
            SUM([Profile total]) AS [Profile total],
            SUM([Profile YTD]) AS [Profile YTD],
            SUM([Financial Profile total]) AS [Financial Profile total],
            SUM([Financial Profile YTD]) AS [Financial Profile YTD]
        FROM [PowerBI].[v-dss-pbi-outcomeprofilefact]
        WHERE TouchpointID > 200
        GROUP BY [Outcome ID], [Date]
    ) AS PF
ON PF.[Outcome ID] = AF.[Outcome ID]
   AND PF.[Date] = AF.[Date]
INNER JOIN 
    [PowerBI].[v-dss-pbi-profile-summary] AS SUM_PA
ON SUM_PA.[Outcome ID] = AF.[Outcome ID]
   AND SUM_PA.[Date] = AF.[Date];

GO


