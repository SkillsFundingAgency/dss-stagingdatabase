CREATE TABLE [dbo].[dss-actionplans-history](
	[HistoryId] [int] IDENTITY(1,1) NOT NULL,
	[CosmosTimeStamp] [datetime2](7) NOT NULL,
	[id] [uniqueidentifier] NOT NULL,
	[CustomerId] [uniqueidentifier] NULL,
	[InteractionId] [uniqueidentifier] NULL,
	[SessionId] [uniqueidentifier] NULL,
	[SubcontractorId] [varchar](50) NULL,
	[DateActionPlanCreated] [datetime2](7) NULL,
	[CustomerCharterShownToCustomer] [bit] NULL,
	[DateAndTimeCharterShown] [datetime2](7) NULL,
	[DateActionPlanSentToCustomer] [datetime2](7) NULL,
	[ActionPlanDeliveryMethod] [int] NULL,
	[DateActionPlanAcknowledged] [datetime2](7) NULL,
	[PriorityCustomer] [int] NULL,
	[CurrentSituation] [varchar](max) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedTouchpointId] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[HistoryId] ASC,
	[CosmosTimeStamp] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

