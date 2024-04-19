CREATE TABLE [dbo].[dss-interactions-history]
(
	[HistoryId]				   INT IDENTITY(1,1) NOT NULL,
	[CosmosTimeStamp]		   datetime2(7) NOT NULL,
	[id]                       UNIQUEIDENTIFIER NOT NULL,
    [CustomerId]               UNIQUEIDENTIFIER NULL,
    [TouchpointId]             VARCHAR (max)     NULL,
    [AdviserDetailsId]         UNIQUEIDENTIFIER NULL,
    [DateandTimeOfInteraction] datetime2         NULL,
    [Channel]                  INT              NULL,
    [InteractionType]          INT              NULL,
    [LastModifiedDate]         datetime2         NULL,
    [LastModifiedTouchpointId] VARCHAR (max)     NULL, 
	PRIMARY KEY CLUSTERED 
(
	[HistoryId] ASC,
	[CosmosTimeStamp] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [nci_dss-interactions-history_customerid] ON [dbo].[dss-interactions-history] ([CustomerId]) WITH (ONLINE = ON)

GO