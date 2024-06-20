CREATE TABLE [dbo].[dss-webchats-history] (
    [HistoryId] [int]			 IDENTITY(1,1) NOT NULL,
	[CosmosTimeStamp]			 datetime2(7) NOT NULL,
    [id]                         UNIQUEIDENTIFIER NOT NULL,
    [CustomerId]                 UNIQUEIDENTIFIER NULL,
    [InteractionId]              UNIQUEIDENTIFIER NULL,
    [DigitalReference]           VARCHAR (max)     NULL,
    [WebChatStartDateandTime]    datetime2         NULL,
    [WebChatEndDateandTime]      datetime2         NULL,
    [WebChatDuration]            TIME (7)         NULL,
    [WebChatNarrative]           VARCHAR (max)     NULL,
    [SentToCustomer]             BIT              NULL,
    [DateandTimeSentToCustomers] datetime2         NULL,
    [LastModifiedDate]           datetime2         NULL,
    [LastModifiedTouchpointId]   VARCHAR (max)     NULL, 
PRIMARY KEY CLUSTERED 
(
	[HistoryId] ASC,
	[CosmosTimeStamp] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [nci_dss-webchats-history_customerid] ON [dbo].[dss-webchats-history] ([CustomerId]) WITH (ONLINE = ON)

GO