CREATE VIEW [PowerBI].[v-dss-pbi-servicefeeperformance] 
AS 
SELECT 
	SF.[TouchpointID]
	,SF.[Date]
	,SF.[ProfileCategory]
	,SF.[ProfileCategoryValue]
	,SF.[ProfileCategoryValueYTD] 
	,PP.[ProfileCategoryValue] AS [ProfileCategoryValueFullYear] 
FROM [PowerBI].[v-dss-pbi-servicefee] AS SF 
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
	,(SF.[ProfileCategoryValue] / PF.[Financial Profile Total]) * 100 AS [ProfileCategoryValue] 
	,(SF.[ProfileCategoryValueYTD] / PF.[Financial Profile YTD]) * 100 AS [ProfileCategoryValueYTD] 
	,(SF.[ProfileCategoryValueYTD] / PP.[ProfileCategoryValue]) * 100 AS [ProfileCategoryValueFullYear] 
FROM [PowerBI].[v-dss-pbi-servicefee] AS SF 
INNER JOIN [PowerBI].[v-dss-pbi-outcomeprofilefact] AS PF 
ON SF.[TouchpointID] = PF.[TouchpointID] 
AND SF.[Date] = PF.[Date] 
INNER JOIN [PowerBI].[dss-pbi-primeprofile] AS PP 
ON SF.[TouchpointID] = PP.[TouchpointID] 
AND SF.[Date] BETWEEN PP.[StartDateTime] AND PP.[EndDateTime] 
WHERE PP.ProfileCategory = 'SF' 
AND PP.FinancialsOrNot = 1 
AND PF.[Outcome ID] = 11
;
GO 