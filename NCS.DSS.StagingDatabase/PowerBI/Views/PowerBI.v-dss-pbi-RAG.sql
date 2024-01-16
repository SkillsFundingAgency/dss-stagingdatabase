CREATE VIEW [PowerBI].[v-dss-pbi-RAG] AS 
WITH MYProfile 
(
	[Date] 
	,[Outcome ID]
	,[Outcome number] 
	,[YTD OutcomeNumber] 
)
AS 
(
	SELECT 
		[Date] 
		,[Outcome ID]
		,SUM([Outcome number]) AS [Outcome number] 
		,SUM([YTD OutcomeNumber]) AS [YTD OutcomeNumber] 
	FROM [PowerBI].[v-dss-pbi-outcomeactualfact] 
	WHERE [Outcome ID] IN (2, 6, 7) 
	GROUP BY 
		[Date] 
		,[Outcome ID]
)
SELECT 
	MY.[Date] 
	,SUM(MY.[MonthKPI]) AS [MonthKPI]
	,SUM(MY.[YTDKPI]) AS [YTDKPI]
FROM 
(
	SELECT 
		PF.[Date] 
		,AF.[Outcome ID]
		,PF.[Profile total] 
		,PF.[Profile YTD] 
		,AF.[Outcome number] 
		,AF.[YTD OutcomeNumber]
		,((AF.[Outcome number] / PF.[Profile total]) * 100) AS KPI
		,PR.ReferenceValue 
		,CASE WHEN AF.[Outcome ID] = 7 THEN 
			CASE WHEN AF.[Outcome number] > PF.[Profile total] THEN 1 
				WHEN AF.[Outcome number] = PF.[Profile total] THEN 0 
				ELSE -1 
			END 
		ELSE 
			CASE WHEN ((AF.[Outcome number] / CS.[Outcome number]) * 100) > PR.ReferenceValue THEN 1 
				WHEN ((AF.[Outcome number] / CS.[Outcome number]) * 100) = PR.ReferenceValue THEN 0 
				ELSE -1 
			END
		END AS [MonthKPI]
		,CASE WHEN AF.[Outcome ID] = 7 THEN 
			CASE WHEN AF.[YTD Outcomenumber] > PF.[Profile YTD] THEN 1 
				WHEN AF.[YTD Outcomenumber] = PF.[Profile YTD] THEN 0 
				ELSE -1
			END 
		ELSE 
			CASE WHEN ((AF.[YTD Outcomenumber] / CS.[YTD Outcomenumber]) * 100) > PR.ReferenceValue THEN 1 
				WHEN ((AF.[YTD Outcomenumber] / CS.[YTD Outcomenumber]) * 100) = PR.ReferenceValue THEN 0 
				ELSE -1
			END 
		END AS [YTDKPI]
	FROM MYProfile AS AF 
	INNER JOIN MYProfile AS CS 
	ON AF.[Date] = CS.[Date]  
	INNER JOIN 
	(
		SELECT 
			[Date] 
			,SUM([Profile total]) AS [Profile total] 
			,SUM([Profile YTD]) AS [Profile YTD] 
		FROM [PowerBI].[v-dss-pbi-outcomeprofilefact] 
		WHERE [Outcome ID] IN (7) 
		GROUP BY 
			[Date] 
	) AS PF 
	ON PF.[Date] = AF.[Date] 
	INNER JOIN [PowerBI].[v-dss-pbi-outcomedim] AS OD 
	ON AF.[Outcome ID] = OD.[Outcome ID]
	LEFT OUTER JOIN [PowerBI].[v-dss-pbi-reference] AS PR 
	ON PF.Date = PR.[DATE] 
	AND OD.[Outcome abbreviation] = PR.[ReferenceName] 
	WHERE CS.[Outcome ID] = 7 -- Customer Numbers 
) AS MY 
GROUP BY 
	MY.[Date] 
;
GO
