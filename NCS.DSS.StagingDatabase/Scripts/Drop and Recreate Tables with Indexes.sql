IF OBJECT_ID('[dss-actionplans]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-actionplans]

			CREATE TABLE [dbo].[dss-actionplans] (
						 [id] UNIQUEIDENTIFIER NOT NULL,
						 [CustomerId] UNIQUEIDENTIFIER NULL,
						 [InteractionId] UNIQUEIDENTIFIER NULL,
						 [SessionId] UNIQUEIDENTIFIER NULL,
						 [SubcontractorId] VARCHAR(50) NULL,
						 [DateActionPlanCreated] datetime2 NULL,
                         [CustomerCharterShownToCustomer] BIT NULL,
                         [DateAndTimeCharterShown] DATETIME2 (7) NULL,
                         [DateActionPlanSentToCustomer] DATETIME2 NULL,
                         [ActionPlanDeliveryMethod] INT NULL,
                         [DateActionPlanAcknowledged] datetime2 NULL,
                         [PriorityCustomer] INT NULL,
                         [CurrentSituation] VARCHAR (MAX) NULL,
                         [LastModifiedDate] datetime2 NULL,
                         [LastModifiedTouchpointId] VARCHAR (MAX) NULL, 
                         CONSTRAINT [PK_dss-actionplans] PRIMARY KEY ([id]))
						 ON [PRIMARY]
		END

IF OBJECT_ID('[dss-actions]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-actions]

			CREATE TABLE [dbo].[dss-actions] (
							   [id] UNIQUEIDENTIFIER NOT NULL,
							   [CustomerId] UNIQUEIDENTIFIER NULL,	
							   [ActionPlanId] UNIQUEIDENTIFIER NULL,
							   [SubcontractorId] VARCHAR(50) NULL,
							   [DateActionAgreed] datetime2 NULL,
							   [DateActionAimsToBeCompletedBy] datetime2 NULL,
							   [DateActionActuallyCompleted]   datetime2 NULL,
							   [ActionSummary] VARCHAR (max) NULL,
							   [SignpostedTo] VARCHAR (max) NULL,
							   [ActionType] INT NULL,
							   [ActionStatus] INT NULL,
							   [PersonResponsible] INT NULL,
							   [LastModifiedDate] VARCHAR (max) NULL,
							   [LastModifiedTouchpointId] VARCHAR (max) NULL, 
							CONSTRAINT [PK_dss-actions] PRIMARY KEY ([id]))
							ON [PRIMARY]
		END
	
IF OBJECT_ID('[dss-addresses]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-addresses]
					
			CREATE TABLE [dbo].[dss-addresses] (
							   [id] UNIQUEIDENTIFIER NOT NULL,
							   [CustomerId] UNIQUEIDENTIFIER NULL,
							   [SubcontractorId] VARCHAR(50) NULL,
							   [Address1] VARCHAR (max) NULL,
							   [Address2] VARCHAR (max) NULL,
							   [Address3] VARCHAR (max) NULL,
							   [Address4] VARCHAR (max) NULL,
							   [Address5] VARCHAR (max) NULL,
							   [PostCode] VARCHAR (max) NULL,
							   [AlternativePostCode] VARCHAR (max) NULL,
							   [Longitude] FLOAT (53) NULL,
							   [Latitude] FLOAT (53) NULL,
							   [EffectiveFrom] datetime2 NULL,
							   [EffectiveTo] datetime2 NULL,
							   [LastModifiedDate] datetime2 NULL,
							   [LastModifiedTouchpointId] VARCHAR (max) NULL, 
                               CONSTRAINT [PK_dss-addresses] PRIMARY KEY ([id]))
							   ON [PRIMARY]
		END

IF OBJECT_ID('[dss-adviserdetails]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-adviserdetails]
		
			CREATE TABLE [dbo].[dss-adviserdetails] (
							   [id] UNIQUEIDENTIFIER NOT NULL,
							   [SubcontractorId] VARCHAR(50) NULL,
							   [AdviserName] VARCHAR (max) NULL,
							   [AdviserEmailAddress] VARCHAR (max) NULL,
							   [AdviserContactNumber] VARCHAR (max) NULL,
							   [LastModifiedDate] datetime2 NULL,
							   [LastModifiedTouchpointId] VARCHAR (max) NULL, 
							   CONSTRAINT [PK_dss-adviserdetails] PRIMARY KEY ([id]))
	                           ON [PRIMARY]
		END

IF OBJECT_ID('[dss-contacts]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-contacts]
		
			CREATE TABLE [dbo].[dss-contacts] (
							   [id] UNIQUEIDENTIFIER NOT NULL,
							   [CustomerId] UNIQUEIDENTIFIER NULL,
							   [PreferredContactMethod] INT NULL,
							   [MobileNumber] VARCHAR (MAX) NULL,
							   [HomeNumber] VARCHAR (MAX) NULL,
							   [AlternativeNumber] VARCHAR (MAX) NULL,
							   [EmailAddress] VARCHAR (MAX) NULL,
							   [LastModifiedDate] DATETIME2 NULL,
							   [LastModifiedTouchpointId] VARCHAR (MAX) NULL, 
							   CONSTRAINT [PK_dss-contacts] PRIMARY KEY ([id]))
							   ON [PRIMARY]
		END

IF OBJECT_ID('[dss-collections]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-collections]
		
			CREATE TABLE [dbo].[dss-collections] (
							   	[id]				UNIQUEIDENTIFIER NOT NULL,
								[ContainerName]		VARCHAR (max) NULL,
								[ReportFileName]	VARCHAR (max) NULL,
								[CollectionReports] VARCHAR (max) NULL,
								[TouchPointId]		VARCHAR (max) NULL,
								[Ukprn]				VARCHAR (max) NULL,
								[LastModifiedDate]	DATETIME2 (7) NULL,
							   CONSTRAINT [PK_dss-contacts] PRIMARY KEY ([id]))
							   ON [PRIMARY]
		END

IF OBJECT_ID('[dss-customers]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-customers]
		
			CREATE TABLE [dbo].[dss-customers] (
							   [id] UNIQUEIDENTIFIER NOT NULL,
							   [SubcontractorId] VARCHAR(50) NULL,
							   [DateOfRegistration] datetime2 NULL,
							   [Title] INT NULL,
							   [GivenName] VARCHAR (max) NULL,
							   [FamilyName] VARCHAR (max) NULL,
							   [DateofBirth] datetime2 NULL,
							   [Gender] INT NULL,
							   [UniqueLearnerNumber] VARCHAR (15) NULL,
							   [OptInUserResearch] BIT NULL,
							   [DateOfTermination] datetime2 NULL,
							   [ReasonForTermination] INT NULL,
							   [IntroducedBy] INT NULL,
							   [IntroducedByAdditionalInfo] VARCHAR (max) NULL,
							   [LastModifiedDate] datetime2 NULL,
							   [LastModifiedTouchpointId] VARCHAR (max) NULL, 
							   CONSTRAINT [PK_dss-customers] PRIMARY KEY ([id]))
							   ON [PRIMARY]
		END

IF OBJECT_ID('[dss-diversitydetails]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-diversitydetails]
		
			CREATE TABLE [dbo].[dss-diversitydetails] (
							   [id] UNIQUEIDENTIFIER NOT NULL,
							   [CustomerId] UNIQUEIDENTIFIER NULL,
							   [ConsentToCollectLLDDHealth] BIT NULL,
							   [LearningDifficultyOrDisabilityDeclaration] INT NULL,
							   [PrimaryLearningDifficultyOrDisability] INT NULL,
							   [SecondaryLearningDifficultyOrDisability] INT NULL,
							   [DateAndTimeLLDDHealthConsentCollected] datetime2 NULL,
							   [ConsentToCollectEthnicity] BIT NULL,
							   [Ethnicity] INT NULL,
							   [DateAndTimeEthnicityCollected] datetime2 NULL,
							   [LastModifiedDate] datetime2 NULL,
							   [LastModifiedTouchpointId] VARCHAR (max) NULL, 
							   CONSTRAINT [PK_dss-diversitydetails] PRIMARY KEY ([id]))
							   ON [PRIMARY]
		END
		
		
IF OBJECT_ID('[dss-employmentprogressions]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-employmentprogressions]
		
			CREATE TABLE [dbo].[dss-employmentprogressions] (
							   [id]                             UNIQUEIDENTIFIER NOT NULL,
							   [CustomerId]                     UNIQUEIDENTIFIER NULL,
							   [DateProgressionRecorded]        DATETIME2        NULL,
							   [CurrentEmploymentStatus]		INT              NULL,
							   [EconomicShockStatus]			INT              NULL,
							   [EconomicShockCode]				VARCHAR (50)     NULL,
							   [EmployerName]					VARCHAR (200)    NULL,
							   [EmployerAddress]				VARCHAR (500)    NULL,
							   [EmployerPostcode]               VARCHAR (10)     NULL,
							   [Longitude]						FLOAT (53)       NULL,
							   [Latitude]						FLOAT (53)       NULL,
							   [EmploymentHours]				INT			     NULL,
							   [DateOfEmployment]				DATETIME2        NULL,
							   [DateOfLastEmployment]			DATETIME2        NULL,
							   [LengthOfUnemployment]			INT              NULL,
							   [LastModifiedDate]               DATETIME2        NULL,
							   [LastModifiedTouchpointId]       VARCHAR (MAX)    NULL, 
							   [CreatedBy]					    VARCHAR (MAX)    NULL, 
							   CONSTRAINT [PK_dss-employmentprogressions] PRIMARY KEY ([id]))
							   ON [PRIMARY]
		END

IF OBJECT_ID('[dss-goals]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-goals]
		
			CREATE TABLE [dbo].[dss-goals] (
							   [id] UNIQUEIDENTIFIER NOT NULL,
							   [CustomerId] UNIQUEIDENTIFIER NULL,
							   [ActionPlanId] UNIQUEIDENTIFIER NULL,
							   [SubcontractorId] VARCHAR(50) NULL,
							   [DateGoalCaptured] datetime2 NULL,
							   [DateGoalShouldBeCompletedBy] datetime2 NULL,
							   [DateGoalAchieved] datetime2 NULL,
							   [GoalSummary] VARCHAR (max) NULL,
							   [GoalType] INT NULL,
							   [GoalStatus] INT NULL,
							   [LastModifiedDate] datetime2 NULL,
							   [LastModifiedBy] VARCHAR (max) NULL, 
							   CONSTRAINT [PK_dss-goals] PRIMARY KEY ([id]))
							   ON [PRIMARY]
		END

IF OBJECT_ID('[dss-interactions]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-interactions]
		
			CREATE TABLE [dbo].[dss-interactions] (
							   [id] UNIQUEIDENTIFIER NOT NULL,
							   [CustomerId] UNIQUEIDENTIFIER NULL,
							   [TouchpointId] VARCHAR (max)     NULL,
							   [AdviserDetailsId] UNIQUEIDENTIFIER NULL,
							   [DateandTimeOfInteraction] datetime2 NULL,
							   [Channel] INT NULL,
							   [InteractionType] INT NULL,
							   [LastModifiedDate] datetime2 NULL,
							   [LastModifiedTouchpointId] VARCHAR (max) NULL, 
							   CONSTRAINT [PK_dss-interactions] PRIMARY KEY ([id]))
							   ON [PRIMARY]
		END

IF OBJECT_ID('[dss-learningprogression', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-learningprogression]
		
			CREATE TABLE [dbo].[dss-learningprogression] (
							   [id]                             UNIQUEIDENTIFIER NOT NULL,
							   [CustomerId]                     UNIQUEIDENTIFIER NULL,
							   [DateProgressionRecorded]        DATETIME2        NULL,
							   [CurrentLearningStatus]			INT              NULL,
							   [LearningHours]					INT				 NULL,
							   [DateLearningStarted]			DATETIME2        NULL,
							   [CurrentQualificationLevel]      INT              NULL,
							   [DateQualificationLevelAchieved] DATETIME2        NULL,
							   [LastLearningProvidersUKPRN]     VARCHAR (MAX)    NULL,
							   [LastModifiedDate]               DATETIME2        NULL,
							   [LastModifiedTouchpointId]       VARCHAR (MAX)    NULL,
							   [CreatedBy]					    VARCHAR (MAX)    NULL, 
							   CONSTRAINT [PK_dss-learningprogression] PRIMARY KEY ([id]))
							   ON [PRIMARY]
		END


IF OBJECT_ID('[dss-outcomes]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-outcomes]
		
			CREATE TABLE [dbo].[dss-outcomes] (
							   [id] UNIQUEIDENTIFIER NOT NULL,
							   [CustomerId] UNIQUEIDENTIFIER NULL,
							   [ActionPlanId] UNIQUEIDENTIFIER NULL,
							   [SessionId] UNIQUEIDENTIFIER  NULL,
							   [SubcontractorId] VARCHAR(50) NULL,							   
							   [OutcomeType] INT NULL,
							   [OutcomeClaimedDate] datetime2 NULL,
							   [OutcomeEffectiveDate] datetime2 NULL,
							   [ClaimedPriorityGroup] INT NULL,
							   [TouchpointId] VARCHAR (max) NULL,
							   [LastModifiedDate] datetime2 NULL,
							   [LastModifiedTouchpointId] VARCHAR (max) NULL, 
							   CONSTRAINT [PK_dss-outcomes] PRIMARY KEY ([id]))
							   ON [PRIMARY]
		END

IF OBJECT_ID('[dss-sessions]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-sessions]
		
			CREATE TABLE [dbo].[dss-sessions] (
							   [id] UNIQUEIDENTIFIER NOT NULL,
							   [CustomerId] UNIQUEIDENTIFIER NULL,
							   [InteractionId] UNIQUEIDENTIFIER NULL,
							   [SubcontractorId] VARCHAR(50) NULL,
							   [DateandTimeOfSession] datetime2 NULL,
							   [VenuePostCode] VARCHAR (max) NULL,
							   [SessionAttended] BIT NULL,
							   [ReasonForNonAttendance] INT NULL,
							   [LastModifiedDate] datetime2 NULL,
							   [LastModifiedTouchpointId] VARCHAR (max) NULL, 
							   CONSTRAINT [PK_dss-sessions] PRIMARY KEY ([id]))
							   ON [PRIMARY]
		END

IF OBJECT_ID('[dss-subscriptions]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-subscriptions]
		
			CREATE TABLE [dbo].[dss-subscriptions] (
						    [id]					   UNIQUEIDENTIFIER NOT NULL,
							[CustomerId]               UNIQUEIDENTIFIER NULL,
							[TouchPointId]             VARCHAR (MAX)     NULL,
							[Subscribe]                BIT              NULL,
							[LastModifiedDate]         DATETIME2         NULL,
							[LastModifiedTouchpointId] VARCHAR (MAX)     NULL, 
							CONSTRAINT [PK_dss-subscriptions] PRIMARY KEY ([id]))
		END

IF OBJECT_ID('[dss-transfers]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-transfers]
		
			CREATE TABLE [dbo].[dss-transfers] (
							   [id] UNIQUEIDENTIFIER NOT NULL,
							   [CustomerId] UNIQUEIDENTIFIER NULL,
							   [InteractionId] UNIQUEIDENTIFIER NULL,
							   [OriginatingTouchpointId] VARCHAR (max) NULL,
							   [TargetTouchpointId] VARCHAR (max) NULL,
							   [Context] VARCHAR (max) NULL,
							   [DateandTimeOfTransfer] datetime2 NULL,
							   [DateandTimeofTransferAccepted] datetime2 NULL,
							   [RequestedCallbackTime] datetime2 NULL,
							   [ActualCallbackTime] datetime2 NULL,
							   [LastModifiedDate] datetime2 NULL,
							   [LastModifiedTouchpointId] VARCHAR (max) NULL, 
							   CONSTRAINT [PK_dss-transfers] PRIMARY KEY ([id]))
							   ON [PRIMARY]
		END

IF OBJECT_ID('[dss-webchats]', 'U') IS NOT NULL 
		BEGIN
			DROP TABLE [dss-webchats]
		
			CREATE TABLE [dbo].[dss-webchats] (
							   [id] UNIQUEIDENTIFIER NOT NULL,
							   [CustomerId] UNIQUEIDENTIFIER NULL,
							   [InteractionId] UNIQUEIDENTIFIER NULL,
							   [DigitalReference] VARCHAR (max) NULL,
							   [WebChatStartDateandTime] datetime2 NULL,
							   [WebChatEndDateandTime] datetime2 NULL,
							   [WebChatDuration] TIME (7) NULL,
							   [WebChatNarrative] VARCHAR (max) NULL,
							   [SentToCustomer] BIT NULL,
							   [DateandTimeSentToCustomers] datetime2 NULL,
							   [LastModifiedDate] datetime2 NULL,
							   [LastModifiedTouchpointId] VARCHAR (max) NULL, 
							   CONSTRAINT [PK_dss-webchats] PRIMARY KEY ([id]))
							   ON [PRIMARY]
		END