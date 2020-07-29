CREATE TABLE [dbo].[dss-digitalidentities-history] (
	[HistoryId] [int] IDENTITY(1,1) NOT NULL,
	[CosmosTimeStamp] [datetime2](7) NOT NULL,
    [id]                         UNIQUEIDENTIFIER   NOT NULL,
	[CustomerId]		         UNIQUEIDENTIFIER   NOT NULL,
    [IdentityStoreId]		     UNIQUEIDENTIFIER,
    [LegacyIdentity]             VARCHAR (MAX)        NULL,
    [id_token]                   VARCHAR (max)       NULL,
    [LastLoggedInDateTime]       datetime2          NULL,
    [LastModifiedDate]           datetime2          NULL,
    [LastModifiedTouchpointId]   VARCHAR (max)      NULL, 
    [DateOfClosure]          datetime2          NULL,
	[CreatedBy]					 VARCHAR (MAX)      NULL, 
 CONSTRAINT [PK_dss-digitalidentities-history] PRIMARY KEY CLUSTERED 
(
	[HistoryId] ASC,
	[CosmosTimeStamp] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO