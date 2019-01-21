CREATE TABLE [dbo].[dss-customers] (
    [id]                         UNIQUEIDENTIFIER NULL,
    [DateOfRegistration]         DATETIME         NULL,
    [Title]                      INT              NULL,
    [GivenName]                  VARCHAR (50)     NULL,
    [FamilyName]                 VARCHAR (50)     NULL,
    [DateofBirth]                DATETIME         NULL,
    [Gender]                     INT              NULL,
    [UniqueLearnerNumber]        VARCHAR (15)     NULL,
    [OptInUserResearch]          BIT              NULL,
    [DateOfTermination]          DATETIME         NULL,
    [ReasonForTermination]       INT              NULL,
    [IntroducedBy]               INT              NULL,
    [IntroducedByAdditionalInfo] VARCHAR (50)     NULL,
    [LastModifiedDate]           DATE             NULL,
    [LastModifiedTouchpointId]   VARCHAR (10)     NULL
);

