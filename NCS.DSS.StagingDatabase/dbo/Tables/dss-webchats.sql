CREATE TABLE [dbo].[dss-webchats] (
    [id]                         UNIQUEIDENTIFIER NULL,
    [CustomerId]                 UNIQUEIDENTIFIER NULL,
    [InteractionId]              UNIQUEIDENTIFIER NULL,
    [DigitalReference]           VARCHAR (max)     NULL,
    [WebChatStartDateandTime]    DATETIME         NULL,
    [WebChatEndDateandTime]      DATETIME         NULL,
    [WebChatDuration]            TIME (7)         NULL,
    [WebChatNarrative]           VARCHAR (max)     NULL,
    [SentToCustomer]             BIT              NULL,
    [DateandTimeSentToCustomers] DATETIME         NULL,
    [LastModifiedDate]           DATETIME         NULL,
    [LastModifiedTouchpointId]   VARCHAR (max)     NULL
);

