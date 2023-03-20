CREATE VIEW [PowerBI].[v-dss-pbi-contractinformation] 
AS 
    WITH myQuery AS
    (
        SELECT 
            AF.[TouchpointID] 
            ,'03. Value Achieved YTD' AS [ProfileCategory]
            ,PD.[Date] 
            ,PD.[Fiscal Year]
            ,SUM(CASE WHEN AF.[Outcome ID] = 11 THEN 
                    AF.[YTD OutcomeFinance] * ((100 - SE.[ReferenceValue]) / 100)
                ELSE 
                    AF.[YTD OutcomeFinance] 
                END ) AS [ProfileCategoryValue] 
        FROM [PowerBI].[v-dss-pbi-outcomeactualfact] AS AF 
        INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD 
        ON AF.[Date] = PD.[Date] 
        LEFT OUTER JOIN [PowerBI].[dss-pbi-servicefeededuction] AS SE 
        ON AF.[TouchpointID] = SE.[TouchpointID] 
        AND AF.[Date] = SE.[CalendarDate] 
        WHERE AF.[Outcome ID] IN (10, 11) 
        GROUP BY 
            AF.[TouchpointID] 
            ,PD.[Date] 
            ,PD.[Fiscal Year]
        UNION ALL
        SELECT 
            AF.[TouchpointID] 
            ,'02. YTD Profile Value' AS [ProfileCategory]
            ,PD.[Date] 
            ,PD.[Fiscal Year]
            ,SUM(AF.[Financial Profile YTD]) AS [ProfileCategoryValue] 
        FROM [PowerBI].[v-dss-pbi-outcomeprofilefact] AS AF 
        INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD 
        ON AF.[Date] = PD.[Date] 
        WHERE AF.[Outcome ID] IN (10, 11) 
        GROUP BY 
            AF.[TouchpointID] 
            ,PD.[Date] 
            ,PD.[Fiscal Year]
    )

    SELECT 
            PP.[TouchpointID] 
            ,'01. Total Profile Value' AS [ProfileCategory]
            ,PD.[Date] 
            ,PD.[Fiscal Year]
            ,SUM(PP.[ProfileCategoryValue]) AS [ProfileCategoryValue] 
        FROM [PowerBI].[dss-pbi-primeprofile] AS PP 
        INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD 
        ON PD.[Date] BETWEEN PP.[StartDateTime] AND PP.[EndDateTime] 
        WHERE DAY(PD.[Date]) = 1 
        AND PP.[FinancialsOrNot] = 1 
        AND PP.[ProfileCategory] IN ('CMO', 'CMD', 'JO', 'LO', 'SF') 
        GROUP BY 
            PP.[TouchpointID] 
            ,PD.[Date] 
            ,PD.[Fiscal Year]

    UNION ALL
    Select [TouchpointID] 
            ,[ProfileCategory]
            ,[Date] 
            ,[Fiscal Year]
            ,[ProfileCategoryValue]  
    from myQuery
    UNION ALL
    Select  a.[TouchpointID] 
            ,'04. Over/Underspend' as [ProfileCategory]
            ,a.[Date] 
            ,a.[Fiscal Year]
            ,(a.[ProfileCategoryValue] - b.[ProfileCategoryValue]) as [ProfileCategoryValue]  
    from myQuery as  a
    INNER JOIN myQuery as b ON a.[TouchpointID] = b.[TouchpointID] 
        AND a.[Date] = b.[Date] 
        AND a.[Fiscal Year] = b.[Fiscal Year]
    WHERE a.[ProfileCategory] = '03. Value Achieved YTD'
    AND b.[ProfileCategory] = '02. YTD Profile Value'
    UNION ALL

    Select  a.[TouchpointID] 
            ,'05. Overall % ' as [ProfileCategory]
            ,a.[Date] 
            ,a.[Fiscal Year]
            ,ROUND ((a.[ProfileCategoryValue] / b.[ProfileCategoryValue]) * 100,2) as [ProfileCategoryValue]  
    from myQuery as  a
    INNER JOIN myQuery as b ON a.[TouchpointID] = b.[TouchpointID] 
        AND a.[Date] = b.[Date] 
        AND a.[Fiscal Year] = b.[Fiscal Year]
    WHERE a.[ProfileCategory] = '03. Value Achieved YTD'
    AND b.[ProfileCategory] = '02. YTD Profile Value'
GO