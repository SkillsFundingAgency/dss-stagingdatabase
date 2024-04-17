CREATE TABLE [dbo].[dss-subscriptions] (
    [id]			           UNIQUEIDENTIFIER NOT NULL,
	[CustomerId]               UNIQUEIDENTIFIER NULL,
    [TouchPointId]             VARCHAR (max)     NULL,
    [Subscribe]                BIT              NULL,
    [LastModifiedDate]         datetime2         NULL,
    [LastModifiedTouchpointId] VARCHAR (max)     NULL, 
    CONSTRAINT [PK_dss-subscriptions] PRIMARY KEY ([id]) 
);

GO

CREATE NONCLUSTERED INDEX [dss-subscriptions_customerid] ON [dbo].[dss-subscriptions] ([CustomerId]) WITH (ONLINE = ON)

GO
