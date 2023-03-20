CREATE VIEW [PowerBI].[v-dss-pbi-outcomeactualvolume] 
AS 
WITH MYProfile 
(
    [TouchpointID]
    ,[ProfileCategory]
    ,[PriorityOrNot]
    ,[PeriodMonth]
	,[PeriodYear] 
	,[OutcomeNumber] 
    ,[YTD_OutcomeNumber]
) 
AS 
(
	SELECT 
		PO.[TouchpointID] 
        ,CASE WHEN PO.[OutcomeTypeGroup] = 'JO' AND PO.[OutcomeTypeValue] = 3 THEN 'SE' 
             WHEN PO.[OutcomeTypeGroup] = 'JO' AND PO.[OutcomeTypeValue] = 5 THEN 'CP'
             ELSE PO.[OutcomeTypeGroup]
        END AS [ProfileCategory] 
		,PO.[PriorityOrNot]
		,PO.[PeriodMonth]
		,PO.[PeriodYear] 
		,PO.[OutcomeNumber] 
        ,SUM(PO.[OutcomeNumber]) OVER(PARTITION BY PO.[TouchpointID], 
										CASE WHEN PO.[OutcomeTypeGroup] = 'JO' AND PO.[OutcomeTypeValue] = 3 THEN 'SE' 
											WHEN PO.[OutcomeTypeGroup] = 'JO' AND PO.[OutcomeTypeValue] = 5 THEN 'CP'
											ELSE PO.[OutcomeTypeGroup]
										END										
										,PO.[PeriodYear], PO.[PriorityOrNot] ORDER BY PO.[PeriodMonth]) AS [YTD_OutcomeNumber]
	FROM [PowerBI].[dss-pbi-outcome] AS PO 
	UNION ALL
	SELECT 
		PO.[TouchpointID] 
		,'CUS' AS [ProfileCategory]
		,PO.[PriorityOrNot]
		,PO.[PeriodMonth]
		,PO.[PeriodYear] 
		,PO.[CustomerCount] AS [OutcomeNumber]
        ,SUM(PO.[CustomerCount]) OVER(PARTITION BY PO.[TouchpointID], PO.[PeriodYear], PO.[PriorityOrNot] 
									ORDER BY PO.[PeriodMonth]) AS [YTD_OutcomeNumber]
	FROM [PowerBI].[v-dss-pbi-customercount] AS PO
	UNION ALL
    SELECT 
        PO.[TouchpointID] 
        ,'CMD' AS [ProfileCategory] 
		,PO.[PriorityOrNot]
		,PO.[PeriodMonth]
		,PO.[PeriodYear] 
        ,CASE WHEN PO.[PriorityOrNot] = 'PG' THEN PO.[CustomerCount] ELSE 0 END AS [OutcomeNumber]
        ,SUM(CASE WHEN PO.[PriorityOrNot] = 'PG' THEN PO.[CustomerCount] ELSE 0 END) 
			OVER(PARTITION BY PO.[TouchpointID], PO.[PeriodYear], PO.[PriorityOrNot] 
				ORDER BY PO.[PeriodMonth]) AS [YTD_OutcomeNumber]
    FROM [PowerBI].[v-dss-pbi-customercount] AS PO
)

SELECT 
	MY.[TouchpointID] 
	,MY.[ProfileCategory]
	,MY.[PriorityOrNot]
	,MY.[PeriodMonth]
	,PT.[DATE]
	,MY.[PeriodYear] 
	,CAST(CASE WHEN MY.[ProfileCategory] = 'CMD' THEN 
			IIF(MY.[OutcomeNumber] > 0, 
				MY.[OutcomeNumber] - LAG(MY.[OutcomeNumber]) OVER (PARTITION BY MY.[TouchpointID], MY.[PeriodYear], MY.[ProfileCategory] 
																ORDER BY MY.PeriodMonth), 0) 
			ELSE 
				MY.[OutcomeNumber]
			END AS DECIMAL(10, 2)) AS [OutcomeNumber]
	,[YTD_OutcomeNumber]
FROM 
(
	SELECT 
		MY1.[TouchpointID]
		,MY1.[ProfileCategory]
		,MY1.[PriorityOrNot]
		,MY1.[PeriodMonth]
		,MY1.[PeriodYear] 
		,CAST(CASE WHEN MY1.[ProfileCategory] = 'CMD' THEN 
				IIF(MY1.[YTD_OutcomeNumber] > (DP.[ProfileCategoryValue] * DRR.[ReferenceValue] / 100), 
					MY1.[YTD_OutcomeNumber] - (DP.[ProfileCategoryValue] * DRR.[ReferenceValue] / 100), 0) 
				ELSE 
					MY1.[OutcomeNumber]
				END AS DECIMAL(10, 2)) AS [OutcomeNumber]
		,CAST(CASE WHEN MY1.[ProfileCategory] = 'CMD' THEN 
				IIF(MY1.[YTD_OutcomeNumber] > (DP.[ProfileCategoryValue] * DRR.[ReferenceValue] / 100), 
					MY1.[YTD_OutcomeNumber] - (DP.[ProfileCategoryValue] * DRR.[ReferenceValue] / 100), 0) 
				ELSE 
					MY1.[YTD_OutcomeNumber]
				END AS DECIMAL(10, 2)) AS [YTD_OutcomeNumber]
	FROM
	(
		SELECT 
			[TouchpointID]
			,[ProfileCategory]
			,[PriorityOrNot]
			,[PeriodMonth]
			,[PeriodYear] 
			,[OutcomeNumber] 
			,[YTD_OutcomeNumber]
		FROM MYProfile 
		UNION ALL 
		SELECT 
			[TouchpointID]
			,'JO' AS [ProfileCategory]
			,[PriorityOrNot]
			,[PeriodMonth]
			,[PeriodYear] 
			,SUM([OutcomeNumber]) 
			,SUM([YTD_OutcomeNumber])
		FROM MYProfile 
		WHERE [ProfileCategory] IN ('CP', 'SE')
		GROUP BY 
			[TouchpointID]
			,[PriorityOrNot]
			,[PeriodMonth]
			,[PeriodYear] 
	) AS MY1 
	LEFT OUTER JOIN [PowerBI].[dss-pbi-primeprofile] AS DP 
	ON MY1.[TouchpointID] = DP.[TouchpointID] 
	AND MY1.[PeriodYear] = DP.[FinancialYear] 
	AND MY1.[ProfileCategory] = 'CMD'
	AND DP.[FinancialsOrNot] = 0
	AND DP.[PriorityOrNot] = 'PG'
	AND DP.[ProfileCategory] = 'CMO'
	LEFT OUTER JOIN [PowerBI].[dss-pbi-reference] AS DRR 
	ON DRR.[ReferenceCategory] = 'CMB' 
) AS MY 
INNER JOIN [PowerBI].[v-dss-pbi-date] AS PT 
ON MY.[PeriodYear] = PT.[Fiscal Year] 
AND MY.[PeriodMonth] = PT.[Fiscal Month Number] 
WHERE DATEPART(DAY, PT.[DATE]) = 1 
AND PT.[DATE] >= CONVERT(DATETIME, '01-10-2022', 103) 
;
GO