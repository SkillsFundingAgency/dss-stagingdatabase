CREATE VIEW [PowerBI].[v-dss-pbi-servicefeeperformance] 
AS 
	SELECT 
		SF.[TouchpointID]
		,SF.[Date]
		,SF.[ProfileCategory]
		,SF.[ProfileCategoryValue]
		,SF.[ProfileCategoryValueYTD] 
		,PP.[ProfileCategoryValue] AS [ProfileCategoryValueFullYear] 
	FROM [PowerBI].[v-dss-pbi-servicefeeperformance-MYServiceFee]  AS SF 
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
	FROM [PowerBI].[v-dss-pbi-servicefeeperformance-MYServiceFee]  AS SF 
	INNER JOIN [PowerBI].[dss-pbi-primeprofile] AS PP 
	ON SF.[TouchpointID] = PP.[TouchpointID] 
	AND SF.[Date] BETWEEN PP.[StartDateTime] AND PP.[EndDateTime] 
	WHERE PP.ProfileCategory = 'SF' 
	AND PP.FinancialsOrNot = 1 ;
GO


