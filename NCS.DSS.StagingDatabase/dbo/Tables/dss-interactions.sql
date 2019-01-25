CREATE TABLE [dbo].[dss-interactions] (
    [id]                       UNIQUEIDENTIFIER NULL,
    [CustomerId]               UNIQUEIDENTIFIER NULL,
    [TouchpointId]             VARCHAR (max)     NULL,
    [AdviserDetailsId]         UNIQUEIDENTIFIER NULL,
    [DateandTimeOfInteraction] DATETIME         NULL,
    [Channel]                  INT              NULL,
    [InteractionType]          INT              NULL,
    [LastModifiedDate]         DATETIME         NULL,
    [LastModifiedTouchpointId] VARCHAR (max)     NULL
);

