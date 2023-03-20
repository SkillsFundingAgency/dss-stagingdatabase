
CREATE VIEW [PowerBI].[v-dss-pbi-profile-priorityflag] AS 
SELECT 
	MY.[PeriodYear]
	,MY.[PeriodMonth]
	,MY.[PriorityOrNot]
	,MY.CMO_Num AS [CustomerCount]
    ,SUM(MY.CMO_Num) OVER(PARTITION BY MY.[PeriodYear], MY.[PriorityOrNot] ORDER BY MY.[PeriodMonth]) AS [YTD_CustomerCount] 
FROM 
(
    SELECT 
        PPP.[FinancialYear] AS [PeriodYear]
        ,PM.[PeriodMonth]
        ,'CNO' AS [ProfileCategory]
        ,PPP.[PriorityOrNot]
        ,SUM(ROUND((PPP.[ProfileCategoryValue] * PNT.[TargetCategoryValue]) / 100 / [PRF].[ReferenceValue], 2)) AS CMO_Num
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
	GROUP BY 
		PPP.[FinancialYear]
		,PM.[PeriodMonth]
		,PPP.[PriorityOrNot]
) AS MY 
;

GO