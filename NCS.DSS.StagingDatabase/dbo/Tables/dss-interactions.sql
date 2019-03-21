CREATE TABLE [dbo].[dss-interactions] (
    [id]                       UNIQUEIDENTIFIER NOT NULL,
    [CustomerId]               UNIQUEIDENTIFIER NULL,
    [TouchpointId]             VARCHAR (max)     NULL,
    [AdviserDetailsId]         UNIQUEIDENTIFIER NULL,
    [DateandTimeOfInteraction] datetime2         NULL,
    [Channel]                  INT              NULL,
    [InteractionType]          INT              NULL,
    [LastModifiedDate]         datetime2         NULL,
    [LastModifiedTouchpointId] VARCHAR (max)     NULL, 
    CONSTRAINT [PK_dss-interactions] PRIMARY KEY ([id])
);

