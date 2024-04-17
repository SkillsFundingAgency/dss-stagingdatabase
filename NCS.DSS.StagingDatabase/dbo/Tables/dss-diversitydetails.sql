CREATE TABLE [dbo].[dss-diversitydetails] (
    [id]                                        UNIQUEIDENTIFIER NOT NULL,
    [CustomerId]                                UNIQUEIDENTIFIER NULL,
    [ConsentToCollectLLDDHealth]                BIT              NULL,
    [LearningDifficultyOrDisabilityDeclaration] INT              NULL,
    [PrimaryLearningDifficultyOrDisability]     INT              NULL,
    [SecondaryLearningDifficultyOrDisability]   INT              NULL,
    [DateAndTimeLLDDHealthConsentCollected]     datetime2         NULL,
    [ConsentToCollectEthnicity]                 BIT              NULL,
    [Ethnicity]                                 INT              NULL,
    [DateAndTimeEthnicityCollected]             datetime2         NULL,
    [LastModifiedDate]                          datetime2         NULL,
    [LastModifiedBy]                  VARCHAR (max)     NULL, 
    CONSTRAINT [PK_dss-diversitydetails] PRIMARY KEY ([id])
);

GO

CREATE NONCLUSTERED INDEX [dss-diversitydetails_customerid] ON [dbo].[dss-diversitydetails] ([CustomerId]) WITH (ONLINE = ON)

GO

