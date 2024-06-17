CREATE TABLE [PowerBI].[pfy-dss-pbi-customercount](
	TouchpointID varchar(max),
	PeriodYear varchar(61),
	PeriodMonth int,
	PriorityOrNot varchar(2),
	CustomerCount int,	
CONSTRAINT [pk-pfy-dss-pbi-customercount] PRIMARY KEY CLUSTERED 
	(
	TouchpointID ASC,
	PeriodYear ASC,
	PeriodMonth ASC,
	PriorityOrNot ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
)
GO

