CREATE VIEW [PowerBI].[v-dss-pbi-contractrate] 
AS 
    SELECT 
        DP.[TouchpointID] 
        ,DP.[PriorityOrNot] 
        ,DR.[ReferenceName] 
        ,CASE WHEN RIGHT(DP.[ProfileCategory], 1) = 'R' THEN 
            CONCAT(SUBSTRING(DP.[ProfileCategory], 1, LEN(DP.[ProfileCategory]) - 1), 'O') 
        ELSE 
            DP.[ProfileCategory]
        END AS [ProfileCategory]
        ,DP.[ProfileCategoryValue] 
        ,PD.[Date] 
        ,DP.[FinancialYear]
    FROM [PowerBI].[dss-pbi-primeprofile] AS DP 
    INNER JOIN [PowerBI].[dss-pbi-reference] AS DR 
    ON DP.[ProfileCategory] = DR.[ReferenceCategory] 
    INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD 
    ON PD.[Date] BETWEEN DP.[StartDateTime] AND DP.[EndDateTime] 
    WHERE DP.[ProfileCategory] IN ('CMD', 'CMR', 'JR', 'LR') 
    AND DAY(PD.[Date]) = 1 
;
GO