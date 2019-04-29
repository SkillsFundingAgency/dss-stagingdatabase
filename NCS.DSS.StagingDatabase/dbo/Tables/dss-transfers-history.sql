CREATE TABLE [dbo].[dss-transfers-history] (
    [HistoryId] [int]				IDENTITY(1,1) NOT NULL,
	[CosmosTimeStamp]				datetime2(7) NOT NULL,
	[id]                            UNIQUEIDENTIFIER NOT NULL,
    [CustomerId]                    UNIQUEIDENTIFIER NULL,
    [InteractionId]                 UNIQUEIDENTIFIER NULL,
    [OriginatingTouchpointId]       VARCHAR (max)     NULL,
    [TargetTouchpointId]            VARCHAR (max)     NULL,
    [Context]                       VARCHAR (max)     NULL,
    [DateandTimeOfTransfer]         datetime2         NULL,
    [DateandTimeofTransferAccepted] datetime2         NULL,
    [RequestedCallbackTime]         datetime2         NULL,
    [ActualCallbackTime]            datetime2         NULL,
    [LastModifiedDate]              datetime2         NULL,
    [LastModifiedTouchpointId]      VARCHAR (max)     NULL,
PRIMARY KEY CLUSTERED 
(
	[HistoryId] ASC,
	[CosmosTimeStamp] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO