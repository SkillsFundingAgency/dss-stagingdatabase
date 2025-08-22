CREATE VIEW [PowerBI].[v-dss-pbi-overall-perffact-OutcomeActual]
AS
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
GO

