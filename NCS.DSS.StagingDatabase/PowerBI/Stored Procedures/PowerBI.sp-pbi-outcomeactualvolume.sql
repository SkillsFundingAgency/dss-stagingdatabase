CREATE PROCEDURE [PowerBI].[sp-pbi-outcomeactualvolume](@pr1 int)
AS
BEGIN
                TRUNCATE TABLE [PowerBI].[dss-pbi-outcomeactualvolume]
                ;
                INSERT INTO [PowerBI].[dss-pbi-outcomeactualvolume]
                SELECT * FROM [PowerBI].[v-dss-pbi-outcomeactualvolume]
END