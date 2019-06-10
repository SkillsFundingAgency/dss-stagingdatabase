CREATE TABLE [dbo].[dss-sessions-history](
	[HistoryId] [int] IDENTITY(1,1) NOT NULL,
	[CosmosTimeStamp] [datetime2](7) NOT NULL,
	[id] [uniqueidentifier] NOT NULL,
	[CustomerId] [uniqueidentifier] NULL,
	[InteractionId] [uniqueidentifier] NULL,
	[SubcontractorId] [varchar](50) NULL,
	[DateandTimeOfSession] [datetime2](7) NULL,
	[VenuePostCode] [varchar](max) NULL,
    [Longitude] [FLOAT](53) NULL,
    [Latitude] [FLOAT](53) NULL,
	[SessionAttended] [bit] NULL,
	[ReasonForNonAttendance] [int] NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedTouchpointId] [varchar](max) NULL,
 CONSTRAINT [PK_dss-sessions-history] PRIMARY KEY CLUSTERED 
(
	[HistoryId] ASC,
	[CosmosTimeStamp] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

