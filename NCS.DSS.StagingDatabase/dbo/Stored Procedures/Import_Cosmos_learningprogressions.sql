CREATE PROCEDURE [dbo].[Import_Cosmos_learningprogressions]

	@JsonFile NVarchar(Max),
	@DataSource NVarchar(max)
AS
BEGIN
	SET CONCAT_NULL_YIELDS_NULL OFF
	SET NOCOUNT ON
	
	DECLARE @ORowSet AS NVarchar(max)
	DECLARE @retvalue NVarchar(max)  
	DECLARE @ParmDef NVARCHAR(MAX);
	
	SET @ORowSet = '(SELECT @retvalOUT = [BulkColumn] FROM 
					OPENROWSET (BULK ''' + @JsonFile + ''', 
					DATA_SOURCE = ''' + @DataSource + ''', 
					SINGLE_CLOB) 
					as LearningProgressions)'
	
	SET @ParmDef = N'@retvalOUT NVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

	CREATE TABLE [#learningprogression](
				[id] [varchar](max) NULL,
				[CustomerId] [varchar](max) NULL,
				[DateProgressionRecorded] [varchar](max) NULL,
				[CurrentLearningStatus] [VARCHAR](MAX) NULL,
				[LearningHours] [varchar](max) NULL,
				[DateLearningStarted] [varchar](max) NULL,
				[CurrentQualificationLevel] [varchar](max) NULL,
				[DateQualificationLevelAchieved] [varchar](max) NULL,
				[LastLearningProvidersUKPRN] [varchar](max) NULL,
				[LastModifiedDate] [varchar](max) NULL,
				[LastModifiedTouchpointId] [varchar](max) NULL,
				[CreatedBy] [varchar](max) NULL
			) ON [PRIMARY]									


	INSERT INTO [#learningprogression]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(MAX) '$.id', 
			CustomerId VARCHAR(MAX) '$.CustomerId',
			DateProgressionRecorded VARCHAR(MAX) '$.DateProgressionRecorded',
			CurrentLearningStatus VARCHAR(MAX) '$.CurrentLearningStatus',
			LearningHours VARCHAR(MAX) '$.LearningHours',
			DateLearningStarted VARCHAR(MAX) '$.DateLearningStarted',
			CurrentQualificationLevel VARCHAR(MAX) '$.CurrentQualificationLevel',
			DateQualificationLevelAchieved VARCHAR(MAX) '$.DateQualificationLevelAchieved',
			LastLearningProvidersUKPRN VARCHAR(MAX) '$.LastLearningProvidersUKPRN',
			LastModifiedDate VARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(MAX) '$.LastModifiedTouchpointId',
			CreatedBy VARCHAR(MAX) '$.CreatedBy'
			) as Coll

	
	IF OBJECT_ID('[dss-learningprogression]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-learningprogression]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-learningprogression](
						 [id]                             UNIQUEIDENTIFIER NOT NULL,
						 [CustomerId]                     UNIQUEIDENTIFIER NULL,
						 [DateProgressionRecorded]        DATETIME2        NULL,
						 [CurrentLearningStatus]		  INT              NULL,
						 [LearningHours]				  INT			   NULL,
						 [DateLearningStarted]			  DATETIME2        NULL,
						 [CurrentQualificationLevel]      INT              NULL,
						 [DateQualificationLevelAchieved] DATETIME2        NULL,
						 [LastLearningProvidersUKPRN]     VARCHAR (MAX)    NULL,
						 [LastModifiedDate]               DATETIME2        NULL,
						 [LastModifiedTouchpointId]       VARCHAR (MAX)    NULL,
						 [CreatedBy]					  VARCHAR (MAX)    NULL, 
						CONSTRAINT [PK_dss-learningprogression] PRIMARY KEY ([id])) 
			ON [PRIMARY]
		END

		INSERT INTO [dss-learningprogression] 
			SELECT  
			CONVERT(UNIQUEIDENTIFIER, [id]) AS [id],
			CONVERT(UNIQUEIDENTIFIER, [CustomerId]) AS [CustomerId],
			CONVERT(datetime2, [DateProgressionRecorded]) as [DateProgressionRecorded],
			CONVERT(int, [CurrentLearningStatus]) as [CurrentLearningStatus],
			CONVERT(int, [LearningHours]) as [LearningHours],
			CONVERT(datetime2, [DateLearningStarted]) as [DateLearningStarted],
			CONVERT(int, [CurrentQualificationLevel]) as [CurrentQualificationLevel],
			CONVERT(datetime2, [DateQualificationLevelAchieved]) as [DateQualificationLevelAchieved],
			[LastLearningProvidersUKPRN],
			CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
			[LastModifiedTouchpointId],
			[CreatedBy]
			FROM #learningprogression

		DROP TABLE #learningprogression
		
END