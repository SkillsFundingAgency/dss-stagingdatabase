CREATE TABLE [dbo].[dss-outcomes] (
    [id]                       UNIQUEIDENTIFIER NULL,
    [CustomerId]               UNIQUEIDENTIFIER NULL,
    [ActionPlanId]             UNIQUEIDENTIFIER NULL,
    [OutcomeType]              INT              NULL,
    [OutcomeClaimedDate]       datetime2         NULL,
    [OutcomeEffectiveDate]     datetime2         NULL,
    [TouchpointId]             VARCHAR (max)     NULL,
    [LastModifiedDate]         datetime2         NULL,
    [LastModifiedTouchpointId] VARCHAR (max)     NULL
);

