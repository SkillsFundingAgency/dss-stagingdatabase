CREATE VIEW [PowerBI].[v-dss-pbi-profilefullyear] 
AS 
    WITH MYProfile 
    (
        [TouchpointID] 
        ,[Fiscal Year] 
        ,[DATE] 
        ,[Fiscal Month Number] 
        ,[Outcome ID] 
        ,[Group ID] 
        ,[Profile Full Year]
        ,[Financial Profile Full Year] 
    ) 
    AS 
    (
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
        ON PT.[DATE] = PP.[Date] 
    ) 

    SELECT 
        A.[TouchpointID] 
        ,A.[Fiscal Year] 
        ,A.[DATE] 
        ,A.[Outcome ID] 
        ,A.[Group ID] 
        ,B.[Profile Full Year]
        ,B.[Financial Profile Full Year] 
    FROM MYProfile AS A 
    INNER JOIN MYProfile AS B 
    ON A.[TouchpointID] = B.[TouchpointID] 
    AND A.[Fiscal Year] = B.[Fiscal Year] 
    AND A.[Outcome ID] = B.[Outcome ID] 
    AND A.[Group ID] = B.[Group ID] 
    WHERE B.[Fiscal Month Number] = 12 
;
GO