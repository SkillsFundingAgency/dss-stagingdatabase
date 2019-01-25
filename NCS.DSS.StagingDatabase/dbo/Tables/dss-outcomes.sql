CREATE TABLE [dbo].[dss-outcomes] (
    [id]                       UNIQUEIDENTIFIER NULL,
    [CustomerId]               UNIQUEIDENTIFIER NULL,
    [ActionPlanId]             UNIQUEIDENTIFIER NULL,
    [OutcomeType]              INT              NULL,
    [OutcomeClaimedDate]       DATETIME         NULL,
    [OutcomeEffectiveDate]     DATETIME         NULL,
    [TouchpointId]             VARCHAR (max)     NULL,
    [LastModifiedDate]         DATETIME         NULL,
    [LastModifiedTouchpointId] VARCHAR (max)     NULL
);

