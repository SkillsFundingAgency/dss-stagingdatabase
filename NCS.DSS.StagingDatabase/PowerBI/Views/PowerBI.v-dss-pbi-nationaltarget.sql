CREATE VIEW [PowerBI].[v-dss-pbi-nationaltarget]
AS 
	WITH QUARTER1 AS (
		SELECT [FinancialYear]
		  ,[ContractYear]
		  ,[PriorityOrNot]
		  ,[TargetCategory]
		  ,SUM([TargetCategoryValue]) AS RestOfYear
		  FROM [PowerBI].[dss-pbi-nationaltarget] AS A 
		  WHERE [PeriodMonth] > 3
		  GROUP BY [FinancialYear]
		  ,[ContractYear]
		  ,[PriorityOrNot]
		  ,[TargetCategory]
	),
	QUARTER2 AS (
		SELECT [FinancialYear]
		  ,[ContractYear]
		  ,[PriorityOrNot]
		  ,[TargetCategory]
		  ,SUM([TargetCategoryValue]) AS RestOfYear
		  FROM [PowerBI].[dss-pbi-nationaltarget] AS A 
		  WHERE [PeriodMonth] > 6
		  GROUP BY [FinancialYear]
		  ,[ContractYear]
		  ,[PriorityOrNot]
		  ,[TargetCategory]
	),
	QUARTER3 AS (
		SELECT [FinancialYear]
		  ,[ContractYear]
		  ,[PriorityOrNot]
		  ,[TargetCategory]
		  ,SUM([TargetCategoryValue]) AS RestOfYear
		  FROM [PowerBI].[dss-pbi-nationaltarget] AS A 
		  WHERE [PeriodMonth] > 9
		  GROUP BY [FinancialYear]
		  ,[ContractYear]
		  ,[PriorityOrNot]
		  ,[TargetCategory]
	) 

	SELECT A.[FinancialYear]
		  ,A.[ContractYear]
		  ,A.[PeriodMonth]
		  ,A.[PriorityOrNot]
		  ,A.[TargetCategory]
		  ,A.[TargetCategoryValue]
		  ,CASE WHEN A.[PeriodMonth] > 3 THEN CONVERT(DECIMAL(5, 2), (A.[TargetCategoryValue] * 100) / Q1.RestOfYear) ELSE 0 END AS PMP1 
		  ,CASE WHEN A.[PeriodMonth] > 6 THEN CONVERT(DECIMAL(5, 2), (A.[TargetCategoryValue] * 100) / Q2.RestOfYear) ELSE 0 END AS PMP2 
		  ,CASE WHEN A.[PeriodMonth] > 9 THEN CONVERT(DECIMAL(5, 2), (A.[TargetCategoryValue] * 100) / Q3.RestOfYear) ELSE 0 END AS PMP3 
	FROM [PowerBI].[dss-pbi-nationaltarget] AS A 
	INNER JOIN 	QUARTER1 AS Q1 	ON A.[FinancialYear] = Q1.[FinancialYear] AND A.[ContractYear] = Q1.[ContractYear]
			AND A.[PriorityOrNot] = Q1.[PriorityOrNot] AND A.[TargetCategory] = Q1.[TargetCategory]
	INNER JOIN 	QUARTER2 AS Q2 ON A.[FinancialYear] = Q2.[FinancialYear] AND A.[ContractYear] = Q2.[ContractYear]
			AND A.[PriorityOrNot] = Q2.[PriorityOrNot] AND A.[TargetCategory] = Q2.[TargetCategory]
	INNER JOIN QUARTER3	 AS Q3 ON A.[FinancialYear] = Q3.[FinancialYear] AND A.[ContractYear] = Q3.[ContractYear]
			AND A.[PriorityOrNot] = Q3.[PriorityOrNot] AND A.[TargetCategory] = Q3.[TargetCategory];
GO