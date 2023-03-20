CREATE VIEW [PowerBI].[v-dss-pbi-monthsinyear] AS 
    SELECT 
        [MonthID]  
        ,[MonthFullName] 
        ,[MonthShortName]  
        ,[PeriodMonth] 
        ,CASE WHEN [MonthID] = MONTH(GETDATE()) THEN 'This Month' ELSE [MonthFullName] END AS TempDateFilter  
    FROM [PowerBI].[dss-pbi-monthsinyear] 
;
GO