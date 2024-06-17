CREATE TABLE [PowerBI].[pfy-dss-pbi-customercount](
	TouchpointID varchar(max) not null,
	PeriodYear varchar(61) not null,
	PeriodMonth int not null,
	PriorityOrNot varchar(2) not null,
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

