CREATE TABLE [dbo].[dss-collections] (
	[id]				UNIQUEIDENTIFIER NOT NULL,
	[CollectionReports] VARCHAR (max) NULL,
	[TouchpointId]		VARCHAR (max) NULL,
	[Ukprn]				VARCHAR (max) NULL,
	[LastModifiedDate]	DATETIME2 (7) NULL,
	CONSTRAINT [PK_collections] PRIMARY KEY ([id]) 
);

