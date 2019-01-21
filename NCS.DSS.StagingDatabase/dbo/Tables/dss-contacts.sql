CREATE TABLE [dbo].[dss-contacts] (
    [id]                       UNIQUEIDENTIFIER NULL,
    [CustomerId]               UNIQUEIDENTIFIER NULL,
    [PreferredContactMethod]   INT              NULL,
    [MobileNumber]             VARCHAR (50)     NULL,
    [HomeNumber]               VARCHAR (50)     NULL,
    [AlternativeNumber]        VARCHAR (50)     NULL,
    [EmailAddress]             VARCHAR (50)     NULL,
    [LastModifiedDate]         DATETIME         NULL,
    [LastModifiedTouchpointId] VARCHAR (10)     NULL
);

