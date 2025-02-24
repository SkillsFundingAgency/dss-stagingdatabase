
CREATE FUNCTION [PowerBI].[fun-dss-pbi-financialProfile-summary]()
RETURNS @Result TABLE (
    [Outcome ID] INT,
    [Date] DATE,
    [Performance] DECIMAL(10, 2),
    [Performance YTD] DECIMAL(10, 2),
    [Performance Full Year] DECIMAL(10, 2),
    [FinancialPerformance] DECIMAL(10, 2),
    [FinancialPerformance YTD] DECIMAL(10, 2),
    [FinancialPerformance Full Year] DECIMAL(10, 2)
	)
AS
BEGIN
    -- Table variable to hold Outcome Actual Facts
    DECLARE @OutcomeActual TABLE (
        [Outcome ID] INT,
        [Date] DATE,
        [Outcome number] DECIMAL(18, 2),
        [YTD OutcomeNumber] DECIMAL(18, 2),
        [Outcome Finance] DECIMAL(18, 2),
        [YTD OutcomeFinance] DECIMAL(18, 2)
    );

    -- Table variable to hold Outcome Profile Facts
    DECLARE @OutcomeProfile TABLE (
        [Outcome ID] INT,
        [Date] DATE,
        [Profile total] DECIMAL(18, 2),
        [Profile YTD] DECIMAL(18, 2),
        [Financial Profile total] DECIMAL(18, 2),
        [Financial Profile YTD] DECIMAL(18, 2)
    );

    -- Step 1: Populate Outcome Actual Facts
    INSERT INTO @OutcomeActual
    SELECT 
        [Outcome ID],
        [Date],
        SUM([Outcome number]) AS [Outcome number],
        SUM([YTD OutcomeNumber]) AS [YTD OutcomeNumber],
        SUM([Outcome Finance]) AS [Outcome Finance],
        SUM([YTD OutcomeFinance]) AS [YTD OutcomeFinance]
    FROM [PowerBI].[v-dss-pbi-outcomeactualfact]
    WHERE TouchpointID > 200
    GROUP BY [Outcome ID], [Date];

    -- Step 2: Populate Outcome Profile Facts
    INSERT INTO @OutcomeProfile
    SELECT 
        [Outcome ID],
        [Date],
        SUM([Profile total]) AS [Profile total],
        SUM([Profile YTD]) AS [Profile YTD],
        SUM([Financial Profile total]) AS [Financial Profile total],
        SUM([Financial Profile YTD]) AS [Financial Profile YTD]
    FROM [PowerBI].[v-dss-pbi-outcomeprofilefact]
    WHERE TouchpointID > 200
    GROUP BY [Outcome ID], [Date];

    -- Step 3: Calculate Performance Metrics
    INSERT INTO @Result
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
        @OutcomeActual AS OA
    INNER JOIN 
        @OutcomeProfile AS OP
        ON OP.[Outcome ID] = OA.[Outcome ID]
        AND OP.[Date] = OA.[Date]
    INNER JOIN 
        [PowerBI].[v-dss-pbi-profile-summary] AS SUM_PA
        ON SUM_PA.[Outcome ID] = OA.[Outcome ID]
        AND SUM_PA.[Date] = OA.[Date];

    RETURN;
END;