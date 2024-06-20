CREATE VIEW [PowerBI].[v-dss-pbi-date] WITH SCHEMABINDING 
AS 
    SELECT 
        PD.[CalendarDate] AS [Date] 
        ,PD.[CalendarYear] AS [Year]
        ,PM.[MonthFullName] AS [Month]
        ,PM.[MonthId] AS [Month Number]
        ,PM.[PeriodMonth] AS [Fiscal Month Number]
        ,PM.[Quarter] AS [Quarter]
        ,PM.[PeriodQuarter] AS [Fiscal Quarter]
        ,PF.[FinancialYear] AS [Fiscal Year]
        ,PF.CurrentYear
    FROM [PowerBI].[dss-pbi-date] AS PD 
    INNER JOIN [PowerBI].[dss-pbi-monthsinyear] AS PM 
    ON PM.[MonthId] = PD.[MonthID]
    INNER JOIN [PowerBI].[dss-pbi-financialyear] AS PF 
    ON PD.[CalendarDate] BETWEEN PF.[StartDateTime] AND PF.[EndDateTime] 
;
GO