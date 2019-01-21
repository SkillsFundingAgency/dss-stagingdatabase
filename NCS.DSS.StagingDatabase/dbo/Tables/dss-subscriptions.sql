CREATE TABLE [dbo].[dss-subscriptions] (
    [CustomerId]               UNIQUEIDENTIFIER NULL,
    [SubscriptionId]           UNIQUEIDENTIFIER NULL,
    [TouchPointId]             VARCHAR (10)     NULL,
    [Subscribe]                BIT              NULL,
    [LastModifiedDate]         DATETIME         NULL,
    [LastModifiedTouchpointId] VARCHAR (10)     NULL
);

