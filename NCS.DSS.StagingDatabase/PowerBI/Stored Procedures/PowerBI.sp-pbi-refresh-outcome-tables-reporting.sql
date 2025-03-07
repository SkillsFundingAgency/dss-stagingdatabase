CREATE PROCEDURE [PowerBI].[sp-pbi-refresh-outcome-tables-reporting](@pr1 int)
AS
BEGIN
    TRUNCATE TABLE [PowerBI].[dss-pbi-outcome]
                ;
                INSERT INTO [PowerBI].[dss-pbi-outcome]
                SELECT * FROM [PowerBI].[v-dss-pbi-outcome-reporting]
                ;
                TRUNCATE TABLE [PowerBI].[dss-pbi-outcomeactualvolume]
                ;
                INSERT INTO [PowerBI].[dss-pbi-outcomeactualvolume]
                SELECT * FROM [PowerBI].[v-dss-pbi-outcomeactualvolume] WHERE TouchpointID IS NOT NULL
END