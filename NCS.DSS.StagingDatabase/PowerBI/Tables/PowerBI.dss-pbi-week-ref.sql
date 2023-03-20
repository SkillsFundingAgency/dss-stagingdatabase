CREATE TABLE [PowerBI].[dss-pbi-week-ref]
(
    [WeekRefId] INT NOT NULL IDENTITY(1,1) PRIMARY KEY, -- Primary Key column
    [MonthRefId] INT NOT NULL,
    [WeekName] VARCHAR(32) NOT NULL,
    [NoOfDays] INT NOT NULL,
    [Details] NVARCHAR(64) NOT NULL
    -- Specify more columns here
);
GO