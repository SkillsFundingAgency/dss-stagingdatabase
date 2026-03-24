/****** Object:  StoredProcedure [PowerBI].[sp-pbi-refresh-outcome-tables]    Script Date: 24/03/2026 10:37:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [PowerBI].[sp-pbi-refresh-ProfileSummary-tables](@pr1 int)
AS
BEGIN
TRUNCATE TABLE PowerBI.ProfileSummary_Not2_Staging;
INSERT INTO PowerBI.ProfileSummary_Not2_Staging
SELECT 
    [Outcome ID],
    [Date],
    SUM([Profile Full Year]),
    SUM([Financial Profile Full Year])
FROM [PowerBI].[v-dss-pbi-profilefullyear]
WHERE TouchpointID > 200
  AND [Outcome ID] != 2
GROUP BY [Outcome ID], [Date];


TRUNCATE TABLE PowerBI.ProfileSummary_O8_Staging;
INSERT INTO PowerBI.ProfileSummary_O8_Staging
SELECT 
    [Date],
    TouchpointID,
    [Fiscal Year],
    [Group ID],
    SUM([Financial Profile Full Year])
FROM [PowerBI].[v-dss-pbi-profilefullyear]
WHERE [Outcome ID] = 8
GROUP BY [Date], TouchpointID, [Fiscal Year], [Group ID];

TRUNCATE TABLE PowerBI.ProfileSummary_2_Staging;

INSERT INTO PowerBI.ProfileSummary_2_Staging
SELECT 
    O2.[Outcome ID],
    O2.[Date],
    SUM(O2.[Profile Full Year]),
    SUM(O2.[Financial Profile Full Year] + COALESCE(O8.FinancialProfileFullYear, 0))
FROM [PowerBI].[v-dss-pbi-profilefullyear] O2
LEFT JOIN PowerBI.ProfileSummary_O8_Staging O8
    ON O2.[Date] = O8.[Date]
    AND O2.TouchpointID = O8.TouchpointID
    AND O2.[Fiscal Year] = O8.FiscalYear
    AND O2.[Group ID] = O8.GroupID
WHERE O2.TouchpointID > 200
  AND O2.[Outcome ID] = 2
GROUP BY O2.[Outcome ID], O2.[Date];

TRUNCATE TABLE PowerBI.ProfileSummaryAgg;

INSERT INTO [PowerBI].[ProfileSummaryAgg]
SELECT * FROM PowerBI.ProfileSummary_Not2_Staging
UNION ALL
SELECT * FROM PowerBI.ProfileSummary_2_Staging;

END