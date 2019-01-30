CREATE PROCEDURE [dbo].[Import_Cosmos_diversitydetails]

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
					as DiversityDetails)'
	
	SET @ParmDef = N'@retvalOUT NVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

    IF OBJECT_ID('#diversitydetails', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE #diversitydetails
		END
	ELSE
		BEGIN
			CREATE TABLE [#diversitydetails](
						 [id] [varchar](max) NULL,
						 [CustomerId] [varchar](max) NULL,
						 [ConsentToCollectLLDDHealth] [varchar](max) NULL,
						 [LearningDifficultyOrDisabilityDeclaration] [varchar](max) NULL,
						 [PrimaryLearningDifficultyOrDisability] [varchar](max) NULL,
						 [SecondaryLearningDifficultyOrDisability] [varchar](max) NULL,
						 [DateAndTimeLLDDHealthConsentCollected] [varchar](max) NULL,
						 [ConsentToCollectEthnicity] [varchar](max) NULL,
						 [Ethnicity] [varchar](max) NULL,
						 [DateAndTimeEthnicityCollected] [varchar](max) NULL,
						 [LastModifiedDate] [varchar](max) NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#diversitydetails]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(MAX) '$.id', 
			CustomerId VARCHAR(MAX) '$.CustomerId',
			ConsentToCollectLLDDHealth VARCHAR(MAX) '$.ConsentToCollectLLDDHealth',
			LearningDifficultyOrDisabilityDeclaration VARCHAR(MAX) '$.LearningDifficultyOrDisabilityDeclaration',
			PrimaryLearningDifficultyOrDisability VARCHAR(MAX) '$.PrimaryLearningDifficultyOrDisability',
			SecondaryLearningDifficultyOrDisability VARCHAR(MAX) '$.SecondaryLearningDifficultyOrDisability',
			DateAndTimeLLDDHealthConsentCollected VARCHAR(MAX) '$.DateAndTimeLLDDHealthConsentCollected',
			ConsentToCollectEthnicity VARCHAR(MAX) '$.ConsentToCollectEthnicity',
			Ethnicity VARCHAR(MAX) '$.Ethnicity',
			DateAndTimeEthnicityCollected VARCHAR(MAX) '$.DateAndTimeEthnicityCollected',
			LastModifiedDate VARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(MAX) '$.LastModifiedTouchpointId'
			) as Coll


	IF OBJECT_ID('[dss-diversitydetails]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-diversitydetails]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-diversitydetails](
						 [id] uniqueidentifier NULL,
						 [CustomerId] uniqueidentifier NULL,
						 [ConsentToCollectLLDDHealth] bit NULL,
						 [LearningDifficultyOrDisabilityDeclaration] int NULL,
						 [PrimaryLearningDifficultyOrDisability] int NULL,
						 [SecondaryLearningDifficultyOrDisability] int NULL,
						 [DateAndTimeLLDDHealthConsentCollected] datetime2 NULL,
						 [ConsentToCollectEthnicity] bit NULL,
						 [Ethnicity] int NULL,
						 [DateAndTimeEthnicityCollected] datetime2 NULL,
						 [LastModifiedDate] datetime2 NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL) 
						 ON [PRIMARY]
		END

		INSERT INTO [dss-diversitydetails] 
				SELECT
				CONVERT(uniqueidentifier, [id]) as [id],
				CONVERT(uniqueidentifier, [CustomerId]) as [CustomerId],
				CONVERT(bit, [ConsentToCollectLLDDHealth]) as [ConsentToCollectLLDDHealth],
				CONVERT(int, [LearningDifficultyOrDisabilityDeclaration]) as [LearningDifficultyOrDisabilityDeclaration],
				CONVERT(int, [PrimaryLearningDifficultyOrDisability]) as [PrimaryLearningDifficultyOrDisability],
				CONVERT(int, [SecondaryLearningDifficultyOrDisability]) as [SecondaryLearningDifficultyOrDisability],
				CONVERT(datetime2, [DateAndTimeLLDDHealthConsentCollected]) as [DateAndTimeLLDDHealthConsentCollected],
				CONVERT(bit, [ConsentToCollectEthnicity]) as [ConsentToCollectEthnicity],
				CONVERT(int, [Ethnicity]) as [Ethnicity],
				CONVERT(datetime2, [DateAndTimeEthnicityCollected]) as [DateAndTimeEthnicityCollected],
				CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
				[LastModifiedTouchpointId]
				FROM #diversitydetails

		DROP TABLE #diversitydetails
END
