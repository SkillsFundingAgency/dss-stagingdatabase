CREATE PROCEDURE [PowerBI].[Populate_PFY_Data]
	@param1 int
AS
    --------------------- POPULATE [PowerBI].[pfy-dss-pbi-actual] WITH PREVIOUS FINANCIAL YEAR DATA --------------------------- 
    MERGE INTO [PowerBI].[pfy-dss-pbi-actual] AS Target
    USING (
        SELECT [RegionName],
               PF.[FinancialYear],
               [PriorityOrNot],
               [MonthShortName],
               SUM([CustomerCount]) AS [CustomerCount],
               SUM([YTD_CustomerCount]) AS [YTD_CustomerCount]
        FROM [powerbi].[v-dss-pbi-actual] A
        INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON A.FinancialYear = PF.FinancialYear
        WHERE PF.CurrentYear IS NULL
        GROUP BY [RegionName], PF.[FinancialYear], [PriorityOrNot], [MonthShortName]
    ) AS Source
    ON Target.[RegionName] = Source.[RegionName]
       AND Target.[FinancialYear] = Source.[FinancialYear]
       AND Target.[PriorityOrNot] = Source.[PriorityOrNot]
       AND Target.[MonthShortName] = Source.[MonthShortName]
    WHEN MATCHED THEN
        UPDATE SET Target.[CustomerCount] = Source.[CustomerCount],
                   Target.[YTD_CustomerCount] = Source.[YTD_CustomerCount]
    WHEN NOT MATCHED BY TARGET THEN
        INSERT ([RegionName], [FinancialYear], [PriorityOrNot], [MonthShortName], [CustomerCount], [YTD_CustomerCount])
        VALUES (Source.[RegionName], Source.[FinancialYear], Source.[PriorityOrNot], Source.[MonthShortName], Source.[CustomerCount], Source.[YTD_CustomerCount]);
    --------------------- POPULATE [PowerBI].[pfy-dss-pbi-contractinformation] WITH PREVIOUS FINANCIAL YEAR DATA --------------------------- 
    
    MERGE INTO [PowerBI].[pfy-dss-pbi-contractinformation] AS Target
    USING (
        SELECT [TouchpointID],
               [ProfileCategory],
               [Date],
               [Fiscal Year],
               [ProfileCategoryValue]
        FROM [powerbi].[v-dss-pbi-contractinformation] A
        INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON A.[Fiscal Year] = PF.FinancialYear
        WHERE PF.CurrentYear IS NULL
    ) AS Source
    ON Target.[TouchpointID] = Source.[TouchpointID]
       AND Target.[ProfileCategory] = Source.[ProfileCategory]
       AND Target.[Date] = Source.[Date]
       AND Target.[Fiscal Year] = Source.[Fiscal Year]
    WHEN MATCHED THEN
        UPDATE SET Target.[ProfileCategoryValue] = Source.[ProfileCategoryValue]
    WHEN NOT MATCHED BY TARGET THEN
        INSERT ([TouchpointID], [ProfileCategory], [Date], [Fiscal Year], [ProfileCategoryValue])
        VALUES (Source.[TouchpointID], Source.[ProfileCategory], Source.[Date], Source.[Fiscal Year], Source.[ProfileCategoryValue]);

    --------------------- POPULATE [PowerBI].[pfy-dss-pbi-customercount] WITH PREVIOUS FINANCIAL YEAR DATA --------------------------- 
   
 MERGE INTO [PowerBI].[pfy-dss-pbi-customercount] AS Target
    USING (
        SELECT [TouchpointID],
               [PeriodYear],
               [PeriodMonth],
               [PriorityOrNot],
               [CustomerCount]
        FROM [PowerBI].[v-dss-pbi-customercount] A
        INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON A.PeriodYear = PF.FinancialYear
        WHERE PF.CurrentYear IS NULL
    ) AS Source
    ON Target.[TouchpointID] = Source.[TouchpointID]
       AND Target.[PeriodYear] = Source.[PeriodYear]
       AND Target.[PeriodMonth] = Source.[PeriodMonth]
       AND Target.[PriorityOrNot] = Source.[PriorityOrNot]
    WHEN MATCHED THEN
        UPDATE SET Target.[CustomerCount] = Source.[CustomerCount]
    WHEN NOT MATCHED BY TARGET THEN
        INSERT ([TouchpointID], [PeriodYear], [PeriodMonth], [PriorityOrNot], [CustomerCount])
        VALUES (Source.[TouchpointID], Source.[PeriodYear], Source.[PeriodMonth], Source.[PriorityOrNot], Source.[CustomerCount]);
            
    --------------------- POPULATE [PowerBI].[pfy-dss-pbi-outcomeprofilevolume] WITH PREVIOUS FINANCIAL YEAR DATA --------------------------- 
    
    
     MERGE INTO [PowerBI].[pfy-dss-pbi-outcomeprofilevolume] AS Target
    USING (
        SELECT [TouchpointID],
               [ProfileCategory],
               [PriorityOrNot],
               [PeriodMonth],
               [PeriodYear],
               [OutcomeNumber],
               [YTD_OutcomeNumber]
        FROM [PowerBI].[v-dss-pbi-outcomeprofilevolume] A
        INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON A.PeriodYear = PF.FinancialYear
        WHERE PF.CurrentYear IS NULL
    ) AS Source
    ON Target.[TouchpointID] = Source.[TouchpointID]
       AND Target.[ProfileCategory] = Source.[ProfileCategory]
       AND Target.[PriorityOrNot] = Source.[PriorityOrNot]
       AND Target.[PeriodMonth] = Source.[PeriodMonth]
       AND Target.[PeriodYear] = Source.[PeriodYear]
    WHEN MATCHED THEN
        UPDATE SET Target.[OutcomeNumber] = Source.[OutcomeNumber],
                   Target.[YTD_OutcomeNumber] = Source.[YTD_OutcomeNumber]
    WHEN NOT MATCHED BY TARGET THEN
        INSERT ([TouchpointID], [ProfileCategory], [PriorityOrNot], [PeriodMonth], [PeriodYear], [OutcomeNumber], [YTD_OutcomeNumber])
        VALUES (Source.[TouchpointID], Source.[ProfileCategory], Source.[PriorityOrNot], Source.[PeriodMonth], Source.[PeriodYear], Source.[OutcomeNumber], Source.[YTD_OutcomeNumber]);

   --------------------- POPULATE [PowerBI].[pfy-dss-pbi-outcome] WITH PREVIOUS FINANCIAL YEAR DATA --------------------------- 
    
MERGE INTO [PowerBI].[pfy-dss-pbi-outcome] AS Target
    USING (
        SELECT [TouchpointID],
               [PriorityOrNot],
               [OutcomeTypeValue],
               [OutcomeTypeGroup],
               [PeriodMonth],
               [PeriodYear],
               [OutcomeNumber]
        FROM [PowerBI].[dss-pbi-outcome] O
        INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON O.[PeriodYear] = PF.FinancialYear
        WHERE PF.CurrentYear IS NULL
    ) AS Source
    ON Target.[TouchpointID] = Source.[TouchpointID]
       AND Target.[PriorityOrNot] = Source.[PriorityOrNot]
       AND Target.[OutcomeTypeValue] = Source.[OutcomeTypeValue]
       AND Target.[OutcomeTypeGroup] = Source.[OutcomeTypeGroup]
       AND Target.[PeriodMonth] = Source.[PeriodMonth]
       AND Target.[PeriodYear] = Source.[PeriodYear]
    WHEN MATCHED THEN
        UPDATE SET Target.[OutcomeNumber] = Source.[OutcomeNumber]
    WHEN NOT MATCHED BY TARGET THEN
        INSERT ([TouchpointID], [PriorityOrNot], [OutcomeTypeValue], [OutcomeTypeGroup], [PeriodMonth], [PeriodYear], [OutcomeNumber])
        VALUES (Source.[TouchpointID], Source.[PriorityOrNot], Source.[OutcomeTypeValue], Source.[OutcomeTypeGroup], Source.[PeriodMonth], Source.[PeriodYear], Source.[OutcomeNumber]);
           

    ---------- POPULATE [PowerBI].[pfy-dss-pbi-outcome-actualvolume] WITH PREVIOUS FINANCIAL YEAR DATA --------------
 MERGE INTO [PowerBI].[pfy-dss-pbi-outcome-actualvolume] AS Target
    USING (
        SELECT [TouchpointID],
               [ProfileCategory],
               [PriorityOrNot],
               [PeriodMonth],
               [DATE],
               [PeriodYear],
               [OutcomeNumber],
               [YTD_OutcomeNumber]
        FROM [PowerBI].[fun-dss-pbi-outcomeactualvolume]() AS oav
        INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON oav.[PeriodYear] = PF.FinancialYear
        WHERE PF.CurrentYear IS NULL
    ) AS Source
    ON Target.[TouchpointID] = Source.[TouchpointID]
       AND Target.[ProfileCategory] = Source.[ProfileCategory]
       AND Target.[PriorityOrNot] = Source.[PriorityOrNot]
       AND Target.[PeriodMonth] = Source.[PeriodMonth]
       AND Target.[DATE] = Source.[DATE]
       AND Target.[PeriodYear] = Source.[PeriodYear]
    WHEN MATCHED THEN
        UPDATE SET Target.[OutcomeNumber] = Source.[OutcomeNumber],
                   Target.[YTD_OutcomeNumber] = Source.[YTD_OutcomeNumber]
    WHEN NOT MATCHED BY TARGET THEN
        INSERT ([TouchpointID], [ProfileCategory], [PriorityOrNot], [PeriodMonth], [DATE], [PeriodYear], [OutcomeNumber], [YTD_OutcomeNumber])
        VALUES (Source.[TouchpointID], Source.[ProfileCategory], Source.[PriorityOrNot], Source.[PeriodMonth], Source.[DATE], Source.[PeriodYear], Source.[OutcomeNumber], Source.[YTD_OutcomeNumber]);

    ---------- POPULATE [PowerBI].[pfy-dss-pbi-outcomeactualfact] WITH PREVIOUS FINANCIAL YEAR DATA --------------
   MERGE INTO [PowerBI].[pfy-dss-pbi-outcomeactualfact] AS Target
    USING (
        SELECT [TouchpointID],
               [Outcome ID],
               [Group ID],
               OAC.[Date],
               [Outcome number],
               [YTD OutcomeNumber],
               [Outcome Finance],
               [YTD OutcomeFinance]
        FROM [PowerBI].[v-dss-pbi-outcomeactualfact] AS OAC
        JOIN [PowerBI].[v-dss-pbi-date] AS PD ON PD.Date = OAC.Date
        WHERE PD.CurrentYear IS NULL
    ) AS Source
    ON Target.[TouchpointID] = Source.[TouchpointID]
       AND Target.[Outcome ID] = Source.[Outcome ID]
       AND Target.[Group ID] = Source.[Group ID]
       AND Target.[Date] = Source.[Date]
    WHEN MATCHED THEN
        UPDATE SET Target.[OutcomeNumber] = Source.[Outcome number],
                   Target.[YTD OutcomeNumber] = Source.[YTD OutcomeNumber],
                   Target.[OutcomeFinance] = Source.[Outcome Finance],
                   Target.[YTD OutcomeFinance] = Source.[YTD OutcomeFinance]
    WHEN NOT MATCHED BY TARGET THEN
        INSERT ([TouchpointID], [Outcome ID], [Group ID], [Date], [OutcomeNumber], [YTD OutcomeNumber], [OutcomeFinance], [YTD OutcomeFinance])
        VALUES (Source.[TouchpointID], Source.[Outcome ID], Source.[Group ID], Source.[Date], Source.[Outcome number], Source.[YTD OutcomeNumber], Source.[Outcome Finance], Source.[YTD OutcomeFinance]);
    ---------- POPULATE [PowerBI].[pfy-dss-pbi-conversionrate] WITH PREVIOUS FINANCIAL YEAR DATA --------------
   MERGE INTO [PowerBI].[pfy-dss-pbi-conversionrate] AS Target
    USING (
        SELECT [TouchpointID],
               [Outcome ID],
               cr.[Date],
               [Performance],
               [Performance YTD]
        FROM [PowerBI].[v-dss-pbi-conversionrate] AS cr
        INNER JOIN PowerBI.[v-dss-pbi-date] AS pd ON pd.Date = cr.Date
        WHERE pd.CurrentYear IS NULL
    ) AS Source
    ON Target.[TouchpointID] = Source.[TouchpointID]
       AND Target.[Outcome ID] = Source.[Outcome ID]
       AND Target.[Date] = Source.[Date]
    WHEN MATCHED THEN
        UPDATE SET Target.[Performance] = Source.[Performance],
                   Target.[Performance YTD] = Source.[Performance YTD]
    WHEN NOT MATCHED BY TARGET THEN
        INSERT ([TouchpointID], [Outcome ID], [Date], [Performance], [Performance YTD])
        VALUES (Source.[TouchpointID], Source.[Outcome ID], Source.[Date], Source.[Performance], Source.[Performance YTD]);

RETURN;

