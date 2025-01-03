CREATE TABLE [PowerBI].[dss-pbi-customercount](
	TouchpointID varchar(4) not null,
	PeriodYear varchar(61) not null,
	PeriodMonth int not null,
	PriorityOrNot varchar(2) not null,
	CustomerCount int,	
CONSTRAINT [pk-dss-pbi-customercount] PRIMARY KEY CLUSTERED 
	(
	TouchpointID ASC,
	PeriodYear ASC,
	PeriodMonth ASC,
	PriorityOrNot ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
)
GO

