CREATE TABLE [PowerBI].[dss-pbi-reference] 
(
	[ReferenceCategory] VARCHAR(9) NOT NULL 
    ,[ReferenceValue] VARCHAR(10) NOT NULL 
	,[StartDateTime] [DATETIME2](7) NOT NULL 
	,[EndDateTime] [DATETIME2](7) NOT NULL 
	,[ReferenceName] VARCHAR(30) NOT NULL 
	,[Comments] VARCHAR(MAX) 
	CONSTRAINT [pk-dss-pbi-reference] PRIMARY KEY CLUSTERED ([ReferenceCategory]) 
)
GO