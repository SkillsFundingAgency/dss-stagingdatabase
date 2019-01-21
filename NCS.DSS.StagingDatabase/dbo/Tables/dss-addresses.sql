CREATE TABLE [dbo].[dss-addresses] (
    [id]                       UNIQUEIDENTIFIER NULL,
    [CustomerId]               UNIQUEIDENTIFIER NULL,
    [Address1]                 VARCHAR (50)     NULL,
    [Address2]                 VARCHAR (50)     NULL,
    [Address3]                 VARCHAR (50)     NULL,
    [Address4]                 VARCHAR (50)     NULL,
    [Address5]                 VARCHAR (50)     NULL,
    [PostCode]                 VARCHAR (50)     NULL,
    [AlternativePostCode]      VARCHAR (20)     NULL,
    [Longitude]                FLOAT (53)       NULL,
    [Latitude]                 FLOAT (53)       NULL,
    [EffectiveFrom]            DATETIME         NULL,
    [EffectiveTo]              DATETIME         NULL,
    [LastModifiedDate]         DATETIME         NULL,
    [LastModifiedTouchpointId] VARCHAR (10)     NULL
);

