CREATE VIEW [PowerBI].[v-dss-pbi-daily-performance-summary]
AS 
    Select * from [PowerBI].[fun-dss-pbi-daily-performance]()
    
GO