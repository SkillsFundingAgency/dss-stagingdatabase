CREATE TABLE [PowerBI].[dss-pbi-actualpaymentsmade]
(
    [TouchpointID] INT NOT NULL,
	[FinancialYear] VARCHAR(9) NOT NULL,
    [MonthID] INT NOT NULL,
    [CategoryName] VARCHAR(32) NOT NULL,
    [PaymentMade] decimal(12, 5)  NULL,
	CONSTRAINT [pk-dss-pbi-actualpaymentsmade] PRIMARY KEY CLUSTERED ([TouchpointID] ,[FinancialYear],[MonthID],[CategoryName]) 
)
GO 