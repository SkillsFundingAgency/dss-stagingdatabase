CREATE VIEW [PowerBI].[v-dss-pbi-contractinformation] 
AS 
select [TouchpointID]
           ,[ProfileCategory]
           ,[Date]
           ,[Fiscal Year]
           ,[ProfileCategoryValue] from  [PowerBI].[pfy-dss-pbi-contractinformation]
union  all
SELECT 
	PP.[TouchpointID] 
	,'03. Total Profile Value' AS [ProfileCategory]
	,PD.[Date] 
	,PD.[Fiscal Year]
	,SUM(PP.[ProfileCategoryValue] + ISNULL(PP.[ProfileCategoryValueQ1], 0) 
		+ ISNULL(PP.[ProfileCategoryValueQ2], 0) + ISNULL(PP.[ProfileCategoryValueQ3], 0)) AS [ProfileCategoryValue] 
FROM [PowerBI].[dss-pbi-primeprofile] AS PP 
INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD 
ON PD.[Date] BETWEEN PP.[StartDateTime] AND PP.[EndDateTime] 
inner join [powerbi].[dss-pbi-financialyear] as fy
on fy.FinancialYear=pd.[Fiscal Year]
WHERE DAY(PD.[Date]) = 1 
and fy.CurrentYear=1
AND PP.[FinancialsOrNot] = 1 
AND PP.[ProfileCategory] IN ('CMO', 'JO', 'LO', 'SF') 
GROUP BY 
	PP.[TouchpointID] 
	,PD.[Date] 
	,PD.[Fiscal Year]
UNION ALL
SELECT 
	[TouchpointID] 
	,[ProfileCategory]
	,[Date] 
	,[Fiscal Year]
	,[ProfileCategoryValue]  
FROM [PowerBI].[v-dss-pbi-contractinformation-outcomes]
UNION ALL
SELECT 
	a.[TouchpointID] 
	,'02. Over/Underspend' as [ProfileCategory]
	,a.[Date] 
	,a.[Fiscal Year]
	,(a.[ProfileCategoryValue] - b.[ProfileCategoryValue]) as [ProfileCategoryValue]  
FROM [PowerBI].[v-dss-pbi-contractinformation-outcomes] AS a
INNER JOIN [PowerBI].[v-dss-pbi-contractinformation-outcomes] as b ON a.[TouchpointID] = b.[TouchpointID] 
	AND a.[Date] = b.[Date] 
	AND a.[Fiscal Year] = b.[Fiscal Year]
	inner join [powerbi].[dss-pbi-financialyear] as fy
on fy.FinancialYear=b.[Fiscal Year]
WHERE a.[ProfileCategory] = '05. Value Achieved YTD'
and  fy.CurrentYear=1
AND b.[ProfileCategory] = '04. YTD Profile Value'
UNION ALL
Select  
	a.[TouchpointID] 
	,'01. Overall % ' as [ProfileCategory]
	,a.[Date] 
	,a.[Fiscal Year]
	,ROUND((a.[ProfileCategoryValue] / b.[ProfileCategoryValue]) * 100, 2) as [ProfileCategoryValue]  
from [PowerBI].[v-dss-pbi-contractinformation-outcomes] as a
INNER JOIN [PowerBI].[v-dss-pbi-contractinformation-outcomes] as b ON a.[TouchpointID] = b.[TouchpointID] 
	AND a.[Date] = b.[Date] 
	AND a.[Fiscal Year] = b.[Fiscal Year]
	inner join [powerbi].[dss-pbi-financialyear] as fy
on fy.FinancialYear=b.[Fiscal Year]
WHERE a.[ProfileCategory] = '05. Value Achieved YTD'
and fy.CurrentYear=1
AND b.[ProfileCategory] = '04. YTD Profile Value';
GO