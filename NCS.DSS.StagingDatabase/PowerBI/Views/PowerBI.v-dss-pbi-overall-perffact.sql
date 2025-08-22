CREATE VIEW [PowerBI].[v-dss-pbi-overall-perffact]
AS
    SELECT 
        OA.[Outcome ID],
        OA.[Date],
        ROUND((OA.[Outcome number] / IIF(OP.[Profile total] = 0, 1, OP.[Profile total])) * 100, 2) AS [Performance],
        ROUND((OA.[YTD OutcomeNumber] / IIF(OP.[Profile YTD] = 0, 1, OP.[Profile YTD])) * 100, 2) AS [Performance YTD],
        ROUND((OA.[YTD OutcomeNumber] / IIF(SUM_PA.[Profile Full Year] = 0, 1, SUM_PA.[Profile Full Year])) * 100, 2) AS [Performance Full Year],
        ROUND((OA.[Outcome Finance] / IIF(OP.[Financial Profile total] = 0, 1, OP.[Financial Profile total])) * 100, 2) AS [FinancialPerformance],
        ROUND((OA.[YTD OutcomeFinance] / IIF(OP.[Financial Profile YTD] = 0, 1, OP.[Financial Profile YTD])) * 100, 2) AS [FinancialPerformance YTD],
        ROUND((OA.[YTD OutcomeFinance] / IIF(SUM_PA.[Financial Profile Full Year] = 0, 1, SUM_PA.[Financial Profile Full Year])) * 100, 2) AS [FinancialPerformance Full Year]
    FROM 
        [PowerBI].[v-dss-pbi-overall-perffact-OutcomeActual] AS OA
    INNER JOIN 
        [PowerBI].[v-dss-pbi-overall-perffact-OutcomeProfile] AS OP
        ON OP.[Outcome ID] = OA.[Outcome ID]
        AND OP.[Date] = OA.[Date]
    INNER JOIN 
        [PowerBI].[v-dss-pbi-profile-summary] AS SUM_PA
        ON SUM_PA.[Outcome ID] = OA.[Outcome ID]
        AND SUM_PA.[Date] = OA.[Date];
GO



