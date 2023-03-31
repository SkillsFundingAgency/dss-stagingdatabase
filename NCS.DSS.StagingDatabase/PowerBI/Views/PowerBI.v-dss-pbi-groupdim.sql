CREATE VIEW [PowerBI].[v-dss-pbi-groupdim] 
AS 
    SELECT 1 AS 'Group ID', 'NP' AS 'Group abbreviation', 'Non Priority Group' AS 'Group' 
    UNION ALL
    SELECT 2 AS 'Group ID', 'PG' AS 'Group abbreviation', 'Priority Group' AS 'Group' 
;
GO