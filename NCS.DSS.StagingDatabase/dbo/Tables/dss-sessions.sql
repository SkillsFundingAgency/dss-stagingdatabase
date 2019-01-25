CREATE TABLE [dbo].[dss-sessions] (
    [id]                       UNIQUEIDENTIFIER NULL,
    [CustomerId]               UNIQUEIDENTIFIER NULL,
    [InteractionId]            UNIQUEIDENTIFIER NULL,
    [DateandTimeOfSession]     DATETIME         NULL,
    [VenuePostCode]            VARCHAR (max)     NULL,
    [SessionAttended]          BIT              NULL,
    [ReasonForNonAttendance]   INT              NULL,
    [LastModifiedDate]         DATETIME         NULL,
    [LastModifiedTouchpointId] VARCHAR (max)     NULL
);

