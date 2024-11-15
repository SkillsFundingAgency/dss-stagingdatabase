CREATE VIEW [PowerBI].[v-dss-pbi-overall-perffact]
AS
    SELECT  AF.[Outcome ID]
        ,AF.[Date]
        ,ROUND((AF.[Outcome number] / IIF(PF.[Profile total] = 0, 1, PF.[Profile total])) * 100, 2) AS [Performance] 
        ,ROUND((AF.[YTD OutcomeNumber] / IIF(PF.[Profile YTD] = 0, 1, PF.[Profile YTD])) * 100, 2) AS [Performance YTD] 
        ,ROUND((AF.[YTD OutcomeNumber] / IIF(PA.[Profile Full Year] = 0, 1, PA.[Profile Full Year])) * 100, 2) [Performance Full Year] 
        ,ROUND((AF.[Outcome Finance] / IIF(PF.[Financial Profile total] = 0, 1, PF.[Financial Profile total])) * 100, 2) AS [FinancialPerformance] 
        ,ROUND((AF.[YTD OutcomeFinance] / IIF(PF.[Financial Profile YTD] = 0, 1, PF.[Financial Profile YTD])) * 100, 2) AS [FinancialPerformance YTD] 
        ,ROUND((AF.[YTD OutcomeFinance] / IIF(PA.[Financial Profile Full Year] = 0, 1, PA.[Financial Profile Full Year])) * 100, 2) [FinancialPerformance Full Year] 
    FROM 
    ( 
        SELECT [Outcome ID]
            ,[Date]
            ,SUM([Outcome number]) AS [Outcome number] 
            ,SUM([YTD OutcomeNumber]) AS [YTD OutcomeNumber] 
            ,SUM([Outcome Finance]) AS [Outcome Finance]
            ,SUM([YTD OutcomeFinance]) AS [YTD OutcomeFinance]
        FROM [PowerBI].[v-dss-pbi-outcomeactualfact] 
        Where TouchpointID > 200
        GROUP BY  [Outcome ID]
            ,[Date]
    ) AS AF 
    INNER JOIN 
    ( 
        SELECT [Outcome ID]
            ,[Date]
            ,SUM([Profile total]) AS [Profile total] 
            ,SUM([Profile YTD]) AS [Profile YTD]
            ,SUM([Financial Profile total]) AS [Financial Profile total] 
            ,SUM([Financial Profile YTD]) AS [Financial Profile YTD]
        FROM [PowerBI].[v-dss-pbi-outcomeprofilefact] 
        Where TouchpointID > 200
        GROUP BY [Outcome ID]
            ,[Date]
    ) AS PF 
    ON PF.[Outcome ID] = AF.[Outcome ID] 
    AND PF.[Date] = AF.[Date] 
    INNER JOIN 
    (
        SELECT [Outcome ID]
            ,[Date]
            ,SUM([Profile Full Year]) AS [Profile Full Year] 
            ,SUM([Financial Profile Full Year]) AS [Financial Profile Full Year]
        FROM [PowerBI].[v-dss-pbi-profilefullyear] 
        WHERE TouchpointID > 200 AND [Outcome ID] != 2
        GROUP BY 
            [Outcome ID]
            ,[Date]
		UNION ALL
		---- INCLUDING DISCOUNTED RATE IN FULL YEAR PROFILE FINANCIALS CALCULATION (BUG - AD-188788) ----
		SELECT O2.[Outcome ID]
            ,O2.[Date]
            ,SUM(O2.[Profile Full Year]) AS [Profile Full Year] 
            ,SUM(O2.[Financial Profile Full Year] + O8.[Financial Profile Full Year]) AS [Financial Profile Full Year]
        FROM [PowerBI].[v-dss-pbi-profilefullyear] AS O2
		LEFT OUTER JOIN [PowerBI].[v-dss-pbi-profilefullyear] AS O8 ON 
			O2.[Date] = O8.[Date] AND 
			O2.TouchpointID = O8.TouchpointID AND 
			O2.[Fiscal Year] = O8.[Fiscal Year] AND 
			O2.[Group ID] = O8.[Group ID] AND
			O8.[Outcome ID] = 8 
		Where O2.TouchpointID > 200 AND O2.[Outcome ID] = 2
        GROUP BY 
            O2.[Outcome ID]
            ,O2.[DATE]
    ) AS PA 
    ON PA.[Outcome ID] = AF.[Outcome ID] 
    AND PA.[Date] = AF.[Date] 
GO