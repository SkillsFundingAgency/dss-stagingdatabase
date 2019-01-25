CREATE TABLE [dbo].[dss-customers] (
    [id]                         UNIQUEIDENTIFIER NULL,
    [DateOfRegistration]         DATETIME         NULL,
    [Title]                      INT              NULL,
    [GivenName]                  VARCHAR (max)     NULL,
    [FamilyName]                 VARCHAR (max)     NULL,
    [DateofBirth]                DATETIME         NULL,
    [Gender]                     INT              NULL,
    [UniqueLearnerNumber]        VARCHAR (15)     NULL,
    [OptInUserResearch]          BIT              NULL,
    [DateOfTermination]          DATETIME         NULL,
    [ReasonForTermination]       INT              NULL,
    [IntroducedBy]               INT              NULL,
    [IntroducedByAdditionalInfo] VARCHAR (max)     NULL,
    [LastModifiedDate]           DATE             NULL,
    [LastModifiedTouchpointId]   VARCHAR (max)     NULL
);

