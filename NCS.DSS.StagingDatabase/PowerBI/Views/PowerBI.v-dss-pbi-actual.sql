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
        SELECT
            PR.[RegionName]
            ,PF.[FinancialYear]
            ,PVC.[PriorityOrNot]
            ,PM.[MonthShortName]
            ,PVC.[PeriodMonth]
            ,SUM(PVC.[CustomerCount]) AS CustomerCount
            ,SUM(PVC.[CustomerCount]) OVER(PARTITION BY PR.[RegionName], PF.[FinancialYear], PVC.[PriorityOrNot] ORDER BY PVC.[PeriodMonth]) AS YTD_CustomerCount
        FROM [PowerBI].[v-dss-pbi-customercount] AS PVC 
        INNER JOIN PowerBI.[dss-pbi-region] AS PR
        ON PVC.[TouchpointID] = PR.[TouchpointID]
        INNER JOIN PowerBI.[dss-pbi-monthsinyear] AS PM
        ON PVC.[PeriodMonth] = PM.[PeriodMonth] 
        INNER JOIN PowerBI.[dss-pbi-financialyear] AS PF
        ON PVC.[PeriodYear] = PF.[FinancialYear] 
        INNER JOIN PowerBI.[dss-pbi-contractyear] AS PC 
        ON PF.[FinancialYear] BETWEEN PC.[StartFinancialYear] AND PC.[EndFinancialYear] 
        WHERE GETDATE() BETWEEN PR.[StartDateTime] AND PR.[EndDateTime] 
        AND GETDATE() BETWEEN PF.[StartDateTime] AND PF.[EndDateTime] 
        AND PVC.[PeriodMonth] >= CASE WHEN PC.[StartFinancialYear] = PF.[FinancialYear] THEN PC.[StartPeriodMonth] ELSE 4 END 
        AND PVC.[PeriodMonth] <= CASE WHEN PC.[EndFinancialYear] = PF.[FinancialYear] THEN PC.[EndPeriodMonth] ELSE 12 END 
        GROUP BY PR.[RegionName] 
        ,PF.[FinancialYear] 
        ,PVC.[PriorityOrNot] 
        ,PM.[MonthShortName] 
        ,PVC.[PeriodMonth]
        ,PVC.[CustomerCount] 
    ) AS MY  
    ;

GO