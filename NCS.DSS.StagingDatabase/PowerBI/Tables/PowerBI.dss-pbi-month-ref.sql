CREATE TABLE [PowerBI].[dss-pbi-month-ref]
(
    [MonthRefId] INT NOT NULL IDENTITY(1,1) PRIMARY KEY, -- Primary Key column
    [NoOfDays] INT NOT NULL,
    [Details] NVARCHAR(64) NOT NULL
    -- Specify more columns here
);
GO