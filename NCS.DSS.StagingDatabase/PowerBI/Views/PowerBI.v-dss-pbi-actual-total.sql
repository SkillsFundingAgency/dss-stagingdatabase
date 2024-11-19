CREATE VIEW [PowerBI].[v-dss-pbi-actual-total] AS 
SELECT 
	MY.[PeriodYear]
	,MY.[PeriodMonth]
	,MY.[CustomerCount]
    ,SUM(MY.[CustomerCount]) OVER(PARTITION BY MY.[PeriodYear] ORDER BY MY.[PeriodMonth]) AS [YTD_CustomerCount] 
FROM 
(
	SELECT 
		PVC.[PeriodYear]
		,PM.[PeriodMonth]
		,PM.[MonthShortName]
		,SUM(PVC.[CustomerCount]) AS [CustomerCount] 
	FROM [PowerBI].[dss-pbi-customercount] AS PVC
	INNER JOIN [PowerBI].[dss-pbi-region] AS PR
	ON PVC.[TouchpointID] = PR.[TouchpointID] 
	INNER JOIN [PowerBI].[dss-pbi-monthsinyear] AS PM 
	ON PVC.[PeriodMonth] = PM.[PeriodMonth] 
	WHERE GETDATE() BETWEEN PR.[StartDateTime] AND PR.[EndDateTime] 
	GROUP BY 
		PVC.[PeriodYear]
		,PM.[PeriodMonth]
		,PM.[MonthShortName]
) AS MY 
;

GO