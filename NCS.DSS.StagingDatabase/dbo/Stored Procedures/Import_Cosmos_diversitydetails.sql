CREATE PROCEDURE [dbo].[Import_Cosmos_diversitydetails]

	@JsonFile NVarchar(Max),
	@DataSource NVarchar(max)
AS
BEGIN
	SET CONCAT_NULL_YIELDS_NULL OFF
	SET NOCOUNT ON
	
	DECLARE @ORowSet AS NVarchar(max)
	DECLARE @retvalue NVarchar(max)  
	DECLARE @ParmDef NVarchar(50);
	
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
						 [id] [varchar](50) NULL,
						 [CustomerId] [varchar](50) NULL,
						 [ConsentToCollectLLDDHealth] [varchar](50) NULL,
						 [LearningDifficultyOrDisabilityDeclaration] [varchar](50) NULL,
						 [PrimaryLearningDifficultyOrDisability] [varchar](50) NULL,
						 [SecondaryLearningDifficultyOrDisability] [varchar](50) NULL,
						 [DateAndTimeLLDDHealthConsentCollected] [varchar](50) NULL,
						 [ConsentToCollectEthnicity] [varchar](50) NULL,
						 [Ethnicity] [varchar](50) NULL,
						 [DateAndTimeEthnicityCollected] [varchar](50) NULL,
						 [LastModifiedDate] [varchar](50) NULL,
						 [LastModifiedTouchpointId] [varchar](50) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#diversitydetails]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(50) '$.id', 
			CustomerId VARCHAR(50) '$.CustomerId',
			ConsentToCollectLLDDHealth VARCHAR(50) '$.ConsentToCollectLLDDHealth',
			LearningDifficultyOrDisabilityDeclaration VARCHAR(50) '$.LearningDifficultyOrDisabilityDeclaration',
			PrimaryLearningDifficultyOrDisability VARCHAR(50) '$.PrimaryLearningDifficultyOrDisability',
			SecondaryLearningDifficultyOrDisability VARCHAR(50) '$.SecondaryLearningDifficultyOrDisability',
			DateAndTimeLLDDHealthConsentCollected VARCHAR(50) '$.DateAndTimeLLDDHealthConsentCollected',
			ConsentToCollectEthnicity VARCHAR(50) '$.ConsentToCollectEthnicity',
			Ethnicity VARCHAR(50) '$.Ethnicity',
			DateAndTimeEthnicityCollected VARCHAR(50) '$.DateAndTimeEthnicityCollected',
			LastModifiedDate VARCHAR(50) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(50) '$.LastModifiedTouchpointId'
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
						 [DateAndTimeLLDDHealthConsentCollected] datetime NULL,
						 [ConsentToCollectEthnicity] bit NULL,
						 [Ethnicity] int NULL,
						 [DateAndTimeEthnicityCollected] datetime NULL,
						 [LastModifiedDate] datetime NULL,
						 [LastModifiedTouchpointId] [varchar](10) NULL) 
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
