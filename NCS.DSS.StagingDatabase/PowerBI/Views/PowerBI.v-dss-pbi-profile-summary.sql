Create VIEW [PowerBI].[v-dss-pbi-profile-summary]
AS

WITH CTE_Outcome8_Aggregated AS (
    SELECT 
        [Date],
        TouchpointID,
        [Fiscal Year],
        [Group ID],
        SUM([Financial Profile Full Year]) AS [Financial Profile Full Year]
    FROM [PowerBI].[v-dss-pbi-profilefullyear]
    WHERE [Outcome ID] = 8
    GROUP BY [Date], TouchpointID, [Fiscal Year], [Group ID]
),


CTE_OutcomeNot2 AS (
    SELECT 
        [Outcome ID],
        [Date],
        SUM([Profile Full Year]) AS [Profile Full Year],
        SUM([Financial Profile Full Year]) AS [Financial Profile Full Year]
    FROM [PowerBI].[v-dss-pbi-profilefullyear]
    WHERE TouchpointID > 200 AND [Outcome ID] != 2
    GROUP BY [Outcome ID], [Date]
),


CTE_Outcome2 AS (
    SELECT 
        O2.[Outcome ID],
        O2.[Date],
        SUM(O2.[Profile Full Year]) AS [Profile Full Year],
        SUM(O2.[Financial Profile Full Year] + COALESCE(O8.[Financial Profile Full Year], 0)) AS [Financial Profile Full Year]
    FROM [PowerBI].[v-dss-pbi-profilefullyear] AS O2
    LEFT JOIN CTE_Outcome8_Aggregated AS O8
        ON O2.[Date] = O8.[Date]
        AND O2.TouchpointID = O8.TouchpointID
        AND O2.[Fiscal Year] = O8.[Fiscal Year]
        AND O2.[Group ID] = O8.[Group ID]
    WHERE O2.TouchpointID > 200 AND O2.[Outcome ID] = 2
    GROUP BY O2.[Outcome ID], O2.[Date]
)

SELECT * FROM CTE_OutcomeNot2
UNION ALL
SELECT * FROM CTE_Outcome2;
GO


