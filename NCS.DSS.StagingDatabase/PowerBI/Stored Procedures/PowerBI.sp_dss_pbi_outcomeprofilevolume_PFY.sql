CREATE PROCEDURE [PowerBI].[sp_dss_pbi_outcomeprofilevolume_PFY]
AS
BEGIN
    TRUNCATE TABLE [PowerBI].[pfy-dss-pbi-outcomeprofilevolume] ;
    INSERT INTO [PowerBI].[pfy-dss-pbi-outcomeprofilevolume] 
    SELECT [TouchpointID],
               [ProfileCategory],
               [PriorityOrNot],
               [PeriodMonth],
               [date],
               [PeriodYear],
               [OutcomeNumber],
               [YTD_OutcomeNumber]
        FROM [PowerBI].[v-dss-pbi-outcomeprofilevolume-FY] A
        INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON A.PeriodYear = PF.FinancialYear
        WHERE PF.CurrentYear IS NULL  and [TouchpointID] is not null
END;