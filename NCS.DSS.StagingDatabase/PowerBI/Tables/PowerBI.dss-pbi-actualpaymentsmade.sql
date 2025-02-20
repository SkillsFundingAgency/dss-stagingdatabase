CREATE TABLE [PowerBI].[dss-pbi-actualpaymentsmade]
(
    [TouchpointID] INT NOT NULL,
	[FinancialYear] VARCHAR(9) NOT NULL,
    [MonthID] INT NOT NULL,
    [CategoryName] VARCHAR(32) NOT NULL,
    [PaymentMade] DECIMAL(18,5) NOT NULL, 
	CONSTRAINT [pk-dss-pbi-actualpaymentsmade] PRIMARY KEY CLUSTERED ([TouchpointID] ,[FinancialYear],[MonthID],[CategoryName]) 
)

GO 