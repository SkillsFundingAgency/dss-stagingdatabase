CREATE TABLE [dbo].[dss-diversitydetails] (
    [id]                                        UNIQUEIDENTIFIER NULL,
    [CustomerId]                                UNIQUEIDENTIFIER NULL,
    [ConsentToCollectLLDDHealth]                BIT              NULL,
    [LearningDifficultyOrDisabilityDeclaration] INT              NULL,
    [PrimaryLearningDifficultyOrDisability]     INT              NULL,
    [SecondaryLearningDifficultyOrDisability]   INT              NULL,
    [DateAndTimeLLDDHealthConsentCollected]     DATETIME         NULL,
    [ConsentToCollectEthnicity]                 BIT              NULL,
    [Ethnicity]                                 INT              NULL,
    [DateAndTimeEthnicityCollected]             DATETIME         NULL,
    [LastModifiedDate]                          DATETIME         NULL,
    [LastModifiedTouchpointId]                  VARCHAR (max)     NULL
);

