CREATE TABLE [dbo].[dss-collections] (
	[id]				UNIQUEIDENTIFIER NOT NULL,
	[ContainerName]		VARCHAR (max) NULL,
	[ReportFileName]	VARCHAR (max) NULL,
	[CollectionReports] VARCHAR (max) NULL,
	[TouchPointId]		VARCHAR (max) NULL,
	[Ukprn]				VARCHAR (max) NULL,
	[LastModifiedDate]	DATETIME2 (7) NULL,
	CONSTRAINT [PK_collections] PRIMARY KEY ([id]) 
);

