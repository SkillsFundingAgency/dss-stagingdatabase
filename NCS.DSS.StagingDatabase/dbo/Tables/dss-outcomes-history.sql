CREATE TABLE [dbo].[dss-outcomes-history](
	[HistoryId] [int] IDENTITY(1,1) NOT NULL,
	[CosmosTimeStamp] [datetime2](7) NOT NULL,
	[id] [uniqueidentifier] NOT NULL,
	[CustomerId] [uniqueidentifier] NULL,
	[ActionPlanId] [uniqueidentifier] NULL,
	[SessionId] [UNIQUEIDENTIFIER] NULL,
	[SubcontractorId] [varchar](50) NULL,	
	[OutcomeType] [int] NULL,
	[OutcomeClaimedDate] [datetime2](7) NULL,
	[OutcomeEffectiveDate] [datetime2](7) NULL,
	[ClaimedPriorityGroup] [int] NULL,
	[TouchpointId] [varchar](max) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedTouchpointId] [varchar](max) NULL,
 CONSTRAINT [PK_dss-outcomes-history] PRIMARY KEY CLUSTERED 
(
	[HistoryId] ASC,
	[CosmosTimeStamp] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

