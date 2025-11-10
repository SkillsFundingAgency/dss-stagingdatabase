CREATE VIEW [PowerBI].[v-dss-pbi-outcomeprofilefact-summary] 
AS 
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
        FROM [PowerBI].[v-dss-pbi-outcomeprofilefact-myprofile] 
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
        FROM [PowerBI].[v-dss-pbi-outcomeprofilefact-myprofile] 
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
            ,SUM(CASE WHEN [ProfileCategory] = 'CMD' THEN 0 ELSE [OutcomeNumber] END) AS [OutcomeNumber] 
            ,SUM(CASE WHEN [ProfileCategory] = 'CMD' THEN 0 ELSE [YTD_OutcomeNumber] END) AS [YTD_OutcomeNumber] 
            ,SUM([OutcomeFinance]) AS [OutcomeFinance] 
            ,SUM([YTD_OutcomeFinance]) AS [YTD_OutcomeFinance] 
        FROM [PowerBI].[v-dss-pbi-outcomeprofilefact-myprofile] 
        WHERE [ProfileCategory] IN ('CMD', 'CMO', 'LO', 'JO', 'SF') 
        GROUP BY 
            [TouchpointID]
            ,[PriorityOrNot]
            ,[PeriodMonth]
            ,[PeriodYear] 
;
GO