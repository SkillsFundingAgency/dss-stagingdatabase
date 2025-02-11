CREATE TABLE [PowerBI].[dss-5thworkingDayProfile](
	[TouchPointId] [int] NOT NULL,
	[FinancialYear] [varchar](9) NOT NULL,
	[MonthID] [int] NOT NULL,
	[ProfileValue] [decimal](18, 5) NOT NULL,
 CONSTRAINT [PK_dss_5thworkingDayProfile] PRIMARY KEY CLUSTERED 
(
	[TouchPointId] ASC,
	[FinancialYear] ASC,
	[MonthID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO