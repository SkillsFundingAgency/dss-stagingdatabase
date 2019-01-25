CREATE TABLE [dbo].[dss-contacts] (
    [id]                       UNIQUEIDENTIFIER NULL,
    [CustomerId]               UNIQUEIDENTIFIER NULL,
    [PreferredContactMethod]   INT              NULL,
    [MobileNumber]             VARCHAR (max)     NULL,
    [HomeNumber]               VARCHAR (max)     NULL,
    [AlternativeNumber]        VARCHAR (max)     NULL,
    [EmailAddress]             VARCHAR (max)     NULL,
    [LastModifiedDate]         DATETIME         NULL,
    [LastModifiedTouchpointId] VARCHAR (max)     NULL
);

