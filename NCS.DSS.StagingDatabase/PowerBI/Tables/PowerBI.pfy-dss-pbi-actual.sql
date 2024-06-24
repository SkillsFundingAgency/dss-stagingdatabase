CREATE TABLE [PowerBI].[pfy-dss-pbi-actual](
	[RegionName] [varchar](30) ,
	[FinancialYear] [varchar](9) ,
	[PriorityOrNot] [varchar](2) ,
	[MonthShortName] [varchar](3) ,
	[CustomerCount] [int] ,
	[YTD_CustomerCount] [int] ,
	CONSTRAINT [pk-pfy-dss-pbi-actual] PRIMARY KEY CLUSTERED 
	(
		[RegionName] ASC,
		[FinancialYear] ASC,
		[PriorityOrNot] ASC,
		[MonthShortName] ASC
	 )WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
)
ON [PRIMARY]
GO

