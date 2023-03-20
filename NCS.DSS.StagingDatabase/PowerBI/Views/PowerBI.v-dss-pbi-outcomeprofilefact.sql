CREATE VIEW [PowerBI].[v-dss-pbi-outcomeprofilefact] 
AS 
    WITH MYProfile 
    (
        [TouchpointID]
        ,[ProfileCategory]
        ,[PriorityOrNot]
        ,[Date]
        ,[PeriodMonth]
        ,[PeriodYear] 
        ,[OutcomeNumber] 
        ,[YTD_OutcomeNumber]
        ,[OutcomeFinance] 
        ,[YTD_OutcomeFinance]
    ) 
    AS 
    (
        SELECT 
            PPP.[TouchpointID]
            ,PPP.[ProfileCategory]
            ,PPP.[PriorityOrNot]
            ,PPP.[Date]
            ,PPP.[PeriodMonth] 
            ,PPP.[PeriodYear] 
            ,PPP.[OutcomeNumber]
            ,PPP.[YTD_OutcomeNumber]
            ,((PPP.[OutcomeNumber] - ISNULL(B.[OutcomeNumber], 0)) * PC.[ProfileCategoryValue]) AS [OutcomeFinance] 
            ,((PPP.[YTD_OutcomeNumber] - ISNULL(B.[YTD_OutcomeNumber], 0)) * PC.[ProfileCategoryValue]) AS [YTD_OutcomeFinance] 
        FROM [PowerBI].[v-dss-pbi-outcomeprofilevolume] AS PPP 
        LEFT OUTER JOIN [PowerBI].[v-dss-pbi-contractrate] AS PC 
        ON PPP.[TouchpointID] = PC.[TouchpointID] 
        AND PPP.[PriorityOrNot] = PC.[PriorityOrNot]
        AND PPP.[ProfileCategory] = PC.[ProfileCategory] 
        AND PPP.[Date] = PC.[Date] 
        LEFT OUTER JOIN [PowerBI].[v-dss-pbi-outcomeprofilevolume] AS B 
        ON PPP.[TouchpointID] = B.[TouchpointID]
        AND B.[ProfileCategory] = 'CMD' 
        AND PPP.[ProfileCategory] = 'CMO'
        AND PPP.[PriorityOrNot] = B.[PriorityOrNot]
        AND PPP.[Date] = B.[Date]
        UNION ALL 
        SELECT 
            PPP.[TouchpointID] 
            ,PPP.[ProfileCategory] 
            ,'PG' AS [PriorityOrNot] 
            ,PT.[Date]
            ,PNT.[PeriodMonth] 
            ,PPP.[FinancialYear] AS [PeriodYear] 
            ,NULL AS [OutcomeNumber] 
            ,NULL AS [YTD_OutcomeNumber] 
            ,ROUND((PPP.[ProfileCategoryValue] * PNT.[TargetCategoryValue]) / 100, 2) AS [OutcomeFinance] 
            ,SUM(ROUND((PPP.[ProfileCategoryValue] * PNT.[TargetCategoryValue]) / 100, 2)) 
                OVER(PARTITION BY PPP.[TouchpointID], PPP.[ProfileCategory], PPP.[FinancialYear], PPP.[PriorityOrNot] ORDER BY PNT.[PeriodMonth]) AS [YTD_OutcomeFinance] 
        FROM [PowerBI].[dss-pbi-primeprofile] AS PPP 
        INNER JOIN [PowerBI].[dss-pbi-nationaltarget] AS PNT 
        ON PPP.[ProfileCategory] = PNT.[TargetCategory] 
        AND PPP.[FinancialYear] = PNT.[FinancialYear] 
        AND PPP.[PriorityOrNot] = PNT.[PriorityOrNot] 
        INNER JOIN [PowerBI].[v-dss-pbi-date] AS PT 
        ON PNT.[FinancialYear] = PT.[Fiscal Year] 
        AND PNT.[PeriodMonth] = PT.[Fiscal Month Number] 
        WHERE PPP.[FinancialsOrNot] = 1 --Selecting the target/profile number set in the contract 
        AND PPP.[ProfileCategory] = 'SF' 
        AND DATEPART(DAY, PT.[Date]) = 1 
    )

    SELECT 
        PO.[TouchpointID] AS 'TouchpointID'
        ,PD.[Outcome ID] AS 'Outcome ID'
        ,PG.[Group ID] AS 'Group ID'
        ,PT.[DATE] AS 'Date'
        ,PO.[OutcomeNumber] AS [Profile total]
        ,PO.[YTD_OutcomeNumber] AS [Profile YTD]
        ,PO.[OutcomeFinance] AS [Financial Profile total]
        ,PO.[YTD_OutcomeFinance] AS [Financial Profile YTD] 
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
            ,[OutcomeFinance] 
            ,[YTD_OutcomeFinance]
        FROM MYProfile 
        UNION ALL 
        SELECT 
            [TouchpointID]
            ,'JLO' AS [ProfileCategory]
            ,[PriorityOrNot]
            ,[PeriodMonth]
            ,[PeriodYear] 
            ,SUM([OutcomeNumber]) AS [OutcomeNumber] 
            ,SUM([YTD_OutcomeNumber]) AS [YTD_OutcomeNumber] 
            ,SUM([OutcomeFinance]) AS [OutcomeFinance] 
            ,SUM([YTD_OutcomeFinance]) AS [YTD_OutcomeFinance] 
        FROM MYProfile 
        WHERE [ProfileCategory] IN ('LO', 'JO') 
        GROUP BY 
            [TouchpointID]
            ,[PriorityOrNot]
            ,[PeriodMonth]
            ,[PeriodYear] 
        UNION ALL 
        SELECT 
            [TouchpointID]
            ,'TOT' AS [ProfileCategory]
            ,[PriorityOrNot]
            ,[PeriodMonth]
            ,[PeriodYear] 
            ,SUM(CASE WHEN [ProfileCategory] = 'CMD' THEN 0 ELSE [OutcomeNumber] END) AS [OutcomeNumber] 
            ,SUM(CASE WHEN [ProfileCategory] = 'CMD' THEN 0 ELSE [YTD_OutcomeNumber] END) AS [YTD_OutcomeNumber] 
            ,SUM([OutcomeFinance]) AS [OutcomeFinance] 
            ,SUM([YTD_OutcomeFinance]) AS [YTD_OutcomeFinance] 
        FROM MYProfile 
        WHERE [ProfileCategory] IN ('CMD', 'CMO', 'LO', 'JO', 'SF') 
        GROUP BY 
            [TouchpointID]
            ,[PriorityOrNot]
            ,[PeriodMonth]
            ,[PeriodYear] 
    ) AS PO 
    INNER JOIN [PowerBI].[v-dss-pbi-groupdim] AS PG 
    ON PO.[PriorityOrNot] = PG.[Group abbreviation]
    INNER JOIN [PowerBI].[v-dss-pbi-outcomedim] AS PD 
    ON PO.[ProfileCategory] = PD.[Outcome abbreviation]
    INNER JOIN [PowerBI].[v-dss-pbi-date] AS PT 
    ON PO.[PeriodYear] = PT.[Fiscal Year] 
    AND PO.[PeriodMonth] = PT.[Fiscal Month Number] 
    WHERE DATEPART(DAY, PT.[DATE]) = 1 
    AND PT.[DATE] >= CONVERT(DATETIME, '01-10-2022', 103) 
;
GO