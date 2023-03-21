CREATE TABLE [PowerBI].[dss-pbi-financialyear](
	[FinancialYear] [varchar](9) NOT NULL,
	[StartDateTime] [datetime2](7) NOT NULL,
	[EndDateTime] [datetime2](7) NOT NULL,
	[Comments] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [PowerBI].[dss-pbi-financialyear] ADD  CONSTRAINT [pk-dss-pbi-financialyear] PRIMARY KEY CLUSTERED 
(
	[FinancialYear] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO