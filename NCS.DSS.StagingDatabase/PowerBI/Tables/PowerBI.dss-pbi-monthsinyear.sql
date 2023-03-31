CREATE TABLE [PowerBI].[dss-pbi-monthsinyear] 
(
	[MonthID] INT NOT NULL 
	,[MonthFullName] VARCHAR(9) NOT NULL 
	,[MonthShortName] VARCHAR(3) NOT NULL 
	,[PeriodMonth] INT NOT NULL 
	,[MonthStartDate] [DATETIME2](7) NOT NULL 
	,[Quarter] INT NOT NULL 
	,[PeriodQuarter] INT NOT NULL 
	CONSTRAINT [pk-dss-pbi-monthsinyear] PRIMARY KEY CLUSTERED ([MonthID]) 
)
;
GO 