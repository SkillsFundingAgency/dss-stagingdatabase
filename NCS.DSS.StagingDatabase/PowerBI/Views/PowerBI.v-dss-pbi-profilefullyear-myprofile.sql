CREATE VIEW [PowerBI].[v-dss-pbi-profilefullyear-myprofile] 
AS 
    
    SELECT 
        PP.[TouchpointID] 
        ,PT.[Fiscal Year] 
        ,PT.[DATE] 
        ,PT.[Fiscal Month Number] 
        ,PP.[Outcome ID] 
        ,PP.[Group ID] 
        ,PP.[Profile YTD] AS [Profile Full Year]
        ,PP.[Financial Profile YTD] AS [Financial Profile Full Year] 
    FROM [PowerBI].[v-dss-pbi-outcomeprofilefact] AS PP 
    INNER JOIN [PowerBI].[v-dss-pbi-date] AS PT 
    ON PT.[DATE] = PP.[Date];
GO