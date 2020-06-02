CREATE TABLE [dbo].[dss-digitalidentities] (
    [id]                         UNIQUEIDENTIFIER   NOT NULL,
	[CustomerId]		         UNIQUEIDENTIFIER   NOT NULL,
    [IdentityStoreId]		     UNIQUEIDENTIFIER,
    [LegacyIdentity]             VARCHAR (MAX)        NULL,
    [id_token]                   VARCHAR (max)       NULL,
    [LastLoggedInDateTime]       datetime2          NULL,
    [LastModifiedDate]           datetime2          NULL,
    [LastModifiedTouchpointId]   VARCHAR (max)      NULL, 
    [DateOfTermination]          datetime2          NULL,
	[CreatedBy]					 VARCHAR (MAX)      NULL, 
    CONSTRAINT [PK_dss-digitalidentities] PRIMARY KEY ([id])
);