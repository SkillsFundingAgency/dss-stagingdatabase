CREATE VIEW [PowerBI].[v-dss-pbi-reference] AS 
SELECT 
	PR.[ReferenceCategory] 
	,PR.[ReferenceValue] 
	,[ReferenceName]
	,PD.[DATE]
FROM [PowerBI].[dss-pbi-reference] AS PR 
INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD 
ON PD.[DATE] BETWEEN PR.[StartDateTime] AND PR.[EndDateTime] 
WHERE DATEPART(DAY, PD.[DATE]) = 1 
AND PR.[ReferenceCategory] IN ('CMO%', 'JLO%') 
;
GO 