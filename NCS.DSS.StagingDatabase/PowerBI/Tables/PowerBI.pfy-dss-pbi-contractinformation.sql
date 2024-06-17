CREATE TABLE [PowerBI].[pfy-dss-pbi-contractinformation](
	[TouchpointID]int,
[ProfileCategory] varchar(23),
[Date] datetime,
[Fiscal Year] varchar(9),
[ProfileCategoryValue] decimal(38,2),
	
CONSTRAINT [pfy-dss-pbi-contractinformation] PRIMARY KEY CLUSTERED 
	(
		[TouchpointID] ASC,
		[ProfileCategory] ASC,
		[Date] ASC,
		[Fiscal Year] ASC
	 )WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
)
GO