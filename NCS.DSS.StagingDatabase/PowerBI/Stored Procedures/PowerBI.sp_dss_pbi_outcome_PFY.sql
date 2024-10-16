CREATE PROCEDURE [PowerBI].[sp_dss_pbi_outcome_PFY]
AS
BEGIN
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
END;