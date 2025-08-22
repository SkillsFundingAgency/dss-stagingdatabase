CREATE VIEW [PowerBI].[v-dss-pbi-conversionrate-myprofile] 
AS 
	SELECT 
		AF.[TouchpointID] 
		,AF.[Outcome ID] 
		,FYA.[FinancialYear] 
		,AF.[Date] 
		,AF.[Outcome number] 
		,SUM(AF.[Outcome number]) OVER(PARTITION BY AF.[TouchpointID], AF.[Outcome ID], FYA.[FinancialYear] 
										ORDER BY AF.[Date]) AS [YTD Outcome number]
	FROM 
    [PowerBI].[v-dss-pbi-conversionrate-outcomes]  AS AF 
	INNER JOIN [PowerBI].[dss-pbi-financialyear] AS FYA 
	ON AF.[Date] BETWEEN FYA.[StartDateTime] AND FYA.[EndDateTime] 
;
GO


