CREATE TABLE [PowerBI].[dss-pbi-primeprofile] 
(
	[TouchpointID] VARCHAR(4) NOT NULL 
	,[FinancialYear] VARCHAR(9) NOT NULL 
	,[ProfileCategory] VARCHAR(10) NOT NULL 
	,[PriorityOrNot] VARCHAR(2) 
	,[FinancialsOrNot] BIT NOT NULL 
	,[ProfileCategoryValue] DECIMAL(9, 2) NOT NULL 
	,[StartDateTime] DATETIME2(7) NOT NULL 
	,[EndDateTime] DATETIME2(7) NOT NULL 
	,[Comments] VARCHAR(MAX) 
	CONSTRAINT [pk-dss-pbi-primeprofile] PRIMARY KEY CLUSTERED ([TouchpointID] 
															,[FinancialYear] 
															,[ProfileCategory] 
															,[PriorityOrNot] 
															,[FinancialsOrNot] 
															,[ProfileCategoryValue] 
															,[StartDateTime]
															) 
)
GO