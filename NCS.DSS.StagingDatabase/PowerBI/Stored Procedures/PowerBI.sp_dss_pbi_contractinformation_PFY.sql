CREATE PROCEDURE [PowerBI].[sp_dss_pbi_contractinformation_PFY]
AS
BEGIN
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
END;