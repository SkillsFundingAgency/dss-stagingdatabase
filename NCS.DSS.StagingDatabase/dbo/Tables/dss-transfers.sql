CREATE TABLE [dbo].[dss-transfers] (
    [id]                            UNIQUEIDENTIFIER NULL,
    [CustomerId]                    UNIQUEIDENTIFIER NULL,
    [InteractionId]                 UNIQUEIDENTIFIER NULL,
    [OriginatingTouchpointId]       VARCHAR (max)     NULL,
    [TargetTouchpointId]            VARCHAR (max)     NULL,
    [Context]                       VARCHAR (max)     NULL,
    [DateandTimeOfTransfer]         DATETIME         NULL,
    [DateandTimeofTransferAccepted] DATETIME         NULL,
    [RequestedCallbackTime]         DATETIME         NULL,
    [ActualCallbackTime]            DATETIME         NULL,
    [LastModifiedDate]              DATETIME         NULL,
    [LastModifiedTouchpointId]      VARCHAR (max)     NULL
);

