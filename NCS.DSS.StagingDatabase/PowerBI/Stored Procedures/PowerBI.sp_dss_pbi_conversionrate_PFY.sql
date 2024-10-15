CREATE PROCEDURE [PowerBI].[sp_dss_pbi_conversionrate_PFY]
AS
BEGIN
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
END;