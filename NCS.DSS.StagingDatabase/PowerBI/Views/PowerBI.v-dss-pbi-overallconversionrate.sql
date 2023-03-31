CREATE VIEW [PowerBI].[v-dss-pbi-overallconversionrate] 
AS 
WITH MYPROFILE 
(
    [Outcome ID] 
    ,[FinancialYear] 
    ,[Date] 
    ,[Outcome number] 
    ,[YTD Outcome number]
)
AS 
(
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
) 

SELECT 
	AF.[Outcome ID]
	,AF.[Date]
	,ROUND((AF.[Outcome number] / IIF(PF.[Outcome number] = 0, 1, PF.[Outcome number])) * 100, 2) AS [Performance] 
	,ROUND((AF.[YTD Outcome number] / IIF(PF.[YTD Outcome number] = 0, 1, PF.[YTD Outcome number])) * 100, 2) AS [Performance YTD] 
FROM 
(
	SELECT 
		[Outcome ID] 
		,[FinancialYear] 
		,[Date] 
		,[Outcome number] 
		,[YTD Outcome number]
	FROM MYPROFILE 
) AS AF 
INNER JOIN 
(
	SELECT 
		[Outcome ID] 
		,[FinancialYear] 
		,[Date] 
		,[Outcome number] 
		,[YTD Outcome number]
	FROM MYPROFILE 
    WHERE [Outcome ID] = 7 -- Customer Numbers
) AS PF 
ON AF.[Date] = PF.[Date] 
;
GO
