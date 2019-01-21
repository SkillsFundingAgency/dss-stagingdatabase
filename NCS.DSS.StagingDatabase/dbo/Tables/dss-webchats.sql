CREATE TABLE [dbo].[dss-webchats] (
    [id]                         UNIQUEIDENTIFIER NULL,
    [CustomerId]                 UNIQUEIDENTIFIER NULL,
    [InteractionId]              UNIQUEIDENTIFIER NULL,
    [DigitalReference]           VARCHAR (50)     NULL,
    [WebChatStartDateandTime]    DATETIME         NULL,
    [WebChatEndDateandTime]      DATETIME         NULL,
    [WebChatDuration]            TIME (7)         NULL,
    [WebChatNarrative]           VARCHAR (50)     NULL,
    [SentToCustomer]             BIT              NULL,
    [DateandTimeSentToCustomers] DATETIME         NULL,
    [LastModifiedDate]           DATETIME         NULL,
    [LastModifiedTouchpointId]   VARCHAR (10)     NULL
);

