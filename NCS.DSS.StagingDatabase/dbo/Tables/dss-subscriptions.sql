CREATE TABLE [dbo].[dss-subscriptions] (
    [CustomerId]               UNIQUEIDENTIFIER NULL,
    [SubscriptionId]           UNIQUEIDENTIFIER NULL,
    [TouchPointId]             VARCHAR (max)     NULL,
    [Subscribe]                BIT              NULL,
    [LastModifiedDate]         datetime2         NULL,
    [LastModifiedTouchpointId] VARCHAR (max)     NULL
);

