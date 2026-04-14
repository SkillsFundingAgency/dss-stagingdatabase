CREATE VIEW [PowerBI].[v-dss-pbi-conversionrate] 
AS 
SELECT [TouchpointID]
      ,[Outcome ID]
      ,[Date]
      ,[Performance]
      ,[Performance YTD]
  FROM [PowerBI].[pfy-dss-pbi-conversionrate] 
UNION ALL
SELECT 
	AF.[TouchpointID]
	,AF.[Outcome ID]
	,AF.[Date]
	,ROUND((AF.[Outcome number] / IIF(PF.[Outcome number] = 0, 1, PF.[Outcome number])) * 100, 2) AS [Performance] 
	,ROUND(((AF.[YTD Outcome number]+DC.[YTD Outcome number])/ IIF(PF.[YTD Outcome number] = 0, 1, PF.[YTD Outcome number])) * 100, 2) AS [Performance YTD] 
FROM 
[PowerBI].[v-dss-pbi-conversionrate-myprofile] as AF
INNER JOIN 
[PowerBI].[v-dss-pbi-conversionrate-myprofile] AS PF     
ON AF.[TouchpointID] = PF.[TouchpointID] 
AND AF.[Date] = PF.[Date] 
Left JOIN 
[PowerBI].[v-dss-pbi-conversionrate-myprofile] AS DC     
ON AF.[TouchpointID] = DC.[TouchpointID] 
AND AF.[Date] = DC.[Date] 
and DC.[Outcome ID]=8
WHERE PF.[Outcome ID] = 7 -- Customer Numbers
;
GO


