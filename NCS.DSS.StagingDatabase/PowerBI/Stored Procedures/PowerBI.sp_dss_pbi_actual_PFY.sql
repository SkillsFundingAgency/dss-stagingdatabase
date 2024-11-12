CREATE PROCEDURE [PowerBI].[sp_dss_pbi_actual_PFY]
AS
BEGIN
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
END;