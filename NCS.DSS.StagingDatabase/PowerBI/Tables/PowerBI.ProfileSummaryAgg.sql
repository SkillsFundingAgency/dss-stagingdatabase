CREATE TABLE [PowerBI].[ProfileSummaryAgg](
	[OutcomeID] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[ProfileFullYear] [decimal](18, 2) NULL,
	[FinancialProfileFullYear] [decimal](18, 2) NULL,
 CONSTRAINT [PK_ProfileSummaryAgg] PRIMARY KEY CLUSTERED 
(
	[OutcomeID] ASC,
	[Date] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

