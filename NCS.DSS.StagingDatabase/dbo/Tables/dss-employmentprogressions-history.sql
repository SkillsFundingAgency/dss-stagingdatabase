CREATE TABLE [dbo].[dss-employmentprogressions-history](
	[HistoryId] [int]			     IDENTITY(1,1) NOT NULL,
	[CosmosTimeStamp]				 DATETIME2(7) NOT NULL,
	[id]                             UNIQUEIDENTIFIER NOT NULL,
    [CustomerId]                     UNIQUEIDENTIFIER NULL,
    [DateProgressionRecorded]        DATETIME2        NULL,
    [CurrentEmploymentStatus]		 INT              NULL,
	[EconomicShockStatus]			 INT              NULL,
	[EconomicShockCode]				 VARCHAR (50)     NULL,
    [EmployerName]					 VARCHAR (200)    NULL,
	[EmployerAddress]				 VARCHAR (500)    NULL,
	[EmployerPostcode]               VARCHAR (max)    NULL,
    [Longitude]						 FLOAT (53)       NULL,
    [Latitude]						 FLOAT (53)       NULL,
    [EmploymentHours]				 INT			  NULL,
    [DateOfEmployment]				 DATETIME2        NULL,
	[DateOfLastEmployment]			 DATETIME2        NULL,
    [LengthOfUnemployment]			 INT              NULL,
    [LastModifiedDate]               DATETIME2        NULL,
    [LastModifiedTouchpointId]       VARCHAR (MAX)    NULL, 
	[CreatedBy]					     VARCHAR (MAX)    NULL, 
PRIMARY KEY CLUSTERED 
(
	[HistoryId] ASC,
	[CosmosTimeStamp] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [dss-employmentprogressions-history_customerid] ON [dbo].[dss-employmentprogressions-history] ([CustomerId]) WITH (ONLINE = ON)

GO
