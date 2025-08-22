CREATE VIEW [PowerBI].[v-dss-pbi-servicefeeperformance-MYServiceFee] 
AS 
	
	SELECT 
		AF.[TouchpointID] 
		,'Service Fee' AS [ProfileCategory]
		,PD.[Date] 
		,PD.[Fiscal Year]
		,AF.[Financial Profile total] 
		,AF.[Financial Profile total] * ((100 - ISNULL(SE.[ReferenceValue], 0)) / 100) AS [ProfileCategoryValue] 
		,AF.[Financial Profile YTD] 
		,SUM(AF.[Financial Profile total] * ((100 - ISNULL(SE.[ReferenceValue], 0)) / 100)) 
			OVER(PARTITION BY AF.[TouchpointID], PD.[Fiscal Year] ORDER BY PD.[Date]) AS [ProfileCategoryValueYTD] 
	FROM [PowerBI].[v-dss-pbi-outcomeprofilefact] AS AF 
	INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD 
	ON AF.[Date] = PD.[Date] 
	LEFT OUTER JOIN [PowerBI].[dss-pbi-servicefeededuction] AS SE 
	ON AF.[TouchpointID] = SE.[TouchpointID] 
	AND AF.[Date] = SE.[CalendarDate] 
	WHERE AF.[Outcome ID] = 11 
	GROUP BY 
		AF.[TouchpointID] 
		,PD.[Date] 
		,PD.[Fiscal Year] 
		,AF.[Financial Profile total] 
		,AF.[Financial Profile total] * ((100 - ISNULL(SE.[ReferenceValue], 0)) / 100) 
		,AF.[Financial Profile YTD];
GO

