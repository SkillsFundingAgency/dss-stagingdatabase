CREATE VIEW [PowerBI].[v-dss-pbi-outcomeprofilefact-myprofile] 
AS 
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
;
GO
