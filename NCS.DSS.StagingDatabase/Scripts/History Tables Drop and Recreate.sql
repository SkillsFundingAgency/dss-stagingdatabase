IF OBJECT_ID('[dss-actionplans-history]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-actionplans-history]

			CREATE TABLE [dbo].[dss-actionplans-history](
					[HistoryId] [INT] IDENTITY(1,1) NOT NULL,
					[CosmosTimeStamp] [DATETIME2](7) NOT NULL,
					[id] [UNIQUEIDENTIFIER] NOT NULL,
					[CustomerId] [UNIQUEIDENTIFIER] NULL,
					[InteractionId] [UNIQUEIDENTIFIER] NULL,
					[SessionId] [UNIQUEIDENTIFIER] NULL,
					[SubcontractorId] [VARCHAR](50) NULL,
					[DateActionPlanCreated] [DATETIME2](7) NULL,
					[CustomerCharterShownToCustomer] [BIT] NULL,
					[DateAndTimeCharterShown] [DATETIME2](7) NULL,
					[DateActionPlanSentToCustomer] [DATETIME2](7) NULL,
					[ActionPlanDeliveryMethod] [INT] NULL,
					[DateActionPlanAcknowledged] [DATETIME2](7) NULL,
					[PriorityCustomer] [INT] NULL,
					[CurrentSituation] [VARCHAR](MAX) NULL,
					[LastModifiedDate] [DATETIME2](7) NULL,
					[LastModifiedTouchpointId] [VARCHAR](MAX) NULL,
			PRIMARY KEY CLUSTERED 
			(
				[HistoryId] ASC,
				[CosmosTimeStamp] ASC,
				[id] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
		END


IF OBJECT_ID('[dss-actions-history]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-actions-history]

			CREATE TABLE [dbo].[dss-actions-history](
					[HistoryId] [INT] IDENTITY(1,1) NOT NULL,
					[CosmosTimeStamp] [DATETIME2](7) NOT NULL,
					[id] [UNIQUEIDENTIFIER] NOT NULL,
					[CustomerId] [UNIQUEIDENTIFIER] NULL,
					[ActionPlanId] [UNIQUEIDENTIFIER] NULL,
					[SubcontractorId] [VARCHAR](50) NULL,
					[DateActionAgreed] [DATETIME2](7) NULL,
					[DateActionAimsToBeCompletedBy] [DATETIME2](7) NULL,
					[DateActionActuallyCompleted] [DATETIME2](7) NULL,
					[ActionSummary] [VARCHAR](MAX) NULL,
					[SignpostedTo] [VARCHAR](MAX) NULL,
					[ActionType] [INT] NULL,
					[ActionStatus] [INT] NULL,
					[PersonResponsible] [INT] NULL,
					[LastModifiedDate] [VARCHAR](MAX) NULL,
					[LastModifiedTouchpointId] [VARCHAR](MAX) NULL,
				CONSTRAINT [PK_dss-actions-history] PRIMARY KEY CLUSTERED 
				(
						[HistoryId] ASC,
						[CosmosTimeStamp] ASC,
						[id] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
		END

IF OBJECT_ID('[dss-addresses-history]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-addresses-history]

			CREATE TABLE [dbo].[dss-addresses-history](
					[HistoryId] [INT] IDENTITY(1,1) NOT NULL,
					[CosmosTimeStamp] [DATETIME2](7) NOT NULL,
					[id] [UNIQUEIDENTIFIER] NOT NULL,
					[CustomerId] [UNIQUEIDENTIFIER] NULL,
					[SubcontractorId] [VARCHAR](50) NULL,
					[Address1] [VARCHAR](MAX) NULL,
					[Address2] [VARCHAR](MAX) NULL,
					[Address3] [VARCHAR](MAX) NULL,
					[Address4] [VARCHAR](MAX) NULL,
					[Address5] [VARCHAR](MAX) NULL,
					[PostCode] [VARCHAR](MAX) NULL,
					[AlternativePostCode] [VARCHAR](MAX) NULL,
					[Longitude] [FLOAT] NULL,
					[Latitude] [FLOAT] NULL,
					[EffectiveFrom] [DATETIME2](7) NULL,
					[EffectiveTo] [DATETIME2](7) NULL,
					[LastModifiedDate] [DATETIME2](7) NULL,
					[LastModifiedTouchpointId] [VARCHAR](MAX) NULL,
				CONSTRAINT [PK_dss-addresses-history] PRIMARY KEY CLUSTERED 
				(
					[HistoryId] ASC,
					[CosmosTimeStamp] ASC,
					[id] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
		END

IF OBJECT_ID('[dss-adviserdetails-history]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-adviserdetails-history]

			CREATE TABLE [dbo].[dss-adviserdetails-history](
					[HistoryId] [INT] IDENTITY(1,1) NOT NULL,
					[CosmosTimeStamp] [DATETIME2](7) NOT NULL,
					[id] [UNIQUEIDENTIFIER] NOT NULL,
					[SubcontractorId] [VARCHAR](50) NULL,
					[AdviserName] [VARCHAR](MAX) NULL,
					[AdviserEmailAddress] [VARCHAR](MAX) NULL,
					[AdviserContactNumber] [VARCHAR](MAX) NULL,
					[LastModifiedDate] [DATETIME2](7) NULL,
					[LastModifiedTouchpointId] [VARCHAR](MAX) NULL,
				CONSTRAINT [PK_dss-adviserdetails-history] PRIMARY KEY CLUSTERED 
				(
					[HistoryId] ASC,
					[CosmosTimeStamp] ASC,
					[id] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
		END

IF OBJECT_ID('[dss-customers-history]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-customers-history]

			CREATE TABLE [dbo].[dss-customers-history](
					[HistoryId] [INT] IDENTITY(1,1) NOT NULL,
					[CosmosTimeStamp] [DATETIME2](7) NOT NULL,
					[id] [uniqueidentifier] NOT NULL,
					[SubcontractorId] [varchar](50) NULL,
					[DateOfRegistration] [datetime2](7) NULL,
					[Title] [int] NULL,
					[GivenName] [varchar](max) NULL,
					[FamilyName] [varchar](max) NULL,
					[DateofBirth] [datetime2](7) NULL,
					[Gender] [int] NULL,
					[UniqueLearnerNumber] [varchar](15) NULL,
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
		END
		
IF OBJECT_ID('[dss-diversitydetails-history]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-diversitydetails-history]

			CREATE TABLE [dbo].[dss-diversitydetails-history](
					[HistoryId]									[int] IDENTITY(1,1) NOT NULL,
					[CosmosTimeStamp]							[datetime2](7)		NOT NULL,
					[id]										[uniqueidentifier]  NOT NULL,
					[CustomerId]                                [UNIQUEIDENTIFIER]  NULL,
					[ConsentToCollectLLDDHealth]                [BIT]               NULL,
					[LearningDifficultyOrDisabilityDeclaration] [INT]               NULL,
					[PrimaryLearningDifficultyOrDisability]     [INT]               NULL,
					[SecondaryLearningDifficultyOrDisability]   [INT]               NULL,
					[DateAndTimeLLDDHealthConsentCollected]     [datetime2]         NULL,
					[ConsentToCollectEthnicity]                 [BIT]               NULL,
					[Ethnicity]                                 [INT]               NULL,
					[DateAndTimeEthnicityCollected]             [datetime2]         NULL,
					[LastModifiedDate]                          [datetime2]         NULL,
					[LastModifiedTouchpointId]                  [VARCHAR] (max)     NULL,
				 CONSTRAINT [PK_dss-diversitydetails-history] PRIMARY KEY CLUSTERED 
				(
					[HistoryId] ASC,
					[CosmosTimeStamp] ASC,
					[id] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
		END

IF OBJECT_ID('[dss-goals-history]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-goals-history]

			CREATE TABLE [dbo].[dss-goals-history](
					[HistoryId] [int] IDENTITY(1,1) NOT NULL,
					[CosmosTimeStamp] [datetime2](7) NOT NULL,
					[id] [uniqueidentifier] NOT NULL,
					[CustomerId] [uniqueidentifier] NULL,
					[ActionPlanId] [uniqueidentifier] NULL,
					[SubcontractorId] [varchar](50) NULL,
					[DateGoalCaptured] [datetime2](7) NULL,
					[DateGoalShouldBeCompletedBy] [datetime2](7) NULL,
					[DateGoalAchieved] [datetime2](7) NULL,
					[GoalSummary] [varchar](max) NULL,
					[GoalType] [int] NULL,
					[GoalStatus] [int] NULL,
					[LastModifiedDate] [datetime2](7) NULL,
					[LastModifiedTouchpointId] [varchar](max) NULL,
					CONSTRAINT [PK_dss-goals-history] PRIMARY KEY CLUSTERED 
					(
						[HistoryId] ASC,
						[CosmosTimeStamp] ASC,
						[id] ASC
					)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
					) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
		END

IF OBJECT_ID('[dss-interactions-history]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-interactions-history]
		
			CREATE TABLE [dbo].[dss-interactions-history] (
					[HistoryId] [INT] IDENTITY(1,1) NOT NULL,
					[CosmosTimeStamp] [DATETIME2](7) NOT NULL,
					[id] UNIQUEIDENTIFIER NOT NULL,
					[CustomerId] UNIQUEIDENTIFIER NULL,
					[TouchpointId] VARCHAR (max)     NULL,
					[AdviserDetailsId] UNIQUEIDENTIFIER NULL,
					[DateandTimeOfInteraction] datetime2 NULL,
					[Channel] INT NULL,
					[InteractionType] INT NULL,
					[LastModifiedDate] datetime2 NULL,
					[LastModifiedTouchpointId] VARCHAR (max) NULL, 
					CONSTRAINT [PK_dss-interactions-history] PRIMARY KEY CLUSTERED 
				(
					[HistoryId] ASC,
					[CosmosTimeStamp] ASC,
					[id] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
		END

IF OBJECT_ID('[dss-outcomes-history]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-outcomes-history]

			CREATE TABLE [dbo].[dss-outcomes-history](
					[HistoryId] [INT] IDENTITY(1,1) NOT NULL,
					[CosmosTimeStamp] [DATETIME2](7) NOT NULL,
					[id] [UNIQUEIDENTIFIER] NOT NULL,
					[CustomerId] [UNIQUEIDENTIFIER] NULL,
					[ActionPlanId] [UNIQUEIDENTIFIER] NULL,
					[SessionId] [UNIQUEIDENTIFIER] NULL,
					[SubcontractorId] [VARCHAR](50) NULL,	
					[OutcomeType] [INT] NULL,
					[OutcomeClaimedDate] [DATETIME2](7) NULL,
					[OutcomeEffectiveDate] [DATETIME2](7) NULL,
					[ClaimedPriorityGroup] [INT] NULL,
					[TouchpointId] [VARCHAR](MAX) NULL,
					[LastModifiedDate] [DATETIME2](7) NULL,
					[LastModifiedTouchpointId] [VARCHAR](MAX) NULL,
				CONSTRAINT [PK_dss-outcomes-history] PRIMARY KEY CLUSTERED 
				(
					[HistoryId] ASC,
					[CosmosTimeStamp] ASC,
					[id] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
		END

IF OBJECT_ID('[dss-sessions-history]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-sessions-history]

			CREATE TABLE [dbo].[dss-sessions-history](
					[HistoryId] [INT] IDENTITY(1,1) NOT NULL,
					[CosmosTimeStamp] [DATETIME2](7) NOT NULL,
					[id] [UNIQUEIDENTIFIER] NOT NULL,
					[CustomerId] [UNIQUEIDENTIFIER] NULL,
					[InteractionId] [UNIQUEIDENTIFIER] NULL,
					[SubcontractorId] [VARCHAR](50) NULL,
					[DateandTimeOfSession] [DATETIME2](7) NULL,
					[VenuePostCode] [VARCHAR](MAX) NULL,
					[SessionAttended] [BIT] NULL,
					[ReasonForNonAttendance] [INT] NULL,
					[LastModifiedDate] [DATETIME2](7) NULL,
					[LastModifiedTouchpointId] [VARCHAR](MAX) NULL,
				CONSTRAINT [PK_dss-sessions-history] PRIMARY KEY CLUSTERED 
				(
					[HistoryId] ASC,
					[CosmosTimeStamp] ASC,
					[id] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
		END