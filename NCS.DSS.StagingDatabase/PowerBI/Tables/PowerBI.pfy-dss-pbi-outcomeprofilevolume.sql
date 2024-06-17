CREATE TABLE [PowerBI].[pfy-dss-pbi-outcomeprofilevolume](
	[TouchpointID] varchar(4) not null
        ,[ProfileCategory] varchar(10) not null
        ,[PriorityOrNot] varchar(2) not null
        ,[PeriodMonth] int not null
		,[date] datetime2(7) not null
        ,[PeriodYear] varchar(9) not null
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


