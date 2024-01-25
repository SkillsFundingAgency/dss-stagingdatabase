CREATE VIEW [PowerBI].[v-dss-pbi-servicefeeperformance] 
AS 
	WITH MYServiceFee 
	(
		[TouchpointID] 
		,[ProfileCategory] 
		,[Date] 
		,[Fiscal Year] 
		,[Financial Profile total] 
		,[ProfileCategoryValue] 
		,[Financial Profile YTD] 
		,[ProfileCategoryValueYTD] 
	)
	AS 
	(
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
			,AF.[Financial Profile YTD] 
	)

	SELECT 
		SF.[TouchpointID]
		,SF.[Date]
		,SF.[ProfileCategory]
		,SF.[ProfileCategoryValue]
		,SF.[ProfileCategoryValueYTD] 
		,PP.[ProfileCategoryValue] AS [ProfileCategoryValueFullYear] 
	FROM MYServiceFee AS SF 
	INNER JOIN [PowerBI].[dss-pbi-primeprofile] AS PP 
	ON SF.[TouchpointID] = PP.[TouchpointID] 
	AND SF.[Date] BETWEEN PP.[StartDateTime] AND PP.[EndDateTime] 
	WHERE PP.ProfileCategory = 'SF' 
	AND PP.FinancialsOrNot = 1 
	UNION ALL 
	SELECT 
		SF.[TouchpointID]
		,SF.[Date]
		,'Service Fee Percentage' AS [ProfileCategory]
		,(SF.[ProfileCategoryValue] / SF.[Financial Profile Total]) * 100 AS [ProfileCategoryValue] 
		,(SF.[ProfileCategoryValueYTD] / SF.[Financial Profile YTD]) * 100 AS [ProfileCategoryValueYTD] 
		,(SF.[ProfileCategoryValueYTD] / PP.[ProfileCategoryValue]) * 100 AS [ProfileCategoryValueFullYear] 
	FROM MYServiceFee AS SF 
	INNER JOIN [PowerBI].[dss-pbi-primeprofile] AS PP 
	ON SF.[TouchpointID] = PP.[TouchpointID] 
	AND SF.[Date] BETWEEN PP.[StartDateTime] AND PP.[EndDateTime] 
	WHERE PP.ProfileCategory = 'SF' 
	AND PP.FinancialsOrNot = 1 ;
GO


