﻿CREATE TABLE [dbo].[dss-customers-history](
	[HistoryId] [int] IDENTITY(1,1) NOT NULL,
	[CosmosTimeStamp] [datetime2](7) NOT NULL,
	[id] [uniqueidentifier] NOT NULL,
	[SubcontractorId] [varchar](50) NULL,
	[DateOfRegistration] [datetime2](7) NULL,
	[Title] [int] NULL,
	[GivenName] [varchar](max) NULL,
	[FamilyName] [varchar](max) NULL,
	[DateofBirth] [datetime2](7) NULL,
	[Gender] [int] NULL,
	[UniqueLearnerNumber] [varchar](15) NULL,
	[OptInMarketResearch] [bit] NULL,
	[OptInUserResearch] [bit] NULL,
	[DateOfTermination] [datetime2](7) NULL,
	[ReasonForTermination] [int] NULL,
	[IntroducedBy] [int] NULL,
	[IntroducedByAdditionalInfo] [varchar](max) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedTouchpointId] [varchar](max) NULL,
 CONSTRAINT [PK_dss-customers-history] PRIMARY KEY CLUSTERED 
(
	[HistoryId] ASC,
	[CosmosTimeStamp] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


