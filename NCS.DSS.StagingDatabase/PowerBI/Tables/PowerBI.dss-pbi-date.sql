CREATE TABLE [PowerBI].[dss-pbi-date] 
(
	[DateID] INT NOT NULL 
	,[CalendarDate] [DATETIME2](7) NOT NULL 
	,[CalendarYear] INT NOT NULL 
	,[MonthID] INT NOT NULL 
	,[WeekDay] [BIT] NOT NULL 
	,[BankHoliday] [BIT] DEFAULT 0 NOT NULL
	,[MonthRefId] INT NULL
    ,[WeekRefId] INT NULL
	,CONSTRAINT [pk-dss-pbi-date] PRIMARY KEY CLUSTERED ([CalendarDate], [DateID])
	,CONSTRAINT [v-dss-pbi-date-IDX] UNIQUE CLUSTERED ([Date],[Year],[Fiscal Year])
)
;
GO 