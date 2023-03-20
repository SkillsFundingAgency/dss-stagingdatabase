CREATE TABLE [PowerBI].[dss-pbi-nationaltarget] 
(
	[FinancialYear] VARCHAR(9) NOT NULL 
	,[ContractYear] VARCHAR(9) NOT NULL 
	,[PeriodMonth] INT NOT NULL 
	,[PriorityOrNot] VARCHAR(2) 
	,[TargetCategory] VARCHAR(10) NOT NULL 
	,[TargetCategoryValue] DECIMAL(5, 2) NOT NULL 
	,[Comments] VARCHAR(MAX) 
	CONSTRAINT [pk-dss-pbi-nationaltarget] PRIMARY KEY CLUSTERED ([FinancialYear] 
																	,[ContractYear] 
																	,[PeriodMonth] 
																	,[PriorityOrNot] 
																	,[TargetCategory] 
																	,[TargetCategoryValue] 
																	) 
)
GO
