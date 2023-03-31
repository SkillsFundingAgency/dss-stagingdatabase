CREATE VIEW [PowerBI].[v-dss-pbi-actual-priorityflag] AS 
SELECT 
	MY.[PeriodYear]
	,MY.[PeriodMonth]
	,MY.[PriorityOrNot]
	,MY.[CustomerCount]
    ,SUM(MY.[CustomerCount]) OVER(PARTITION BY MY.[PeriodYear], MY.[PriorityOrNot] ORDER BY MY.[PeriodMonth]) AS [YTD_CustomerCount] 
FROM 
(
	SELECT 
		PVC.[PeriodYear]
		,PM.[PeriodMonth]
		,PM.[MonthShortName]
		,PVC.[PriorityOrNot]
		,SUM(PVC.[CustomerCount]) AS [CustomerCount] 
	FROM [PowerBI].[v-dss-pbi-customercount] AS PVC
	INNER JOIN [PowerBI].[dss-pbi-region] AS PR
	ON PVC.[TouchpointID] = PR.[TouchpointID] 
	INNER JOIN [PowerBI].[dss-pbi-monthsinyear] AS PM 
	ON PVC.[PeriodMonth] = PM.[PeriodMonth] 
	WHERE GETDATE() BETWEEN PR.[StartDateTime] AND PR.[EndDateTime] 
	GROUP BY 
		PVC.[PeriodYear]
		,PM.[PeriodMonth]
		,PM.[MonthShortName]
		,PVC.[PriorityOrNot]
) AS MY 
;

GO