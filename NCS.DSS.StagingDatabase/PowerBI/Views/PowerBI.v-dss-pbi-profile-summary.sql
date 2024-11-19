CREATE VIEW [PowerBI].[v-dss-pbi-profile-summary]
AS
WITH CTE_ProfileData AS (
    SELECT 
        O2.[Outcome ID],
        O2.[Date],
        O2.TouchpointID,
        O2.[Fiscal Year],
        O2.[Group ID],
        O2.[Profile Full Year],
        O2.[Financial Profile Full Year],
        O8.[Financial Profile Full Year] AS O8_FinancialProfile
    FROM [PowerBI].[v-dss-pbi-profilefullyear] AS O2
    LEFT OUTER JOIN [PowerBI].[v-dss-pbi-profilefullyear] AS O8 
        ON O2.[Date] = O8.[Date]
        AND O2.TouchpointID = O8.TouchpointID
        AND O2.[Fiscal Year] = O8.[Fiscal Year]
        AND O2.[Group ID] = O8.[Group ID]
        AND O8.[Outcome ID] = 8
    WHERE O2.TouchpointID > 200
        AND O2.[Outcome ID] = 2
)

SELECT 
    [Outcome ID],
    [Date],
    SUM([Profile Full Year]) AS [Profile Full Year],
    SUM(ISNULL([Financial Profile Full Year], 0) + ISNULL(O8_FinancialProfile, 0)) AS [Financial Profile Full Year]
FROM CTE_ProfileData
GROUP BY 
    [Outcome ID],
    [Date];
GO