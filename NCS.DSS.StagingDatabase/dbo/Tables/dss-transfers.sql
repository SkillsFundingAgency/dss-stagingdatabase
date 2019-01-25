CREATE TABLE [dbo].[dss-transfers] (
    [id]                            UNIQUEIDENTIFIER NULL,
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
    [LastModifiedTouchpointId]      VARCHAR (max)     NULL
);

