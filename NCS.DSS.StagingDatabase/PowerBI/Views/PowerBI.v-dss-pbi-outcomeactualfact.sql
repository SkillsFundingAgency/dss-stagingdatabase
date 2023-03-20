CREATE VIEW [PowerBI].[v-dss-pbi-outcomeactualfact] 
AS 
WITH MYProfile 
(
    [TouchpointID]
    ,[ProfileCategory]
    ,[PriorityOrNot]
    ,[PeriodMonth]
	,[Date]
	,[PeriodYear] 
	,[OutcomeNumber] 
    ,[YTD_OutcomeNumber]
	,[OutcomeFinance] 
    ,[YTD_OutcomeFinance]
) 
AS 
(
	SELECT 
		PO.[TouchpointID] 
        ,PO.[ProfileCategory] 
		,PO.[PriorityOrNot]
		,PO.[PeriodMonth]
		,PO.[Date]
		,PO.[PeriodYear] 
		,PO.[OutcomeNumber] 
        ,PO.[YTD_OutcomeNumber]
		,((PO.[OutcomeNumber] - ISNULL(B.[OutcomeNumber], 0)) * PC.[ProfileCategoryValue]) AS [OutcomeFinance]
        ,((PO.[YTD_OutcomeNumber] - ISNULL(B.[YTD_OutcomeNumber], 0)) * PC.[ProfileCategoryValue]) AS [YTD_OutcomeFinance]
	FROM [PowerBI].[dss-pbi-outcomeactualvolume] AS PO 
	LEFT OUTER JOIN [PowerBI].[v-dss-pbi-contractrate] AS PC 
	ON PO.[TouchpointID] = PC.[TouchpointID] 
	AND PO.[PriorityOrNot] = PC.[PriorityOrNot]
	AND CASE WHEN PO.[ProfileCategory] IN ('CP', 'SE') THEN 'JO' ELSE PO.[ProfileCategory] END = PC.[ProfileCategory] 
	AND PO.[PeriodYear] = PC.[FinancialYear] 
	AND PO.[Date] = PC.[Date] 
	LEFT OUTER JOIN [PowerBI].[dss-pbi-outcomeactualvolume] AS B 
	ON PO.[TouchpointID] = B.[TouchpointID]
	AND B.[ProfileCategory] = 'CMD' 
	AND PO.[ProfileCategory] = 'CMO'
	AND PO.[PriorityOrNot] = B.[PriorityOrNot]
	AND PO.[Date] = B.[Date]
	WHERE PO.[ProfileCategory] IN 
	(
		'CMD' 
		,'CMO'
		,'JO'
		,'CP'
		,'SE'
		,'CUS'
		,'LO'
	)
	UNION ALL 
    SELECT 
		PPP.[TouchpointID] 
        ,'SF' AS [ProfileCategory] 
        ,'PG' AS [PriorityOrNot] 
        ,PD.[Fiscal Month Number] AS [PeriodMonth] 
		,PD.[Date]
        ,PD.[Fiscal Year] AS [PeriodYear] 
        ,NULL AS [OutcomeNumber] 
        ,NULL AS [YTD_OutcomeNumber] 
        ,PPP.[ProfileCategoryValue] AS [OutcomeFinance] 
        ,PPP.[ProfileCategoryValueYTD] AS [YTD_OutcomeFinance] 
    FROM [PowerBI].[v-dss-pbi-servicefee] AS PPP 
	INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD 
	ON PPP.[Date] = PD.[Date] 	
)

SELECT 
	PO.[TouchpointID] AS 'TouchpointID'
	,PD.[Outcome ID] AS 'Outcome ID'
	,PG.[Group ID] AS 'Group ID'
	,PT.[DATE] AS 'Date'
	,PO.[OutcomeNumber] AS [Outcome number]
	,PO.[YTD_OutcomeNumber] AS [YTD OutcomeNumber]
	,PO.[OutcomeFinance] AS [Outcome Finance]
	,PO.[YTD_OutcomeFinance] AS [YTD OutcomeFinance] 
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
		,SUM(CASE WHEN [ProfileCategory] IN ('CMD', 'SF') THEN 0 ELSE [OutcomeNumber] END) AS [OutcomeNumber] --CMD are already included in CMO 
		,SUM(CASE WHEN [ProfileCategory] IN ('CMD', 'SF') THEN 0 ELSE [YTD_OutcomeNumber] END) AS [YTD_OutcomeNumber] --SF have no outcomes
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
