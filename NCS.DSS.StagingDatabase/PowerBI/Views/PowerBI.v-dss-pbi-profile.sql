
CREATE VIEW [PowerBI].[v-dss-pbi-profile] AS 
    SELECT MY.[TouchpointID]
        ,MY.[PeriodYear]
        ,MY.[PeriodMonth]
        ,MY.[MonthShortName]
        ,MY.[PriorityOrNot]
        ,MY.CMO_Num AS [CustomerCount] 
        ,MY.YTD_CustomerCount AS [YTD_CustomerCount] 
    FROM 
    (
        SELECT PR.[TouchpointID]
            ,PPP.[FinancialYear] AS [PeriodYear]
            ,PM.[MonthShortName]
            ,'CUS' AS [ProfileCategory]
            ,PPP.[PriorityOrNot]
            ,PNT.[PeriodMonth]
            ,ROUND((PPP.[ProfileCategoryValue] * PNT.[TargetCategoryValue]) / 100 / [PRF].[ReferenceValue], 2) AS CMO_Num
            ,SUM(ROUND((PPP.[ProfileCategoryValue] * PNT.[TargetCategoryValue]) / 100 / [PRF].[ReferenceValue], 2)) 
                OVER(PARTITION BY PR.[RegionName], PPP.[FinancialYear], PPP.[PriorityOrNot] ORDER BY PNT.[PeriodMonth]) AS YTD_CustomerCount
        FROM [PowerBI].[dss-pbi-primeprofile] AS PPP 
        INNER JOIN [PowerBI].[dss-pbi-nationaltarget] AS PNT 
        ON PPP.[ProfileCategory] = PNT.[TargetCategory] 
        AND PPP.[FinancialYear] = PNT.[FinancialYear] 
        AND PPP.[PriorityOrNot] = PNT.[PriorityOrNot] 
        INNER JOIN [PowerBI].[dss-pbi-region] AS PR
        ON PPP.[TouchpointID] = PR.[TouchpointID] 
        INNER JOIN [PowerBI].[dss-pbi-monthsinyear] AS PM 
        ON PNT.[PeriodMonth] = PM.[PeriodMonth] 
        INNER JOIN [PowerBI].[dss-pbi-reference] AS PRF 
        ON PRF.ReferenceCategory = 'CUS' 
        WHERE PPP.[FinancialsOrNot] = 0 --Selecting the target/profile number set in the contract 
        AND PPP.[ProfileCategory] = 'CMO' 
    ) AS MY 
    ;

GO