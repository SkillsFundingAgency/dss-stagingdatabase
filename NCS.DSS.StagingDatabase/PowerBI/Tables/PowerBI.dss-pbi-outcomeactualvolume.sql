CREATE TABLE [PowerBI].[dss-pbi-outcomeactualvolume] 
(
	[TouchpointID] [VARCHAR](4) NOT NULL 
	,[ProfileCategory] [VARCHAR](4) NOT NULL 
	,[PriorityOrNot] VARCHAR(2) NOT NULL 
	,[PeriodMonth] INT NOT NULL 
	,[Date] [DATETIME2](7) NOT NULL 
	,[PeriodYear] VARCHAR(9) NOT NULL 
	,[OutcomeNumber] DECIMAL(11, 2) 
	,[YTD_OutcomeNumber] DECIMAL(11, 2) 
	CONSTRAINT [pk-dss-pbi-outcomeactualvolume] PRIMARY KEY CLUSTERED 
	([TouchpointID], [ProfileCategory], [PriorityOrNot], [PeriodYear], [PeriodMonth]) 
)
GO;