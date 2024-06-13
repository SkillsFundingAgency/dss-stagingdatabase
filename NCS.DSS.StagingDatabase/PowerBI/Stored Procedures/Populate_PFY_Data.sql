CREATE PROCEDURE [PowerBI].[Populate_PFY_Data]
	@param1 int
AS
    --------------------- POPULATE [PowerBI].[pfy-dss-pbi-actual] WITH PREVIOUS FINANCIAL YEAR DATA --------------------------- 
    
	TRUNCATE TABLE [PowerBI].[pfy-dss-pbi-actual];

    INSERT INTO [PowerBI].[pfy-dss-pbi-actual]
               ([RegionName]
               ,[FinancialYear]
               ,[PriorityOrNot]
               ,[MonthShortName]
               ,[CustomerCount]
               ,[YTD_CustomerCount])
 
    SELECT [RegionName]
               ,PF.[FinancialYear]
               ,[PriorityOrNot]
               ,[MonthShortName]
               ,[CustomerCount]
               ,[YTD_CustomerCount] 
    FROM [powerbi].[v-dss-pbi-actual] A
    INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON A.FinancialYear=PF.FinancialYear
    WHERE PF.CurrentYear is null;
    --------------------- POPULATE [PowerBI].[pfy-dss-pbi-contractinformation] WITH PREVIOUS FINANCIAL YEAR DATA --------------------------- 
    
    Truncate TABLE [PowerBI].[pfy-dss-pbi-contractinformation];

    INSERT INTO [PowerBI].[pfy-dss-pbi-contractinformation]
               ([TouchpointID]
               ,[ProfileCategory]
               ,[Date]
               ,[Fiscal Year]
               ,[ProfileCategoryValue])
    SELECT [TouchpointID]
               ,[ProfileCategory]
               ,[Date]
               ,[Fiscal Year]
               ,[ProfileCategoryValue] 
    FROM [powerbi].[v-dss-pbi-contractinformation] A
	INNER JOIN [PowerBI].[dss-pbi-financialyear] PF on A.[Fiscal Year]=PF.FinancialYear
    WHERE PF.CurrentYear is null
    --------------------- POPULATE [PowerBI].[pfy-dss-pbi-customercount] WITH PREVIOUS FINANCIAL YEAR DATA --------------------------- 
    TRUNCATE TABLE [PowerBI].[pfy-dss-pbi-customercount];
    INSERT INTO [PowerBI].[pfy-dss-pbi-customercount]
               ([TouchpointID]
               ,[PeriodYear]
               ,[PeriodMonth]
               ,[PriorityOrNot]
               ,[CustomerCount])
    SELECT [TouchpointID]
               ,[PeriodYear]
               ,[PeriodMonth]
               ,[PriorityOrNot]
               ,[CustomerCount] 
    FROM [PowerBI].[v-dss-pbi-customercount]  A
	INNER JOIN [PowerBI].[dss-pbi-financialyear] PF on A.PeriodYear=PF.FinancialYear
    WHERE PF.CurrentYear is null
    
    --------------------- POPULATE [PowerBI].[pfy-dss-pbi-outcomeprofilevolume] WITH PREVIOUS FINANCIAL YEAR DATA --------------------------- 
    TRUNCATE TABLE [PowerBI].[pfy-dss-pbi-outcomeprofilevolume];

    INSERT INTO [PowerBI].[pfy-dss-pbi-outcomeprofilevolume]
               ([TouchpointID]
               ,[ProfileCategory]
               ,[PriorityOrNot]
               ,[PeriodMonth]
               ,[PeriodYear]
               ,[OutcomeNumber]
               ,[YTD_OutcomeNumber])
    SELECT   [TouchpointID]
            ,[ProfileCategory]
            ,[PriorityOrNot]
            ,[PeriodMonth]
            ,[PeriodYear] 
            ,[OutcomeNumber] 
            ,[YTD_OutcomeNumber] 
    FROM  [PowerBI].[v-dss-pbi-outcomeprofilevolume] A
    INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON   A.PeriodYear=PF.FinancialYear
    WHERE PF.CurrentYear is null

    --------------------- POPULATE [PowerBI].[pfy-dss-pbi-outcome] WITH PREVIOUS FINANCIAL YEAR DATA --------------------------- 
    
    TRUNCATE TABLE [PowerBI].[pfy-dss-pbi-outcome];
    
    INSERT INTO [PowerBI].[pfy-dss-pbi-outcome] (
	     [TouchpointID]
	    ,[PriorityOrNot]
	    ,[OutcomeTypeValue]
	    ,[OutcomeTypeGroup]
	    ,[PeriodMonth]
	    ,[PeriodYear]
	    ,[OutcomeNumber]
    )
    Select [TouchpointID]
	    ,[PriorityOrNot]
	    ,[OutcomeTypeValue]
	    ,[OutcomeTypeGroup]
	    ,[PeriodMonth]
	    ,[PeriodYear] 
	    ,[OutcomeNumber]
    from [PowerBI].[dss-pbi-outcome] O
    inner join [PowerBI].[dss-pbi-financialyear] PF on
    O.[PeriodYear]=PF.FinancialYear
    where PF.CurrentYear is null;
    

    ---------- POPULATE [PowerBI].[pfy-dss-pbi-outcome-actualvolume] WITH PREVIOUS FINANCIAL YEAR DATA --------------

    TRUNCATE TABLE [PowerBI].[pfy-dss-pbi-outcome-actualvolume];
    
    INSERT INTO [PowerBI].[pfy-dss-pbi-outcome-actualvolume]  ( 
        [TouchpointID]
	    ,[ProfileCategory]
	    ,[PriorityOrNot]
	    ,[PeriodMonth]
	    ,[DATE]
	    ,[PeriodYear]
	    ,[OutcomeNumber]
	    ,[YTD_OutcomeNumber]
    )

    SELECT 
        [TouchpointID]
	    ,[ProfileCategory]
	    ,[PriorityOrNot]
	    ,[PeriodMonth]
	    ,[DATE]
	    ,[PeriodYear]
	    ,[OutcomeNumber]
	    ,[YTD_OutcomeNumber]
    FROM [PowerBI].[fun-dss-pbi-outcomeactualvolume] () as oav
    inner join [PowerBI].[dss-pbi-financialyear] PF on
    oav.[PeriodYear]=PF.FinancialYear
    where PF.CurrentYear is null;


    ---------- POPULATE [PowerBI].[pfy-dss-pbi-outcomeactualfact] WITH PREVIOUS FINANCIAL YEAR DATA --------------
    TRUNCATE TABLE [PowerBI].[pfy-dss-pbi-outcomeactualfact];
    

    INSERT INTO [PowerBI].[pfy-dss-pbi-outcomeactualfact]  ( 
        [TouchpointID]
	    ,[Outcome ID]
	    ,[Group ID]
	    ,[Date]
	    ,[OutcomeNumber]
	    ,[YTD OutcomeNumber]
	    ,[OutcomeFinance]
	    ,[YTD OutcomeFinance] 
    )
    SELECT  [TouchpointID]
	    ,[Outcome ID]
	    ,[Group ID]
	    ,OAC.[Date]
	    ,[Outcome number]
	    ,[YTD OutcomeNumber]
	    ,[Outcome Finance]
	    ,[YTD OutcomeFinance] 
      FROM [PowerBI].[v-dss-pbi-outcomeactualfact] as OAC
      JOIN [PowerBI].[v-dss-pbi-date] AS PD ON PD.Date = OAC.Date AND PD.CurrentYear IS NULL;

    ---------- POPULATE [PowerBI].[pfy-dss-pbi-conversionrate] WITH PREVIOUS FINANCIAL YEAR DATA --------------
    TRUNCATE TABLE [PowerBI].[pfy-dss-pbi-conversionrate];
    
    INSERT INTO [PowerBI].[pfy-dss-pbi-conversionrate]  ( 
        [TouchpointID]
	    ,[Outcome ID]
	    ,[Date]
	     ,[Performance]
         ,[Performance YTD]
    )
    SELECT [TouchpointID]
          ,[Outcome ID]
          ,cr.[Date]
          ,[Performance]
          ,[Performance YTD]
      FROM [PowerBI].[v-dss-pbi-conversionrate] as cr
      inner join PowerBI.[v-dss-pbi-date] as pd on pd.Date= cr.Date and pd.CurrentYear is null;

RETURN;

