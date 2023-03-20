
CREATE TABLE [PowerBI].[dss-pbi-contractyear] 
(
	[ContractYear] VARCHAR(9) NOT NULL 
	,[StartFinancialYear] VARCHAR(9) NOT NULL 
	,[EndFinancialYear] VARCHAR(9) NOT NULL 
	,[StartPeriodMonth] INT NOT NULL  
	,[EndPeriodMonth] INT NOT NULL  
	,[StartDateTime] [DATETIME2](7) NOT NULL 
	,[EndDateTime] [DATETIME2](7) NOT NULL 
	,[Comments] VARCHAR(MAX) 
	CONSTRAINT [pk-dss-pbi-contractyear] PRIMARY KEY CLUSTERED ([ContractYear], [StartFinancialYear], [StartPeriodMonth]) 
)
;
GO 