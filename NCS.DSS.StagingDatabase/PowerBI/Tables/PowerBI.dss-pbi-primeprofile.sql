CREATE TABLE [PowerBI].[dss-pbi-primeprofile](
	[TouchpointID] [varchar](4) NOT NULL,
	[FinancialYear] [varchar](9) NOT NULL,
	[ProfileCategory] [varchar](10) NOT NULL,
	[PriorityOrNot] [varchar](2) NOT NULL,
	[FinancialsOrNot] [bit] NOT NULL,
	[ProfileCategoryValue] [decimal](9, 2) NOT NULL,
	[StartDateTime] [datetime2](7) NOT NULL,
	[EndDateTime] [datetime2](7) NOT NULL,
	[Comments] [varchar](max) NULL,
	[ProfileCategoryValueQ1] [decimal](9, 2) NULL,
	[ProfileCategoryValueQ2] [decimal](9, 2) NULL,
	[ProfileCategoryValueQ3] [decimal](9, 2) NULL,
 CONSTRAINT [pk-dss-pbi-primeprofile] PRIMARY KEY CLUSTERED 
(
	[TouchpointID] ASC,
	[FinancialYear] ASC,
	[ProfileCategory] ASC,
	[PriorityOrNot] ASC,
	[FinancialsOrNot] ASC,
	[ProfileCategoryValue] ASC,
	[StartDateTime] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


