CREATE TABLE [dbo].[dss-learningprogressions] (
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
    CONSTRAINT [PK_dss-learningprogressions] PRIMARY KEY ([id]) 
);

GO

CREATE NONCLUSTERED INDEX [nci_dss-learningprogressions_customerid] ON [dbo].[dss-learningprogressions] ([CustomerId]) WITH (ONLINE = ON)

GO

