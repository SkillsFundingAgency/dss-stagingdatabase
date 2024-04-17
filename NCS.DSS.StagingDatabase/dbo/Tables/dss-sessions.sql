CREATE TABLE [dbo].[dss-sessions] (
    [id]                       UNIQUEIDENTIFIER NOT NULL,
    [CustomerId]               UNIQUEIDENTIFIER NULL,
    [InteractionId]            UNIQUEIDENTIFIER NULL,
	[SubcontractorId]		   VARCHAR(50) NULL,
    [DateandTimeOfSession]     datetime2         NULL,
    [VenuePostCode]            VARCHAR (max)     NULL,
    [Longitude]                FLOAT (53)       NULL,
    [Latitude]                 FLOAT (53)       NULL,
    [SessionAttended]          BIT              NULL,
    [ReasonForNonAttendance]   INT              NULL,
    [LastModifiedDate]         datetime2         NULL,
    [LastModifiedTouchpointId] VARCHAR (max)     NULL, 
	[CreatedBy]				   VARCHAR (MAX)     NULL, 
    CONSTRAINT [PK_dss-sessions] PRIMARY KEY ([id])
);

GO

CREATE NONCLUSTERED INDEX [dss-sessions_customerid] ON [dbo].[dss-sessions] ([CustomerId]) WITH (ONLINE = ON)

GO
