CREATE VIEW [PowerBI].[v-dss-pbi-primeprofile] AS 
WITH MYProfile 
(
    [TouchpointID]
	,[FinancialYear] 
    ,[ProfileCategory]
    ,[PriorityOrNot]
    ,[PeriodMonth]
    ,[Profile_Num]
    ,[YTD_Profile_Num]
) 
AS 
(
    SELECT PPP.[TouchpointID]
		,PPP.[FinancialYear] 
        ,PPP.[ProfileCategory]
        ,PPP.[PriorityOrNot]
        ,PNT.[PeriodMonth]
        ,ROUND((PPP.[ProfileCategoryValue] * PNT.[TargetCategoryValue]) / 100, 2) AS [Profile_Num]
        ,SUM(ROUND((PPP.[ProfileCategoryValue] * PNT.[TargetCategoryValue]) / 100, 2)) 
            OVER(PARTITION BY PPP.[TouchpointID], PPP.[FinancialYear], PPP.[ProfileCategory], PPP.[PriorityOrNot] ORDER BY PNT.[PeriodMonth]) AS [YTD_Profile_Num]
    FROM [PowerBI].[dss-pbi-primeprofile] AS PPP 
    INNER JOIN [PowerBI].[dss-pbi-nationaltarget] AS PNT 
    ON PPP.[ProfileCategory] = PNT.[TargetCategory] 
    AND PPP.[FinancialYear] = PNT.[FinancialYear] 
    AND PPP.[PriorityOrNot] = PNT.[PriorityOrNot] 
    WHERE PPP.[FinancialsOrNot] = 0 --Selecting the target/profile number set in the contract 
) 

SELECT 
	MY.[TouchpointID]
	,MY.[FinancialYear] 
	,MY.[ProfileCategory]
	,MY.[ReferenceName]
	,MY.[PeriodMonth]
	,CAST(CASE WHEN MY.[ProfileCategory] = 'CMD' THEN 
			IIF(MY.[PG_Profile_Num] > 0, 
				MY.[PG_Profile_Num] - LAG(MY.[PG_Profile_Num]) OVER (PARTITION BY MY.[TouchpointID], MY.[FinancialYear], MY.[ProfileCategory] 
																ORDER BY MY.PeriodMonth), 0) 
			ELSE 
				MY.[PG_Profile_Num]
			END AS DECIMAL(10, 2)) AS [PG_Profile_Num]
	,MY.[PG_YTD_Profile_Num]
	,MY.[NP_Profile_Num]
	,MY.[NP_YTD_Profile_Num]
	,MY.[Total_Profile_Num]
	,MY.[Total_YTD_Profile_Num]
FROM 
(
	SELECT 
		MY1.[TouchpointID]
		,MY1.[FinancialYear] 
		,MY1.[ProfileCategory]
		,DR.[ReferenceName]
		,MY1.[PeriodMonth]
		,CAST(CASE WHEN MY1.[ProfileCategory] = 'CMD' THEN 
				IIF(MY1.[YTD_Profile_Num] > (DP.[ProfileCategoryValue] * DRR.[ReferenceValue] / 100), 
					MY1.[YTD_Profile_Num] - (DP.[ProfileCategoryValue] * DRR.[ReferenceValue] / 100), 0) 
				ELSE 
					MY1.[YTD_Profile_Num]
				END AS DECIMAL(10, 2)) AS [PG_Profile_Num]
		,CAST(CASE WHEN MY1.[ProfileCategory] = 'CMD' THEN 
				IIF(MY1.[YTD_Profile_Num] > (DP.[ProfileCategoryValue] * DRR.[ReferenceValue] / 100), 
					MY1.[YTD_Profile_Num] - (DP.[ProfileCategoryValue] * DRR.[ReferenceValue] / 100), 0) 
				ELSE 
					MY1.[YTD_Profile_Num]
				END AS DECIMAL(10, 2)) AS [PG_YTD_Profile_Num]
		,CAST(MY2.[Profile_Num] AS DECIMAL(10, 2)) AS [NP_Profile_Num]
		,CAST(MY2.[YTD_Profile_Num] AS DECIMAL(10, 2)) AS [NP_YTD_Profile_Num]
		,CAST(MY1.[Profile_Num] + MY2.[Profile_Num] AS DECIMAL(10, 2)) AS [Total_Profile_Num]
		,CAST(MY1.[YTD_Profile_Num] + MY2.[YTD_Profile_Num] AS DECIMAL(10, 2)) AS [Total_YTD_Profile_Num]
	FROM 
	(
		SELECT 
			PG.[TouchpointID]
			,PG.[FinancialYear] 
			,PG.[ProfileCategory]
			,PG.[PriorityOrNot]
			,PG.[PeriodMonth]
			,PG.[Profile_Num]
			,PG.[YTD_Profile_Num]
		FROM 
		(
			SELECT 
				[TouchpointID]
				,[FinancialYear] 
				,[ProfileCategory]
				,[PriorityOrNot]
				,[PeriodMonth]
				,[Profile_Num]
				,[YTD_Profile_Num]
			FROM MYProfile 
			WHERE [PriorityOrNot] = 'PG' 
			UNION ALL 
			SELECT 
				[TouchpointID]
				,[FinancialYear] 
				,'CUS' AS [ProfileCategory]
				,[PriorityOrNot]
				,[PeriodMonth]
				,ROUND([Profile_Num] / CAST(DP.ReferenceValue AS decimal), 2) AS [Profile_Num]
				,ROUND([YTD_Profile_Num] / CAST(DP.ReferenceValue AS decimal), 2) AS [YTD_Profile_Num]
			FROM MYProfile 
			INNER JOIN [PowerBI].[dss-pbi-reference] AS DP 
			ON DP.[ReferenceCategory] = 'CUS' 
			WHERE [PriorityOrNot] = 'PG' 
			AND [ProfileCategory] = 'CMO' 
			UNION ALL 
			SELECT 
				[TouchpointID]
				,[FinancialYear] 
				,'CMD' AS [ProfileCategory]
				,[PriorityOrNot]
				,[PeriodMonth]
				,[Profile_Num]
				,[YTD_Profile_Num]
			FROM MYProfile 
			INNER JOIN [PowerBI].[dss-pbi-reference] AS DP 
			ON DP.[ReferenceCategory] = 'CUS' 
			WHERE [PriorityOrNot] = 'PG' 
			AND [ProfileCategory] = 'CMO' 
		) AS PG 
	) AS MY1
	INNER JOIN 
	(
		SELECT 
			NP.[TouchpointID]
			,NP.[FinancialYear] 
			,NP.[ProfileCategory]
			,NP.[PriorityOrNot]
			,NP.[PeriodMonth]
			,NP.[Profile_Num]
			,NP.[YTD_Profile_Num]
		FROM 
		(
			SELECT 
				[TouchpointID]
				,[FinancialYear] 
				,[ProfileCategory]
				,[PriorityOrNot]
				,[PeriodMonth]
				,[Profile_Num]
				,[YTD_Profile_Num]
			FROM MYProfile 
			WHERE [PriorityOrNot] = 'NP' 
			UNION ALL 
			SELECT 
				[TouchpointID]
				,[FinancialYear] 
				,'CUS' AS [ProfileCategory]
				,[PriorityOrNot]
				,[PeriodMonth]
				,ROUND([Profile_Num] / CAST(DP.ReferenceValue AS decimal), 2) AS [Profile_Num]
				,ROUND([YTD_Profile_Num] / CAST(DP.ReferenceValue AS decimal), 2) AS [YTD_Profile_Num]
			FROM MYProfile 
			INNER JOIN [PowerBI].[dss-pbi-reference] AS DP 
			ON DP.[ReferenceCategory] = 'CUS' 
			WHERE [PriorityOrNot] = 'NP' 
			AND [ProfileCategory] = 'CMO' 
			UNION ALL 
			SELECT 
				[TouchpointID]
				,[FinancialYear] 
				,'CMD' AS [ProfileCategory]
				,[PriorityOrNot]
				,[PeriodMonth]
				,0 AS [Profile_Num]
				,0 AS [YTD_Profile_Num]
			FROM MYProfile 
			WHERE [PriorityOrNot] = 'NP' 
			AND [ProfileCategory] = 'CMO' 
		) AS NP 
	) AS MY2
	ON MY1.[TouchpointID] = MY2.[TouchpointID] 
	AND MY1.[FinancialYear] = MY2.[FinancialYear] 
	AND MY1.[ProfileCategory] = MY2.[ProfileCategory] 
	AND MY1.[PeriodMonth] = MY2.[PeriodMonth]
	INNER JOIN [PowerBI].[dss-pbi-reference] AS DR 
	ON MY1.[ProfileCategory] = DR.[ReferenceCategory] 
	LEFT OUTER JOIN [PowerBI].[dss-pbi-primeprofile] AS DP 
	ON MY1.[TouchpointID] = DP.[TouchpointID] 
	AND MY1.[FinancialYear] = DP.[FinancialYear] 
	AND DP.[FinancialsOrNot] = 0
	AND DP.[PriorityOrNot] = 'PG'
	AND MY1.[ProfileCategory] = 'CMD'
	AND DP.[ProfileCategory] = 'CMO'
	LEFT OUTER JOIN [PowerBI].[dss-pbi-reference] AS DRR 
	ON DRR.[ReferenceCategory] = 'CMB' 
	AND MY1.[ProfileCategory] = 'CMD'
) AS MY
;
GO