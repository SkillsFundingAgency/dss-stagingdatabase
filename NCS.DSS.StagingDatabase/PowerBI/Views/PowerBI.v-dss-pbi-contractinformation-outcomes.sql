CREATE VIEW [PowerBI].[v-dss-pbi-contractinformation] 
AS 
SELECT 
		AF.[TouchpointID] 
		,'05. Value Achieved YTD' AS [ProfileCategory]
		,PD.[Date] 
		,PD.[Fiscal Year]
		,SUM(AF.[YTD OutcomeFinance]) AS [ProfileCategoryValue] 
	FROM [PowerBI].[v-dss-pbi-outcomeactualfact] AS AF 
	INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD 

	ON AF.[Date] = PD.[Date] 
			inner join [powerbi].[dss-pbi-financialyear] as fy
	on fy.FinancialYear=pd.[Fiscal Year]
	WHERE AF.[Outcome ID] = 10 --Sum total of all payable values 
	and  fy.CurrentYear=1
	GROUP BY 
		AF.[TouchpointID] 
		,PD.[Date] 
		,PD.[Fiscal Year]


	UNION ALL
	SELECT 
		AF.[TouchpointID] 
		,'04. YTD Profile Value' AS [ProfileCategory]
		,PD.[Date] 
		,PD.[Fiscal Year]
		,SUM(AF.[Financial Profile YTD]) AS [ProfileCategoryValue] 
	FROM [PowerBI].[v-dss-pbi-outcomeprofilefact] AS AF 
	INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD 
	ON AF.[Date] = PD.[Date] 
	inner join [powerbi].[dss-pbi-financialyear] as fy
	on fy.FinancialYear=pd.[Fiscal Year]
	WHERE AF.[Outcome ID] = 10 --Sum total of all payable values 
	and fy.CurrentYear=1
	GROUP BY 
		AF.[TouchpointID] 
		,PD.[Date] 
		,PD.[Fiscal Year]
;
GO

