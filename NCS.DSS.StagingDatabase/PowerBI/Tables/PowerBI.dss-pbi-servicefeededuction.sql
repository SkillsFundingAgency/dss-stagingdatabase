CREATE TABLE [PowerBI].[dss-pbi-servicefeededuction] 
(
	[TouchpointID] [VARCHAR](4) NOT NULL 
	,[CalendarDate] [DATETIME2](7) NOT NULL  
    ,[ReferenceValue] DECIMAL(4, 2) NOT NULL 
	,[Comments] VARCHAR(MAX) 
	CONSTRAINT [pk-dss-pbi-servicefeededuction] PRIMARY KEY CLUSTERED ([TouchpointID], [CalendarDate]) 
)
GO;