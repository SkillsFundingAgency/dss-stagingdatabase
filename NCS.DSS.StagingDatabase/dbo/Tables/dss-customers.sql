﻿CREATE TABLE [dbo].[dss-customers] (
    [id]                         UNIQUEIDENTIFIER NULL,
	[SubcontractorId]		     VARCHAR(50) NULL,
    [DateOfRegistration]         datetime2         NULL,
    [Title]                      INT              NULL,
    [GivenName]                  VARCHAR (max)     NULL,
    [FamilyName]                 VARCHAR (max)     NULL,
    [DateofBirth]                datetime2         NULL,
    [Gender]                     INT              NULL,
    [UniqueLearnerNumber]        VARCHAR (15)     NULL,
    [OptInUserResearch]          BIT              NULL,
    [DateOfTermination]          datetime2         NULL,
    [ReasonForTermination]       INT              NULL,
    [IntroducedBy]               INT              NULL,
    [IntroducedByAdditionalInfo] VARCHAR (max)     NULL,
    [LastModifiedDate]           datetime2             NULL,
    [LastModifiedTouchpointId]   VARCHAR (max)     NULL
);

