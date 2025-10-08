CREATE TABLE [PowerBI].[dss-pbi-nationaltarget](
	[FinancialYear] [varchar](9) NOT NULL,
	[ContractYear] [varchar](9) NOT NULL,
	[PeriodMonth] [int] NOT NULL,
	[PriorityOrNot] [varchar](2) NOT NULL,
	[TargetCategory] [varchar](10) NOT NULL,
	[TargetCategoryValue] [decimal](8, 5) NOT NULL,
	[Comments] [varchar](max) NULL,
 CONSTRAINT [pk-dss-pbi-nationaltarget] PRIMARY KEY CLUSTERED 
(
	[FinancialYear] ASC,
	[ContractYear] ASC,
	[PeriodMonth] ASC,
	[PriorityOrNot] ASC,
	[TargetCategory] ASC,
	[TargetCategoryValue] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO