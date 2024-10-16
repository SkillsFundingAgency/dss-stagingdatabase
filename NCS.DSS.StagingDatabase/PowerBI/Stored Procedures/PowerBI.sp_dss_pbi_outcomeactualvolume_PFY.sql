CREATE PROCEDURE [PowerBI].[sp_dss_pbi_outcomeactualvolume_PFY]
AS
BEGIN
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
END;