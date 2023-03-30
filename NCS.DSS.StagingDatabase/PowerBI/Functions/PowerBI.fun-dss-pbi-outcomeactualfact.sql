CREATE FUNCTION [PowerBI].[fun-dss-pbi-outcomeactualfact] ()
RETURNS @retTable TABLE (
    [TouchpointID] INT
	,[Outcome ID] INT
	,[Group ID] INT
	,[DATE] DATETIME
	,[Outcome number] DECIMAL(9,2)
	,[YTD OutcomeNumber] DECIMAL(9,2)
	,[Outcome Finance] DECIMAL(11,2)
	,[YTD OutcomeFinance] DECIMAL(11,2)
)
AS 
BEGIN
    DECLARE @MYProfile TABLE
    (
        [TouchpointID] INT
        ,[ProfileCategory] VARCHAR(4)
        ,[PriorityOrNot] VARCHAR(2)
        ,[PeriodMonth] INT	
        ,[Date] DATETIME
        ,[PeriodYear] VARCHAR(9)
        ,[OutcomeNumber] DECIMAL(9,2)
        ,[YTD_OutcomeNumber] DECIMAL(9,2)
        ,[OutcomeFinance] DECIMAL(11,2)
        ,[YTD_OutcomeFinance] DECIMAL(11,2) 
    ) 
    INSERT INTO @MYProfile
        SELECT 
            PO.[TouchpointID] 
            ,PO.[ProfileCategory] 
            ,PO.[PriorityOrNot]
            ,PO.[PeriodMonth]
            ,PO.[Date]
            ,PO.[PeriodYear] 
            ,PO.[OutcomeNumber] 
            ,PO.[YTD_OutcomeNumber]
            ,(PO.[OutcomeNumber] * PC.[ProfileCategoryValue]) AS [OutcomeFinance]
            ,(PO.[YTD_OutcomeNumber] * PC.[ProfileCategoryValue]) AS [YTD_OutcomeFinance]
        FROM [PowerBI].[fun-dss-pbi-outcomeactualvolume]() AS PO 
        LEFT OUTER JOIN [PowerBI].[v-dss-pbi-contractrate] AS PC 
        ON PO.[TouchpointID] = PC.[TouchpointID] 
        AND PO.[PriorityOrNot] = PC.[PriorityOrNot]
        AND CASE WHEN PO.[ProfileCategory] IN ('CP', 'SE') THEN 'JO' ELSE PO.[ProfileCategory] END = PC.[ProfileCategory] 
        AND PO.[PeriodYear] = PC.[FinancialYear] 
        AND PO.[Date] = PC.[Date] 
        WHERE PO.[ProfileCategory] IN 
        (
            'CMD' 
            ,'CMO'
            ,'CSO'
            ,'JO'
            ,'CP'
            ,'SE'
            ,'CUS'
            ,'LO'
        )
        UNION ALL 
        SELECT 
            PPP.[TouchpointID] 
            ,'SF' AS [ProfileCategory] 
            ,'PG' AS [PriorityOrNot] 
            ,PD.[Fiscal Month Number] AS [PeriodMonth] 
            ,PD.[Date]
            ,PD.[Fiscal Year] AS [PeriodYear] 
            ,NULL AS [OutcomeNumber] 
            ,NULL AS [YTD_OutcomeNumber] 
            ,PPP.[ProfileCategoryValue] AS [OutcomeFinance] 
            ,PPP.[ProfileCategoryValueYTD] AS [YTD_OutcomeFinance] 
        FROM [PowerBI].[v-dss-pbi-servicefee] AS PPP 
        INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD 
        ON PPP.[Date] = PD.[Date] ;

    INSERT INTO @retTable
    SELECT 
        PO.[TouchpointID] AS 'TouchpointID'
        ,PD.[Outcome ID] AS 'Outcome ID'
        ,PG.[Group ID] AS 'Group ID'
        ,PT.[DATE] AS 'Date'
        ,PO.[OutcomeNumber] AS [Outcome number]
        ,PO.[YTD_OutcomeNumber] AS [YTD OutcomeNumber]
        ,PO.[OutcomeFinance] AS [Outcome Finance]
        ,PO.[YTD_OutcomeFinance] AS [YTD OutcomeFinance] 
    FROM 
    (
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
        FROM @MYProfile 
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
        FROM @MYProfile 
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
            ,SUM(CASE WHEN [ProfileCategory] IN ('CMD', 'SF') THEN 0 ELSE [OutcomeNumber] END) AS [OutcomeNumber] --CMD are already included in CMO 
            ,SUM(CASE WHEN [ProfileCategory] IN ('CMD', 'SF') THEN 0 ELSE [YTD_OutcomeNumber] END) AS [YTD_OutcomeNumber] --SF have no outcomes
            ,SUM([OutcomeFinance]) AS [OutcomeFinance] 
            ,SUM([YTD_OutcomeFinance]) AS [YTD_OutcomeFinance] 
        FROM @MYProfile 
        WHERE [ProfileCategory] IN ('CMD', 'CMO', 'LO', 'JO', 'SF') 
        GROUP BY 
            [TouchpointID]
            ,[PriorityOrNot]
            ,[PeriodMonth]
            ,[PeriodYear] 
    ) AS PO 
    INNER JOIN [PowerBI].[v-dss-pbi-groupdim] AS PG 
    ON PO.[PriorityOrNot] = PG.[Group abbreviation]
    INNER JOIN [PowerBI].[v-dss-pbi-outcomedim] AS PD 
    ON PO.[ProfileCategory] = PD.[Outcome abbreviation]
    INNER JOIN [PowerBI].[v-dss-pbi-date] AS PT 
    ON PO.[PeriodYear] = PT.[Fiscal Year] 
    AND PO.[PeriodMonth] = PT.[Fiscal Month Number] 
    WHERE DATEPART(DAY, PT.[DATE]) = 1 
    AND PT.[DATE] >= CONVERT(DATETIME, '01-10-2022', 103);

    RETURN; 

END
