CREATE VIEW [PowerBI].[v-dss-pbi-actual]  AS 
    SELECT 
        MY.RegionName
        ,MY.FinancialYear
        ,MY.PriorityOrNot
        ,MY.MonthShortName
        ,MY.CustomerCount
        ,MY.YTD_CustomerCount
    FROM
    (

	select [RegionName]
           ,[FinancialYear]
           ,[PriorityOrNot]
           ,[MonthShortName]
           ,[CustomerCount]
           ,[YTD_CustomerCount] from [PowerBI].[pfy-dss-pbi-actual]
	union  
        SELECT
            PR.[RegionName]
            ,PF.[FinancialYear]
            ,PVC.[PriorityOrNot]
            ,PM.[MonthShortName]
            --,PVC.[PeriodMonth]
            ,SUM(PVC.[CustomerCount]) AS CustomerCount
            ,SUM(PVC.[CustomerCount]) OVER(PARTITION BY PR.[RegionName], PF.[FinancialYear], PVC.[PriorityOrNot] ORDER BY PVC.[PeriodMonth]) AS YTD_CustomerCount
        FROM [PowerBI].[dss-pbi-customercount] AS PVC 
        INNER JOIN PowerBI.[dss-pbi-region] AS PR
        ON PVC.[TouchpointID] = PR.[TouchpointID]
        INNER JOIN PowerBI.[dss-pbi-monthsinyear] AS PM
        ON PVC.[PeriodMonth] = PM.[PeriodMonth] 
        INNER JOIN PowerBI.[dss-pbi-financialyear] AS PF
        ON PVC.[PeriodYear] = PF.[FinancialYear] 
        INNER JOIN PowerBI.[dss-pbi-contractyear] AS PC 
        ON PF.[FinancialYear] BETWEEN PC.[StartFinancialYear] AND PC.[EndFinancialYear] 
        WHERE PVC.[PeriodMonth] >= CASE WHEN PC.[StartFinancialYear] = PF.[FinancialYear] THEN PC.[StartPeriodMonth] ELSE 1 END 
        AND PVC.[PeriodMonth] <= CASE WHEN PC.[EndFinancialYear] = PF.[FinancialYear] THEN PC.[EndPeriodMonth] ELSE 12 END 
		AND   PF.CurrentYear=1
        GROUP BY PR.[RegionName] 
        ,PF.[FinancialYear] 
        ,PVC.[PriorityOrNot] 
        ,PM.[MonthShortName] 
        ,PVC.[PeriodMonth]
        ,PVC.[CustomerCount] 
    ) AS MY  
GO


