CREATE VIEW [PowerBI].[v-dss-pbi-overallconversionrate] 
AS 
SELECT 
	AF.[Outcome ID]
	,AF.[Date]
	,ROUND((AF.[Outcome number] / IIF(PF.[Outcome number] = 0, 1, PF.[Outcome number])) * 100, 2) AS [Performance] 
	,ROUND((AF.[YTD Outcome number] / IIF(PF.[YTD Outcome number] = 0, 1, PF.[YTD Outcome number])) * 100, 2) AS [Performance YTD] 
FROM 
[PowerBI].[v-dss-pbi-overallconversionrate-myprofile] AS AF 
INNER JOIN 
(
	SELECT *
	FROM [PowerBI].[v-dss-pbi-overallconversionrate-myprofile] 
    WHERE [Outcome ID] = 7 -- Customer Numbers
) AS PF 
ON AF.[Date] = PF.[Date] 
;
GO
