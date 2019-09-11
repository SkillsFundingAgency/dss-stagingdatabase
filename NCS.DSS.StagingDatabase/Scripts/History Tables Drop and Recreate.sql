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
		
IF OBJECT_ID('[dss-collections-history]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-collections-history]

			CREATE TABLE [dbo].[dss-collections-history](
					[HistoryId] [int]	IDENTITY(1,1) NOT NULL,
					[CosmosTimeStamp]	DATETIME2(7) NOT NULL,
					[id]				UNIQUEIDENTIFIER NOT NULL,
					[ContainerName]		VARCHAR (max) NULL,
					[ReportFileName]	VARCHAR (max) NULL,
					[CollectionReports] VARCHAR (max) NULL,
					[TouchPointId]		VARCHAR (max) NULL,
					[Ukprn]				VARCHAR (max) NULL,
					[LastModifiedDate]	DATETIME2 (7) NULL,
				 CONSTRAINT [PK_dss-collections-history] PRIMARY KEY CLUSTERED 
				(
					[HistoryId] ASC,
					[CosmosTimeStamp] ASC,
					[id] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
				
		END

IF OBJECT_ID('[dss-contacts-history]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-contacts-history]

			CREATE TABLE [dbo].[dss-contacts-history](
					[HistoryId] [int] IDENTITY(1,1) NOT NULL,
					[CosmosTimeStamp] [datetime2](7) NOT NULL,
					[id] [uniqueidentifier] NOT NULL,
					[CustomerId]               UNIQUEIDENTIFIER NULL,
					[PreferredContactMethod]   INT              NULL,
					[MobileNumber]             VARCHAR (max)     NULL,
					[HomeNumber]               VARCHAR (max)     NULL,
					[AlternativeNumber]        VARCHAR (max)     NULL,
					[EmailAddress]             VARCHAR (max)     NULL,
					[LastModifiedDate]         datetime2         NULL,
					[LastModifiedTouchpointId] VARCHAR (max)     NULL, 
				 CONSTRAINT [PK_dss-contacts-history] PRIMARY KEY CLUSTERED 
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

IF OBJECT_ID('[dss-employmentprogressions-history]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-employmentprogressions-history]

			CREATE TABLE [dbo].[dss-employmentprogressions-history](
					[HistoryId]						INT IDENTITY(1,1)	NOT NULL,
					[CosmosTimeStamp]				DATETIME2(7)		NOT NULL,
					[id]							UNIQUEIDENTIFIER	NOT NULL,
					[CustomerId]                    UNIQUEIDENTIFIER	NULL,
					[DateProgressionRecorded]       DATETIME2			NULL,
					[CurrentEmploymentStatus]		INT					NULL,
					[EconomicShockStatus]			INT					NULL,
					[EconomicShockCode]				VARCHAR (50)		NULL,
					[EmployerName]					VARCHAR (200)		NULL,
					[EmployerAddress]				VARCHAR (500)		NULL,
					[EmployerPostcode]              VARCHAR (10)		NULL,
					[Longitude]						FLOAT (53)			NULL,
					[Latitude]						FLOAT (53)			NULL,
					[EmploymentHours]				INT					NULL,
					[DateOfEmployment]				DATETIME2			NULL,
					[DateOfLastEmployment]			DATETIME2			NULL,
					[LengthOfUnemployment]			INT					NULL,
					[LastModifiedDate]              DATETIME2			NULL,
					[LastModifiedTouchpointId]      VARCHAR (MAX)		NULL, 
					[CreatedBy]					    VARCHAR (MAX)		NULL, 
				 CONSTRAINT [PK_dss-employmentprogressions-history] PRIMARY KEY CLUSTERED 
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

IF OBJECT_ID('[dss-learningprogressions-history]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-learningprogressions-history]

			CREATE TABLE [dbo].[dss-learningprogressions-history](
					[HistoryId] [INT]				 IDENTITY(1,1) NOT NULL,
					[CosmosTimeStamp]				 DATETIME2(7) NOT NULL,
					[id]                             UNIQUEIDENTIFIER NOT NULL,
					[CustomerId]                     UNIQUEIDENTIFIER NULL,
					[DateProgressionRecorded]        DATETIME2        NULL,
					[CurrentLearningStatus]			 INT              NULL,
					[LearningHours]					 INT			  NULL,
					[DateLearningStarted]			 DATETIME2        NULL,
					[CurrentQualificationLevel]      INT              NULL,
					[DateQualificationLevelAchieved] DATETIME2        NULL,
					[LastLearningProvidersUKPRN]     VARCHAR (MAX)    NULL,
					[LastModifiedDate]               DATETIME2        NULL,
					[LastModifiedTouchpointId]       VARCHAR (MAX)    NULL, 
					[CreatedBy]					     VARCHAR (MAX)    NULL, 
				 CONSTRAINT [PK_dss-learningprogressions-history] PRIMARY KEY CLUSTERED 
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

IF OBJECT_ID('[dss-subscriptions-history]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-subscriptions-history]

			CREATE TABLE [dbo].[dss-subscriptions-history] (
					[HistoryId] [int]		   IDENTITY(1,1) NOT NULL,
					[CosmosTimeStamp]		   datetime2(7) NOT NULL,
					[id]			           UNIQUEIDENTIFIER NOT NULL,
					[CustomerId]               UNIQUEIDENTIFIER NULL,
					[TouchPointId]             VARCHAR (max)     NULL,
					[Subscribe]                BIT              NULL,
					[LastModifiedDate]         datetime2         NULL,
					[LastModifiedTouchpointId] VARCHAR (max)     NULL,
				CONSTRAINT [PK_dss-subscriptions-history] PRIMARY KEY CLUSTERED 
				(
					[HistoryId] ASC,
					[CosmosTimeStamp] ASC,
					[id] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

		END
IF OBJECT_ID('[dss-transfers-history]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-transfers-history]

			CREATE TABLE [dbo].[dss-transfers-history] (
					[HistoryId] [int]				IDENTITY(1,1) NOT NULL,
					[CosmosTimeStamp]				datetime2(7) NOT NULL,
					[id]                            UNIQUEIDENTIFIER NOT NULL,
					[CustomerId]                    UNIQUEIDENTIFIER NULL,
					[InteractionId]                 UNIQUEIDENTIFIER NULL,
					[OriginatingTouchpointId]       VARCHAR (max)     NULL,
					[TargetTouchpointId]            VARCHAR (max)     NULL,
					[Context]                       VARCHAR (max)     NULL,
					[DateandTimeOfTransfer]         datetime2         NULL,
					[DateandTimeofTransferAccepted] datetime2         NULL,
					[RequestedCallbackTime]         datetime2         NULL,
					[ActualCallbackTime]            datetime2         NULL,
					[LastModifiedDate]              datetime2         NULL,
					[LastModifiedTouchpointId]      VARCHAR (max)     NULL,
				PRIMARY KEY CLUSTERED 
				(
					[HistoryId] ASC,
					[CosmosTimeStamp] ASC,
					[id] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

		END
		
IF OBJECT_ID('[dss-webchats-history]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-webchats-history]

			CREATE TABLE [dbo].[dss-webchats-history] (
					[HistoryId] [int]			 IDENTITY(1,1) NOT NULL,
					[CosmosTimeStamp]			 datetime2(7) NOT NULL,
					[id]                         UNIQUEIDENTIFIER NOT NULL,
					[CustomerId]                 UNIQUEIDENTIFIER NULL,
					[InteractionId]              UNIQUEIDENTIFIER NULL,
					[DigitalReference]           VARCHAR (max)     NULL,
					[WebChatStartDateandTime]    datetime2         NULL,
					[WebChatEndDateandTime]      datetime2         NULL,
					[WebChatDuration]            TIME (7)         NULL,
					[WebChatNarrative]           VARCHAR (max)     NULL,
					[SentToCustomer]             BIT              NULL,
					[DateandTimeSentToCustomers] datetime2         NULL,
					[LastModifiedDate]           datetime2         NULL,
					[LastModifiedTouchpointId]   VARCHAR (max)     NULL, 
				PRIMARY KEY CLUSTERED 
				(
					[HistoryId] ASC,
					[CosmosTimeStamp] ASC,
					[id] ASC
				)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
				) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

		END