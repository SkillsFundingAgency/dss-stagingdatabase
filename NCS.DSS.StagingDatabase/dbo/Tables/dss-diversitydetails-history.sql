CREATE TABLE [dbo].[dss-diversitydetails-history](
	[HistoryId]									[int] IDENTITY(1,1) NOT NULL,
	[CosmosTimeStamp]							[datetime2](7)		NOT NULL,
	[id]										[uniqueidentifier]  NOT NULL,
	[CustomerId]                                [UNIQUEIDENTIFIER]  NULL,
    [ConsentToCollectLLDDHealth]                [BIT]               NULL,
    [LearningDifficultyOrDisabilityDeclaration] [INT]               NULL,
    [PrimaryLearningDifficultyOrDisability]     [INT]               NULL,
    [SecondaryLearningDifficultyOrDisability]   [INT]               NULL,
    [DateAndTimeLLDDHealthConsentCollected]     [datetime2]         NULL,
    [ConsentToCollectEthnicity]                 [BIT]               NULL,
    [Ethnicity]                                 [INT]               NULL,
    [DateAndTimeEthnicityCollected]             [datetime2]         NULL,
    [LastModifiedDate]                          [datetime2]         NULL,
    [LastModifiedBy]                  [VARCHAR] (max)     NULL,
 CONSTRAINT [PK_dss-diversitydetails-history] PRIMARY KEY CLUSTERED 
(
	[HistoryId] ASC,
	[CosmosTimeStamp] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [dss-diversitydetails-history_customerid] ON [dbo].[dss-diversitydetails-history] ([CustomerId]) WITH (ONLINE = ON)

GO

