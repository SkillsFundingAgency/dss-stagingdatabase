CREATE TABLE [dbo].[dss-collections-history](
	[HistoryId] [int]   IDENTITY(1,1) NOT NULL,
	[CosmosTimeStamp]   DATETIME2(7) NOT NULL,
	[id]				UNIQUEIDENTIFIER NOT NULL,
	[CollectionReports] VARCHAR (max) NULL,
	[TouchpointId]		VARCHAR (max) NULL,
	[Ukprn]				VARCHAR (max) NULL,
	[LastModifiedDate]	DATETIME2(7) NULL,
PRIMARY KEY CLUSTERED 
(
	[HistoryId] ASC,
	[CosmosTimeStamp] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

