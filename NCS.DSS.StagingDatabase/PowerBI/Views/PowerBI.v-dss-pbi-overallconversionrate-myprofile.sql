CREATE VIEW [PowerBI].[v-dss-pbi-overallconversionrate-myprofile] 
AS 
SELECT 
	AF.[Outcome ID] 
	,FYA.[FinancialYear] 
	,AF.[Date] 
	,AF.[Outcome number] 
	,SUM(AF.[Outcome number]) OVER(PARTITION BY AF.[Outcome ID], FYA.[FinancialYear] 
									ORDER BY AF.[Date]) AS [YTD Outcome number]
FROM 
(
    SELECT 
        [Outcome ID] 
        ,[Date] 
        ,SUM([Outcome number]) AS [Outcome number] 
    FROM [PowerBI].[v-dss-pbi-outcomeactualfact] 
    GROUP BY 
        [Outcome ID] 
        ,[Date] 
) AS AF 
INNER JOIN [PowerBI].[dss-pbi-financialyear] AS FYA 
ON AF.[Date] BETWEEN FYA.[StartDateTime] AND FYA.[EndDateTime]
;
GO
