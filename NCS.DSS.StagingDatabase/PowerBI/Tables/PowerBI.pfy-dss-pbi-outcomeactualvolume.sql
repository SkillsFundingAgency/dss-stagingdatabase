CREATE TABLE [PowerBI].[pfy-dss-pbi-outcome-actualvolume] (
    [TouchpointID] INT
	,[ProfileCategory] VARCHAR(4)
	,[PriorityOrNot] VARCHAR(2)
	,[PeriodMonth] INT
	,[DATE] DATETIME
	,[PeriodYear] VARCHAR(9)
	,[OutcomeNumber] DECIMAL(9,2)
	,[YTD_OutcomeNumber] DECIMAL(9,2)
	CONSTRAINT [pk-pfy-dss-pbi-outcome-actualvolume] PRIMARY KEY CLUSTERED 
	(
		[TouchpointID] ASC,
		[ProfileCategory] ASC,
		[PeriodYear] ASC,
		[PeriodMonth] ASC,
		[PriorityOrNot] ASC,
		[DATE] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

)