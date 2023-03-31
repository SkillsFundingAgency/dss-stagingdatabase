CREATE TABLE [PowerBI].[dss-pbi-region] 
(
	[RegionID] VARCHAR(7) NOT NULL 
	,[TouchpointID] [VARCHAR](4) NOT NULL 
	,[RegionName] [VARCHAR](30) NOT NULL 
	,[StartDateTime] [DATETIME2](7) NOT NULL 
	,[EndDateTime] [DATETIME2](7) NOT NULL 
	,[RegionColour] [VARCHAR](7) NOT NULL 
	,[SortOrder] INT NOT NULL
	CONSTRAINT [pk-dss-pbi-region] PRIMARY KEY CLUSTERED ([RegionID], [TouchpointID], [StartDateTime]) 
)
;
GO 