CREATE TABLE [PowerBI].[dss-pbi-outcome] 
(
	[TouchpointID] [VARCHAR](4) NOT NULL 
	,[PriorityOrNot] VARCHAR(2) NOT NULL 
	,[OutcomeTypeValue] INT NOT NULL 
	,[OutcomeTypeGroup] VARCHAR(4) NOT NULL 
	,[PeriodMonth] INT NOT NULL 
	,[PeriodYear] VARCHAR(9) NOT NULL 
	,[OutcomeNumber] DECIMAL(11, 2) 
	CONSTRAINT [pk-dss-pbi-outcome] PRIMARY KEY CLUSTERED ([TouchpointID], [PeriodYear], [PeriodMonth], [PriorityOrNot], [OutcomeTypeGroup], [OutcomeTypeValue]) 
)
GO;