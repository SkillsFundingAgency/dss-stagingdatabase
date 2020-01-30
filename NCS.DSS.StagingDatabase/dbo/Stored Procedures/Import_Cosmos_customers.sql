CREATE PROCEDURE [dbo].[Import_Cosmos_customers]

	@JsonFile NNVARCHAR(MAX),
	@DataSource NNVARCHAR(MAX)
AS
BEGIN
	SET CONCAT_NULL_YIELDS_NULL OFF
	SET NOCOUNT ON
	
	DECLARE @ORowSet AS NNVARCHAR(MAX)
	DECLARE @retvalue NNVARCHAR(MAX)  
	DECLARE @ParmDef NNVARCHAR(MAX);
	
	SET @ORowSet = '(SELECT @retvalOUT = [BulkColumn] FROM 
					OPENROWSET (BULK ''' + @JsonFile + ''', 
					DATA_SOURCE = ''' + @DataSource + ''', 
					SINGLE_CLOB) 
					as Customers)'
	
	SET @ParmDef = N'@retvalOUT NNVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

    IF OBJECT_ID('#customers', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [#customers]
			TRUNCATE TABLE [#prioritygroups]
		END
	ELSE
		BEGIN
			CREATE TABLE [#customers](
						 [id] [nvarchar](max) NULL,
						 [SubcontractorId] [nvarchar](MAX) NULL,
						 [DateOfRegistration] [nvarchar](MAX) NULL,
						 [Title] [nvarchar](MAX) NULL,
						 [GivenName] [nvarchar](MAX) NULL,
						 [FamilyName] [nvarchar](MAX) NULL,
						 [DateofBirth] [nvarchar](MAX) NULL,
						 [Gender] [nvarchar](MAX) NULL,
						 [UniqueLearnerNumber] [nvarchar](MAX) NULL,
						 [OptInUserResearch] [nvarchar](MAX) NULL,
						 [OptInMarketResearch] [nvarchar](MAX) NULL,
						 [DateOfTermination] [nvarchar](MAX) NULL,
						 [ReasonForTermination] [nvarchar](MAX) NULL,
						 [IntroducedBy] [nvarchar](MAX) NULL,
						 [IntroducedByAdditionalInfo] [nvarchar](MAX) NULL,
						 [LastModifiedDate] [nvarchar](MAX) NULL,
						 [LastModifiedTouchpointId] [nvarchar](MAX) NULL,
						 [CreatedBy] [nvarchar](max) NULL,
						 [PriorityGroups] [NVARCHAR](MAX) NULL
			) ON [PRIMARY]		
			
			CREATE TABLE [#prioritygroups](
				[CustomerId]  [NVARCHAR](MAX) NULL,
				[PriorityCustomer] [NVARCHAR](MAX) NULL
			) ON [PRIMARY]

		END


	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id NVARCHAR(MAX) '$.id', 
			SubcontractorId NVARCHAR(MAX) '$.SubcontractorId',
			DateOfRegistration NVARCHAR(MAX) '$.DateOfRegistration',
			Title NVARCHAR(MAX) '$.Title',
			GivenName NVARCHAR(MAX) '$.GivenName',
			FamilyName NVARCHAR(MAX) '$.FamilyName',
			DateofBirth NVARCHAR(MAX) '$.DateofBirth',
			Gender NVARCHAR(MAX) '$.Gender',
			UniqueLearnerNumber NVARCHAR(MAX) '$.UniqueLearnerNumber',
			OptInMarketResearch NVARCHAR(MAX) '$.OptInMarketResearch',
			OptInUserResearch NVARCHAR(MAX) '$.OptInUserResearch',
			DateOfTermination NVARCHAR(MAX) '$.DateOfTermination',
			ReasonForTermination NVARCHAR(MAX) '$.ReasonForTermination',
			IntroducedBy NVARCHAR(MAX) '$.IntroducedBy',
			IntroducedByAdditionalInfo NVARCHAR(MAX) '$.IntroducedByAdditionalInfo',
			LastModifiedDate NVARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId NVARCHAR(MAX) '$.LastModifiedTouchpointId',
			CreatedBy NVARCHAR(MAX) '$.CreatedBy',
			PriorityGroups NNVARCHAR(MAX) AS JSON
			)			
			AS A
			CROSS APPLY OPENJSON (A.PriorityGroups) WITH (PriorityGroup INT '$') AS B

	INSERT INTO [#customers]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id NVARCHAR(MAX) '$.id', 
			SubcontractorId NVARCHAR(MAX) '$.SubcontractorId',
			DateOfRegistration NVARCHAR(MAX) '$.DateOfRegistration',
			Title NVARCHAR(MAX) '$.Title',
			GivenName NVARCHAR(MAX) '$.GivenName',
			FamilyName NVARCHAR(MAX) '$.FamilyName',
			DateofBirth NVARCHAR(MAX) '$.DateofBirth',
			Gender NVARCHAR(MAX) '$.Gender',
			UniqueLearnerNumber NVARCHAR(MAX) '$.UniqueLearnerNumber',
			OptInMarketResearch NVARCHAR(MAX) '$.OptInMarketResearch',
			OptInUserResearch NVARCHAR(MAX) '$.OptInUserResearch',
			DateOfTermination NVARCHAR(MAX) '$.DateOfTermination',
			ReasonForTermination NVARCHAR(MAX) '$.ReasonForTermination',
			IntroducedBy NVARCHAR(MAX) '$.IntroducedBy',
			IntroducedByAdditionalInfo NVARCHAR(MAX) '$.IntroducedByAdditionalInfo',
			LastModifiedDate NVARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId NVARCHAR(MAX) '$.LastModifiedTouchpointId',
			CreatedBy NVARCHAR(MAX) '$.CreatedBy'
			)			
			AS C

	INSERT INTO [#prioritygroups]
	VALUES (A.id, B.PriorityGroup)

	IF OBJECT_ID('[dss-customers]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-customers]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-customers](
						 [id] UNIQUEIDENTIFIER NOT NULL,
						 [SubcontractorId] VARCHAR(50) NULL,
						 [DateOfRegistration] DATETIME2 NULL,
						 [Title] INT NULL,
						 [GivenName] [varchar](MAX) NULL,
						 [FamilyName] [varchar](MAX) NULL,
						 [DateofBirth] DATETIME2 NULL,
						 [Gender] INT NULL,
						 [UniqueLearnerNumber] [varchar](15) NULL,
						 [OptInMarketResearch] BIT NULL,
						 [OptInUserResearch] BIT NULL,
						 [DateOfTermination] DATETIME2 NULL,
						 [ReasonForTermination] INT NULL,
						 [IntroducedBy] INT NULL,
						 [IntroducedByAdditionalInfo] [varchar](MAX) NULL,
						 [LastModifiedDate] DATETIME2 NULL,
						 [LastModifiedTouchpointId] [varchar](MAX) NULL,
						 [CreatedBy] [varchar](MAX) NULL,
						 CONSTRAINT [PK_dss-customers] PRIMARY KEY ([id])) 
						 ON [PRIMARY]	

			CREATE TABLE [dss-prioritygroups] (
				[CustomerId]                     UNIQUEIDENTIFIER NOT NULL,
				[PriorityGroup]                 INT              NOT NULL,
				PRIMARY KEY ([CustomerId], [PriorityGroup]) 
			)
		END

		INSERT INTO [dss-customers] 
				SELECT
				CONVERT(UNIQUEIDENTIFIER, [id]) AS [id],
				[SubcontractorId],
				CONVERT(datetime2, [DateOfRegistration]) as [DateOfRegistration],
				CONVERT(int, [Title]) as [Title],
				[GivenName],
				[FamilyName],
				CONVERT(datetime2, [DateOfBirth]) as [DateOfBirth],
				CONVERT(int, [Gender]) as [Gender],
				[UniqueLearnerNumber],
				CONVERT(bit, [OptInMarketResearch]) as [OptInMarketResearch],
				CONVERT(bit, [OptInUserResearch]) as [OptInUserResearch],
				CONVERT(datetime2, [DateOfTermination]) as [DateOfTermination],
				CONVERT(int, [ReasonForTermination]) as [ReasonForTermination],
				CONVERT(int, [IntroducedBy]) as [IntroducedBy],
				[IntroducedByAdditionalInfo],
				CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
				[LastModifiedTouchpointId],
				[CreatedBy]
				FROM #customers

		INSERT INTO [dss-prioritygroups] 
				SELECT
				CONVERT(UNIQUEIDENTIFIER, [id]) AS [id],
				CONVERT(int, [PriorityGroup]) as [PriorityGroup]
				FROM #prioritygroups

		DROP TABLE #customers
		DROP TABLE #prioritygroups
END
