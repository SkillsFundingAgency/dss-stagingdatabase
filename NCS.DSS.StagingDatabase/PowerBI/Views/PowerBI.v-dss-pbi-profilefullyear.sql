CREATE VIEW [PowerBI].[v-dss-pbi-profilefullyear] 
AS 
    SELECT 
        A.[TouchpointID] 
        ,A.[Fiscal Year] 
        ,A.[DATE] 
        ,A.[Outcome ID] 
        ,A.[Group ID] 
        ,B.[Profile Full Year]
        ,B.[Financial Profile Full Year] 
    FROM [PowerBI].[v-dss-pbi-profilefullyear-myprofile] AS A 
    INNER JOIN [PowerBI].[v-dss-pbi-profilefullyear-myprofile] AS B 
    ON A.[TouchpointID] = B.[TouchpointID] 
    AND A.[Fiscal Year] = B.[Fiscal Year] 
    AND A.[Outcome ID] = B.[Outcome ID] 
    AND A.[Group ID] = B.[Group ID] 
    WHERE B.[Fiscal Month Number] = 12 
;
GO