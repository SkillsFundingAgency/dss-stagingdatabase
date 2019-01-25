CREATE TABLE [dbo].[dss-diversitydetails] (
    [id]                                        UNIQUEIDENTIFIER NULL,
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
    [LastModifiedTouchpointId]                  VARCHAR (max)     NULL
);

