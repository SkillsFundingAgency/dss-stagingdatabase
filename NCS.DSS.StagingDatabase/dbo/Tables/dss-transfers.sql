CREATE TABLE [dbo].[dss-transfers] (
    [id]                            UNIQUEIDENTIFIER NULL,
    [CustomerId]                    UNIQUEIDENTIFIER NULL,
    [InteractionId]                 UNIQUEIDENTIFIER NULL,
    [OriginatingTouchpointId]       VARCHAR (10)     NULL,
    [TargetTouchpointId]            VARCHAR (10)     NULL,
    [Context]                       VARCHAR (50)     NULL,
    [DateandTimeOfTransfer]         DATETIME         NULL,
    [DateandTimeofTransferAccepted] DATETIME         NULL,
    [RequestedCallbackTime]         DATETIME         NULL,
    [ActualCallbackTime]            DATETIME         NULL,
    [LastModifiedDate]              DATETIME         NULL,
    [LastModifiedTouchpointId]      VARCHAR (10)     NULL
);

