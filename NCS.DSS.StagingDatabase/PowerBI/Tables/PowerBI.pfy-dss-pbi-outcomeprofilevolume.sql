CREATE TABLE [PowerBI].[pfy-dss-pbi-outcomeprofilevolume](
	[TouchpointID] varchar(4)
        ,[ProfileCategory] varchar(10)
        ,[PriorityOrNot] varchar(2)
        ,[PeriodMonth] int not null
		,[date] datetime2(7)
        ,[PeriodYear] varchar(9)
        ,[OutcomeNumber] decimal(10,2)
        ,[YTD_OutcomeNumber] decimal(10,2)
CONSTRAINT [pk-pfy-dss-pbi-outcomeprofilevolume] PRIMARY KEY CLUSTERED 
	(
	TouchpointID ASC,
	[ProfileCategory] ASC,
	[PriorityOrNot] ASC,
	[PeriodMonth] ASC,
	[date] ASC,
	[PeriodYear] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
)


