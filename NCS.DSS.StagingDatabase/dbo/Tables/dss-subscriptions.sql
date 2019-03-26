CREATE TABLE [dbo].[dss-subscriptions] (
    [CustomerId]               UNIQUEIDENTIFIER NOT NULL,
    [SubscriptionId]           UNIQUEIDENTIFIER NOT NULL,
    [TouchPointId]             VARCHAR (max)     NULL,
    [Subscribe]                BIT              NULL,
    [LastModifiedDate]         datetime2         NULL,
    [LastModifiedTouchpointId] VARCHAR (max)     NULL, 
    CONSTRAINT [PK_dss-subscriptions] PRIMARY KEY ([SubscriptionId]) 
);

