CREATE FUNCTION [PowerBI].[fun-dss-pbi-outcomeprofilefact]()
RETURNS @funReturn Table
(
    TouchpointID INT,
    [Outcome ID] INT,
    [Group ID] INT,
    [Date] datetime,
    [Performance] DECIMAL(11,2),
    [Performance YTD] DECIMAL(11,2),
    [Performance Full Year] DECIMAL(11,2),
    [FinancialPerformance]  DECIMAL(11,2),
    [FinancialPerformance YTD] DECIMAL(11,2),
    [FinancialPerformance Full Year] DECIMAL(11,2)
)
AS BEGIN
	
	  DECLARE @TMP_ACT_FACT TABLE (
        TouchpointID INT,
        [Outcome ID] INT,
		[Group ID] INT,
		[Date] datetime,
		[Outcome number] DECIMAL(11,2),
		[YTD OutcomeNumber] DECIMAL(11,2),
		[Outcome Finance] DECIMAL(11,2),
		[YTD OutcomeFinance]  DECIMAL(11,2))

	INSERT INTO @TMP_ACT_FACT

	SELECT 
		[TouchpointID]
		,[Outcome ID]
		,[Group ID]
		,[Date]
		,[Outcome number]
		,[YTD OutcomeNumber]
		,[Outcome Finance]
		,[YTD OutcomeFinance]
	
	FROM [PowerBI].[v-dss-pbi-outcomeactualfact] 
	UNION ALL
	SELECT 
		[TouchpointID]
		,[Outcome ID]
		,3 AS [Group ID] --Total for Priority and Non Priority
		,[Date]
		,SUM([Outcome number]) AS [Outcome number] 
		,SUM([YTD OutcomeNumber]) AS [YTD OutcomeNumber] 
		,SUM([Outcome Finance]) AS [Outcome Finance]
		,SUM([YTD OutcomeFinance]) AS [YTD OutcomeFinance]
	
	FROM [PowerBI].[v-dss-pbi-outcomeactualfact] 
	GROUP BY 
		[TouchpointID]
		,[Outcome ID]
		,[Date]
	
	DECLARE @TMP_PROF_FACT TABLE (
        TouchpointID INT,
        [Outcome ID] INT,
		[Group ID] INT,
		[Date] datetime,
		[Profile total] DECIMAL(11,2),
		[Profile YTD] DECIMAL(11,2),
		[Financial Profile total] DECIMAL(11,2),
		[Financial Profile YTD]  DECIMAL(11,2))

	INSERT INTO @TMP_PROF_FACT

	SELECT 
		[TouchpointID]
		,[Outcome ID]
		,[Group ID]
		,[Date]
		,[Profile total]
		,[Profile YTD]
		,[Financial Profile total] 
		,[Financial Profile YTD]
	
	FROM [PowerBI].[v-dss-pbi-outcomeprofilefact] 
	UNION ALL
	SELECT 
		[TouchpointID]
		,[Outcome ID]
		,3 AS [Group ID]
		,[Date]
		,SUM([Profile total]) AS [Profile total] 
		,SUM([Profile YTD]) AS [Profile YTD]
		,SUM([Financial Profile total]) AS [Financial Profile total] 
		,SUM([Financial Profile YTD]) AS [Financial Profile YTD]

	FROM [PowerBI].[v-dss-pbi-outcomeprofilefact] 
	GROUP BY 
		[TouchpointID]
		,[Outcome ID]
		,[Date]

	DECLARE @TMP_FIN_PROF TABLE (
        TouchpointID INT,
        [Outcome ID] INT,
		[Group ID] INT,
		[Date] datetime,
		[Profile Full Year] DECIMAL(11,2),
		[Financial Profile Full Year] DECIMAL(11,2))

	INSERT INTO @TMP_FIN_PROF
	SELECT 
		[TouchpointID]
		,[Outcome ID]
		,[Group ID]
		,[Date]
		,[Profile Full Year]
		,[Financial Profile Full Year]
	FROM [PowerBI].[v-dss-pbi-profilefullyear] 
	UNION ALL
	SELECT 
		[TouchpointID]
		,[Outcome ID]
		,3 AS [Group ID]
		,[Date]
		,SUM([Profile Full Year]) AS [Profile Full Year] 
		,SUM([Financial Profile Full Year]) AS [Financial Profile Full Year]
	FROM [PowerBI].[v-dss-pbi-profilefullyear] 
	GROUP BY 
		[TouchpointID]
		,[Outcome ID]
		,[Date]

	INSERT INTO @funReturn
	SELECT 
		AF.[TouchpointID]
		,AF.[Outcome ID]
		,AF.[Group ID]
		,AF.[Date]
		,ROUND((AF.[Outcome number] / IIF(PF.[Profile total] = 0, 1, PF.[Profile total])) * 100, 2) AS [Performance] 
		,ROUND((AF.[YTD OutcomeNumber] / IIF(PF.[Profile YTD] = 0, 1, PF.[Profile YTD])) * 100, 2) AS [Performance YTD] 
		,ROUND((AF.[YTD OutcomeNumber] / IIF(PA.[Profile Full Year] = 0, 1, PA.[Profile Full Year])) * 100, 2) [Performance Full Year] 
		,ROUND((AF.[Outcome Finance] / IIF(PF.[Financial Profile total] = 0, 1, PF.[Financial Profile total])) * 100, 2) AS [FinancialPerformance] 
		,ROUND((AF.[YTD OutcomeFinance] / IIF(PF.[Financial Profile YTD] = 0, 1, PF.[Financial Profile YTD])) * 100, 2) AS [FinancialPerformance YTD] 
		,ROUND((AF.[YTD OutcomeFinance] / IIF(PA.[Financial Profile Full Year] = 0, 1, PA.[Financial Profile Full Year])) * 100, 2) [FinancialPerformance Full Year] 

	FROM 
	@TMP_ACT_FACT AS AF 
	INNER JOIN @TMP_PROF_FACT AS PF 
	ON PF.[TouchpointID] = AF.[TouchpointID] 
	AND PF.[Outcome ID] = AF.[Outcome ID] 
	AND PF.[Group ID] = AF.[Group ID] 
	AND PF.[Date] = AF.[Date] 
	INNER JOIN @TMP_FIN_PROF AS PA 
	ON PA.[TouchpointID] = AF.[TouchpointID] 
	AND PA.[Outcome ID] = AF.[Outcome ID] 
	AND PA.[Group ID] = AF.[Group ID] 
	AND PA.[Date] = AF.[Date] 
	;

	RETURN
END



GO


