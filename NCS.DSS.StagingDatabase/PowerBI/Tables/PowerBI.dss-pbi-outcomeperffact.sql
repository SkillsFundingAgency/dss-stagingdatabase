CREATE TABLE [PowerBI].[dss-pbi-outcomeperffact](
	[TouchpointID] [int] NULL,
	[Outcome ID] [int] NULL,
	[Group ID] [int] NULL,
	[Date] [date] NULL,
	[Performance] [decimal](9, 2) NULL,
	[Performance YTD] [decimal](9, 2) NULL,
	[Performance Full Year] [decimal](9, 2) NULL,
	[FinancialPerformance] [decimal](11, 2) NULL,
	[FinancialPerformance YTD] [decimal](11, 2) NULL,
	[FinancialPerformance Full Year] [decimal](11, 2) NULL
) ON [PRIMARY]
GO