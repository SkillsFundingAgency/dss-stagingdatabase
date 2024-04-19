CREATE TABLE [dbo].[dss-contacts-history](
	[HistoryId] [int] IDENTITY(1,1) NOT NULL,
	[CosmosTimeStamp] [datetime2](7) NOT NULL,
	[id] [uniqueidentifier] NOT NULL,
	[CustomerId]               UNIQUEIDENTIFIER NULL,
    [PreferredContactMethod]   INT              NULL,
    [MobileNumber]             VARCHAR (max)     NULL,
    [HomeNumber]               VARCHAR (max)     NULL,
    [AlternativeNumber]        VARCHAR (max)     NULL,
    [EmailAddress]             VARCHAR (max)     NULL,
    [LastModifiedDate]         datetime2         NULL,
    [LastModifiedTouchpointId] VARCHAR (max)     NULL, 
 CONSTRAINT [PK_dss-contacts-history] PRIMARY KEY CLUSTERED 
(
	[HistoryId] ASC,
	[CosmosTimeStamp] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [nci_dss-contacts-history_customerid] ON [dbo].[dss-contacts-history] ([CustomerId]) WITH (ONLINE = ON)

GO