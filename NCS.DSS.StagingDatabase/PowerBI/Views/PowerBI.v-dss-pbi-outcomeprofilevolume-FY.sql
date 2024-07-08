
CREATE VIEW [PowerBI].[v-dss-pbi-outcomeprofilevolume-FY] 
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
            PPP.[TouchpointID] 
            ,PPP.[ProfileCategory] 
            ,PPP.[PriorityOrNot] 
            ,PNT.[PeriodMonth] 
            ,PPP.[FinancialYear] AS [PeriodYear] 
            ,CONVERT(DECIMAL(11, 2), 
			(PPP.[ProfileCategoryValue] * PNT.[TargetCategoryValue]) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ1] * PNT.[PMP1], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ2] * PNT.[PMP2], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ3] * PNT.[PMP3], 0) / 100 
			) AS [OutcomeNumber] 
            ,SUM(CONVERT(DECIMAL(11, 2), 
			(PPP.[ProfileCategoryValue] * PNT.[TargetCategoryValue]) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ1] * PNT.[PMP1], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ2] * PNT.[PMP2], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ3] * PNT.[PMP3], 0) / 100 
			)) OVER(PARTITION BY PPP.[TouchpointID], PPP.[FinancialYear], PPP.[ProfileCategory], PPP.[PriorityOrNot] 
			ORDER BY PNT.[PeriodMonth]) AS [YTD_OutcomeNumber] 
        FROM [PowerBI].[dss-pbi-primeprofile] AS PPP 
        INNER JOIN [PowerBI].[v-dss-pbi-nationaltarget] AS PNT 
        ON PPP.[ProfileCategory] = PNT.[TargetCategory] 
        AND PPP.[FinancialYear] = PNT.[FinancialYear] 
        AND PPP.[PriorityOrNot] = PNT.[PriorityOrNot] 
		inner join [powerbi].[dss-pbi-financialyear] as fy
on fy.FinancialYear=PPP.[FinancialYear]
        WHERE PPP.[FinancialsOrNot] = 0 --Selecting the target/profile number set in the contract 
        AND PPP.[ProfileCategory] IN ('CMO', 'JO', 'LO') 
		
        UNION ALL 
        SELECT 
            PPP.[TouchpointID] 
            ,'CUS' AS [ProfileCategory] 
            ,PPP.[PriorityOrNot] 
            ,PNT.[PeriodMonth] 
            ,PPP.[FinancialYear] AS [PeriodYear] 
			,CONVERT(DECIMAL(11, 2), 
			((PPP.[ProfileCategoryValue] * PNT.[TargetCategoryValue]) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ1] * PNT.[PMP1], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ2] * PNT.[PMP2], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ3] * PNT.[PMP3], 0) / 100 
			) / [PRF].[ReferenceValue]) AS [OutcomeNumber] 
			,SUM(CONVERT(DECIMAL(11, 2), 
			((PPP.[ProfileCategoryValue] * PNT.[TargetCategoryValue]) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ1] * PNT.[PMP1], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ2] * PNT.[PMP2], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ3] * PNT.[PMP3], 0) / 100 
			) / [PRF].[ReferenceValue])) 
			OVER(PARTITION BY PPP.[TouchpointID], PPP.[FinancialYear], PPP.[ProfileCategory], PPP.[PriorityOrNot] 
			ORDER BY PNT.[PeriodMonth]) AS [YTD_OutcomeNumber]
        FROM [PowerBI].[dss-pbi-primeprofile] AS PPP 
        INNER JOIN [PowerBI].[v-dss-pbi-nationaltarget] AS PNT 
        ON PPP.[ProfileCategory] = PNT.[TargetCategory] 
        AND PPP.[FinancialYear] = PNT.[FinancialYear] 
        AND PPP.[PriorityOrNot] = PNT.[PriorityOrNot] 
        INNER JOIN [PowerBI].[dss-pbi-reference] AS PRF 
        ON PRF.ReferenceCategory = 'CUS' 
		inner join [powerbi].[dss-pbi-financialyear] as fy
on fy.FinancialYear=PPP.[FinancialYear]
        WHERE PPP.[FinancialsOrNot] = 0 --Selecting the target/profile number set in the contract 
        AND PPP.[ProfileCategory] = 'CMO' 
		
        UNION ALL 
        SELECT 
            PPP.[TouchpointID] 
            ,'CMD' AS [ProfileCategory] 
            ,PPP.[PriorityOrNot] 
            ,PNT.[PeriodMonth] 
            ,PPP.[FinancialYear] AS [PeriodYear] 
            ,CONVERT(DECIMAL(11, 2), 
			(PPP.[ProfileCategoryValue] * PNT.[TargetCategoryValue]) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ1] * PNT.[PMP1], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ2] * PNT.[PMP2], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ3] * PNT.[PMP3], 0) / 100 
			) AS [OutcomeNumber] 
            ,SUM(CONVERT(DECIMAL(11, 2), 
			(PPP.[ProfileCategoryValue] * PNT.[TargetCategoryValue]) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ1] * PNT.[PMP1], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ2] * PNT.[PMP2], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ3] * PNT.[PMP3], 0) / 100 
			)) OVER(PARTITION BY PPP.[TouchpointID], PPP.[FinancialYear], PPP.[ProfileCategory], PPP.[PriorityOrNot] 
			ORDER BY PNT.[PeriodMonth]) AS [YTD_OutcomeNumber] 
        FROM [PowerBI].[dss-pbi-primeprofile] AS PPP 
        INNER JOIN [PowerBI].[v-dss-pbi-nationaltarget] AS PNT 
        ON PPP.[ProfileCategory] = PNT.[TargetCategory] 
        AND PPP.[FinancialYear] = PNT.[FinancialYear] 
        AND PPP.[PriorityOrNot] = PNT.[PriorityOrNot] 
		inner join [powerbi].[dss-pbi-financialyear] as fy
on fy.FinancialYear=PPP.[FinancialYear]
        WHERE PPP.[FinancialsOrNot] = 0 --Selecting the target/profile number set in the contract 
        AND PPP.[ProfileCategory] = 'CMO' 
	
    )

    SELECT 
        MY.[TouchpointID]
        ,MY.[ProfileCategory]
        ,MY.[PriorityOrNot]
        ,MY.[PeriodMonth]
        ,PT.[Date]
        ,MY.[PeriodYear] 
        ,CAST(CASE WHEN MY.[ProfileCategory] = 'CMD' THEN 
                IIF(MY.[OutcomeNumber] > 0, 
                    MY.[OutcomeNumber] - LAG(MY.[OutcomeNumber]) OVER (PARTITION BY MY.[TouchpointID], MY.[PeriodYear], MY.[ProfileCategory], MY.[PriorityOrNot] 
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
                    IIF(MY1.[YTD_OutcomeNumber] > ((DP.[ProfileCategoryValue] + ISNULL(DP.[ProfileCategoryValueQ1],0) + ISNULL(DP.[ProfileCategoryValueQ2],0) + ISNULL(DP.[ProfileCategoryValueQ3],0))  * DRR.[ReferenceValue] / 100), 
                        MY1.[YTD_OutcomeNumber] - ((DP.[ProfileCategoryValue] + ISNULL(DP.[ProfileCategoryValueQ1],0) + ISNULL(DP.[ProfileCategoryValueQ2],0) + ISNULL(DP.[ProfileCategoryValueQ3],0)) * DRR.[ReferenceValue] / 100), 0) 
                    ELSE 
                        MY1.[OutcomeNumber]
                    END AS DECIMAL(10, 2)) AS [OutcomeNumber]
            ,CAST(CASE WHEN MY1.[ProfileCategory] = 'CMD' THEN 
                    IIF(MY1.[YTD_OutcomeNumber] > ((DP.[ProfileCategoryValue] + ISNULL(DP.[ProfileCategoryValueQ1],0) + ISNULL(DP.[ProfileCategoryValueQ2],0) + ISNULL(DP.[ProfileCategoryValueQ3],0)) * DRR.[ReferenceValue] / 100), 
                        MY1.[YTD_OutcomeNumber] - ((DP.[ProfileCategoryValue] +ISNULL(DP.[ProfileCategoryValueQ1],0) + ISNULL(DP.[ProfileCategoryValueQ2],0) + ISNULL(DP.[ProfileCategoryValueQ3],0)) * DRR.[ReferenceValue] / 100), 0) 
                    ELSE 
                        MY1.[YTD_OutcomeNumber]
                    END AS DECIMAL(10, 2)) AS [YTD_OutcomeNumber]
        FROM MYProfile AS MY1 
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
    WHERE DATEPART(DAY, PT.[Date]) = 1 
;
GO


