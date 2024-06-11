CREATE TABLE [PowerBI].[dss-pbi-financialyear](
	[FinancialYear] [varchar](9) NOT NULL,
	[StartDateTime] [datetime2](7) NOT NULL,
	[EndDateTime] [datetime2](7) NOT NULL,
	[Comments] [varchar](max) NULL,
	[CurrentYear] BIT NULL,
    CONSTRAINT [pk-dss-pbi-financialyear] PRIMARY KEY CLUSTERED ([FinancialYear] ASC)
) 
GO
