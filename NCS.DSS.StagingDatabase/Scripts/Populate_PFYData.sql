--------------------- POPULATE [PowerBI].[pfy-dss-pbi-customercount] WITH PREVIOUS FINANCIAL YEAR DATA --------------------------- 
    TRUNCATE TABLE [PowerBI].[pfy-dss-pbi-customercount];
    INSERT INTO [PowerBI].[pfy-dss-pbi-customercount]
    SELECT  [TouchpointID],
               [PeriodYear],
               [PeriodMonth],
               [PriorityOrNot],
               [CustomerCount]
        FROM [PowerBI].[v-dss-pbi-customercount-FY] A
        INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON A.PeriodYear = PF.FinancialYear
        WHERE PF.CurrentYear IS NULL and [TouchpointID] is not null
    
--------------------- POPULATE [PowerBI].[pfy-dss-pbi-actual] WITH PREVIOUS FINANCIAL YEAR DATA --------------------------- 

    TRUNCATE TABLE [PowerBI].[pfy-dss-pbi-actual];
    INSERT INTO [PowerBI].[pfy-dss-pbi-actual]
    SELECT [RegionName],
               PF.[FinancialYear],
               [PriorityOrNot],
               [MonthShortName],
               [CustomerCount],
               [YTD_CustomerCount]
    FROM [powerbi].[v-dss-pbi-actual-FY] A
        INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON A.FinancialYear = PF.FinancialYear
    WHERE PF.CurrentYear IS NULL
       
  --------------------- POPULATE [PowerBI].[pfy-dss-pbi-contractinformation] WITH PREVIOUS FINANCIAL YEAR DATA --------------------------- 
    
    TRUNCATE TABLE [PowerBI].[pfy-dss-pbi-contractinformation];
    INSERT INTO [PowerBI].[pfy-dss-pbi-contractinformation]
    SELECT [TouchpointID],
               [ProfileCategory],
               [Date],
               [Fiscal Year],
               [ProfileCategoryValue]
        FROM [powerbi].[v-dss-pbi-contractinformation-FY] A
        INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON A.[Fiscal Year] = PF.FinancialYear
        WHERE PF.CurrentYear IS NULL
      
 --------------------- POPULATE [PowerBI].[pfy-dss-pbi-outcomeprofilevolume] WITH PREVIOUS FINANCIAL YEAR DATA --------------------------- 
    TRUNCATE TABLE [PowerBI].[pfy-dss-pbi-outcomeprofilevolume] ;
    INSERT INTO [PowerBI].[pfy-dss-pbi-outcomeprofilevolume] 
    SELECT [TouchpointID],
               [ProfileCategory],
               [PriorityOrNot],
               [PeriodMonth],
               [PeriodYear],
               [OutcomeNumber],
               [YTD_OutcomeNumber],[date]
        FROM [PowerBI].[v-dss-pbi-outcomeprofilevolume-FY] A
        INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON A.PeriodYear = PF.FinancialYear
        WHERE PF.CurrentYear IS NULL  and [TouchpointID] is not null
   
   --------------------- POPULATE [PowerBI].[pfy-dss-pbi-outcome] WITH PREVIOUS FINANCIAL YEAR DATA --------------------------- 
    
    TRUNCATE TABLE [PowerBI].[dss-pbi-outcome]
                ;
    INSERT INTO [PowerBI].[dss-pbi-outcome]
    SELECT * FROM [PowerBI].[v-dss-pbi-outcome-FY];

    TRUNCATE TABLE [PowerBI].[pfy-dss-pbi-outcome] ;
    INSERT INTO [PowerBI].[pfy-dss-pbi-outcome] 
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
    
   ---------- POPULATE [PowerBI].[pfy-dss-pbi-outcome-actualvolume] WITH PREVIOUS FINANCIAL YEAR DATA --------------
      
    TRUNCATE TABLE [PowerBI].[dss-pbi-outcomeactualvolume] ;
    INSERT INTO [PowerBI].[dss-pbi-outcomeactualvolume]
    SELECT * FROM [PowerBI].[v-dss-pbi-outcomeactualvolume-FY] WHERE TouchpointID IS NOT NULL


    TRUNCATE TABLE [PowerBI].[pfy-dss-pbi-outcome-actualvolume] ;
    INSERT INTO [PowerBI].[pfy-dss-pbi-outcome-actualvolume] 
    SELECT [TouchpointID],
               [ProfileCategory],
               [PriorityOrNot],
               [PeriodMonth],
               [DATE],
               [PeriodYear],
               [OutcomeNumber],
               [YTD_OutcomeNumber]
        FROM [PowerBI].[dss-pbi-outcomeactualvolume] AS oav
        INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON oav.[PeriodYear] = PF.FinancialYear
        WHERE PF.CurrentYear IS NULL  and [TouchpointID] is not null
  
    ---------- POPULATE [PowerBI].[pfy-dss-pbi-outcomeactualfact] WITH PREVIOUS FINANCIAL YEAR DATA --------------
    TRUNCATE TABLE [PowerBI].[pfy-dss-pbi-outcomeactualfact] ;
    INSERT INTO [PowerBI].[pfy-dss-pbi-outcomeactualfact] 
    SELECT [TouchpointID],
               [Outcome ID],
               [Group ID],
               OAC.[Date],
               [Outcome number],
               [YTD OutcomeNumber],
               [Outcome Finance],
               [YTD OutcomeFinance]
        FROM [PowerBI].[v-dss-pbi-outcomeactualfact-FY] AS OAC
        JOIN [PowerBI].[v-dss-pbi-date] AS PD ON PD.Date = OAC.Date
        WHERE PD.CurrentYear IS NULL and [TouchpointID] is not null

   ---------- POPULATE [PowerBI].[pfy-dss-pbi-conversionrate] WITH PREVIOUS FINANCIAL YEAR DATA --------------
    TRUNCATE TABLE [PowerBI].[pfy-dss-pbi-conversionrate] ;
    INSERT INTO [PowerBI].[pfy-dss-pbi-conversionrate] 
    SELECT [TouchpointID],
               [Outcome ID],
               cr.[Date],
               [Performance],
               [Performance YTD]
        FROM [PowerBI].[v-dss-pbi-conversionrate-FY] AS cr
        INNER JOIN PowerBI.[v-dss-pbi-date] AS pd ON pd.Date = cr.Date
        WHERE pd.CurrentYear IS NULL
  