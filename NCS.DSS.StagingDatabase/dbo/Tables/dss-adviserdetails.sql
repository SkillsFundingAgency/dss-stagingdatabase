CREATE TABLE [dbo].[dss-adviserdetails] (
    [id]                       UNIQUEIDENTIFIER NULL,
    [AdviserName]              VARCHAR (max)     NULL,
    [AdviserEmailAddress]      VARCHAR (max)     NULL,
    [AdviserContactNumber]     VARCHAR (max)     NULL,
    [LastModifiedDate]         datetime2         NULL,
    [LastModifiedTouchpointId] VARCHAR (max)     NULL
);

