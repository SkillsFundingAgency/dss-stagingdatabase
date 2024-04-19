CREATE TABLE [dbo].[dss-subscriptions-history] (
    [HistoryId] [int]		   IDENTITY(1,1) NOT NULL,
	[CosmosTimeStamp]		   datetime2(7) NOT NULL,
	[id]			           UNIQUEIDENTIFIER NOT NULL,
	[CustomerId]               UNIQUEIDENTIFIER NULL,
    [TouchPointId]             VARCHAR (max)     NULL,
    [Subscribe]                BIT              NULL,
    [LastModifiedDate]         datetime2         NULL,
    [LastModifiedTouchpointId] VARCHAR (max)     NULL,
CONSTRAINT [PK_dss-subscriptions-history] PRIMARY KEY CLUSTERED 
(
	[HistoryId] ASC,
	[CosmosTimeStamp] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [nci_dss-subscriptions-history_customerid] ON [dbo].[dss-subscriptions-history] ([CustomerId]) WITH (ONLINE = ON)

GO