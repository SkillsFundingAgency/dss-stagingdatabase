CREATE TABLE [dbo].[dss-learningprogressions-history](
	[HistoryId] [int]				 IDENTITY(1,1) NOT NULL,
	[CosmosTimeStamp]				 DATETIME2(7) NOT NULL,
	[id]                             UNIQUEIDENTIFIER NOT NULL,
    [CustomerId]                     UNIQUEIDENTIFIER NULL,
    [DateProgressionRecorded]        DATETIME2        NULL,
    [CurrentLearningStatus]			 INT              NULL,
    [LearningHours]					 INT			  NULL,
    [DateLearningStarted]			 DATETIME2        NULL,
    [CurrentQualificationLevel]      INT              NULL,
    [DateQualificationLevelAchieved] DATETIME2        NULL,
    [LastLearningProvidersUKPRN]     VARCHAR (MAX)    NULL,
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

CREATE NONCLUSTERED INDEX [nci_dss-learningprogressions-history_customerid] ON [dbo].[dss-learningprogressions-history] ([CustomerId]) WITH (ONLINE = ON)

GO
