CREATE VIEW [PowerBI].[v-dss-pbi-outcomeperffact] 
AS 
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
(
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
) AS AF 
INNER JOIN 
(
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
) AS PF 
ON PF.[TouchpointID] = AF.[TouchpointID] 
AND PF.[Outcome ID] = AF.[Outcome ID] 
AND PF.[Group ID] = AF.[Group ID] 
AND PF.[Date] = AF.[Date] 
INNER JOIN 
(
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
) AS PA 
ON PA.[TouchpointID] = AF.[TouchpointID] 
AND PA.[Outcome ID] = AF.[Outcome ID] 
AND PA.[Group ID] = AF.[Group ID] 
AND PA.[Date] = AF.[Date] 
;
GO


