CREATE TABLE [dbo].[dss-employmentprogressions] (
	[id]                             UNIQUEIDENTIFIER NOT NULL,
    [CustomerId]                     UNIQUEIDENTIFIER NULL,
    [DateProgressionRecorded]        DATETIME2        NULL,
    [CurrentEmploymentStatus]		 INT              NULL,
	[EconomicShockStatus]			 INT              NULL,
	[EconomicShockCode]				 VARCHAR (50)    NULL,
    [EmployerName]					 VARCHAR (200)    NULL,
	[EmployerAddress]				 VARCHAR (500)    NULL,
	[EmployerPostcode]               VARCHAR (10)    NULL,
    [Longitude]						 FLOAT (53)       NULL,
    [Latitude]						 FLOAT (53)       NULL,
    [EmploymentHours]				 INT			  NULL,
    [DateOfEmployment]				 DATETIME2        NULL,
	[DateOfLastEmployment]			 DATETIME2        NULL,
    [LengthOfUnemployment]			 INT              NULL,
    [LastModifiedDate]               DATETIME2        NULL,
    [LastModifiedTouchpointId]       VARCHAR (MAX)    NULL, 
	[CreatedBy]					     VARCHAR (MAX)    NULL, 
    CONSTRAINT [PK_dss-employmentprogressions] PRIMARY KEY ([id]) 
);

