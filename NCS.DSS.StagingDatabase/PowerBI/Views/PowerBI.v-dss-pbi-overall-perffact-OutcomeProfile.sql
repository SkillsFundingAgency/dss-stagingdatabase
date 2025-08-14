CREATE VIEW [PowerBI].[v-dss-pbi-overall-perffact-OutcomeProfile]
AS
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
GO
