CREATE VIEW [PowerBI].[v-dss-pbi-actualpaymentsmade]
AS
    SELECT APM.[TouchpointID]
    ,APM.[PeriodYear]
    ,APM.[PeriodMonth]
    ,APM.[MonthDate]
    ,APM.[CategoryName]
    ,APM.[ActualPayment] 
    ,APM.[YTD_ActualPayment] 
    FROM 
    (
        SELECT PR.[TouchpointID]
            ,PD.[Year] AS [PeriodYear]
            ,Min(PD.[Date]) AS [MonthDate] 
	        ,PD.[Month] AS [MonthName]
            ,PAP.[CategoryName]
            ,PD.[Fiscal Month Number] AS [PeriodMonth]
            ,PAP.[PaymentMade] AS [ActualPayment] 
            ,SUM(PAP.[PaymentMade]) OVER(PARTITION BY PAP.[CategoryName], PR.[RegionName], PAP.[FinancialYear] ORDER BY PD.[Fiscal Month Number] ) AS YTD_ActualPayment
        FROM [PowerBI].[dss-pbi-actualpaymentsmade] AS PAP
        INNER JOIN [PowerBI].[dss-pbi-region] AS PR
        ON PAP.[TouchpointID] = PR.[TouchpointID] 
        INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD 
        ON PAP.[MonthID] = PD.[Month Number] AND PD.[Fiscal Year] = PAP.[FinancialYear]
        Group by PR.[TouchpointID]
            ,PD.[Year]
	        ,PD.[Month] 
            ,PAP.[CategoryName]
            ,PD.[Fiscal Month Number] 
            ,PAP.[PaymentMade]
            ,PR.[RegionName]
            , PAP.[FinancialYear] 
    ) AS APM 

GO 