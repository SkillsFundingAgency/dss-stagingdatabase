CREATE PROCEDURE [dbo].[Import_Cosmos_customers]

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
					as Customers)'
	
	SET @ParmDef = N'@retvalOUT NVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

    IF OBJECT_ID('#customers', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [#customers]
		END
	ELSE
		BEGIN
			CREATE TABLE [#customers](
						 [id] [varchar](max) NULL,
						 [DateOfRegistration] [varchar](max) NULL,
						 [Title] [varchar](max) NULL,
						 [GivenName] [varchar](max) NULL,
						 [FamilyName] [varchar](max) NULL,
						 [DateofBirth] [varchar](max) NULL,
						 [Gender] [varchar](max) NULL,
						 [UniqueLearnerNumber] [varchar](max) NULL,
						 [OptInUserResearch] [varchar](max) NULL,
						 [DateOfTermination] [varchar](max) NULL,
						 [ReasonForTermination] [varchar](max) NULL,
						 [IntroducedBy] [varchar](max) NULL,
						 [IntroducedByAdditionalInfo] [varchar](max) NULL,
						 [LastModifiedDate] [varchar](max) NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#customers]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(MAX) '$.id', 
			DateOfRegistration VARCHAR(MAX) '$.DateOfRegistration',
			Title VARCHAR(MAX) '$.Title',
			GivenName VARCHAR(MAX) '$.GivenName',
			FamilyName VARCHAR(MAX) '$.FamilyName',
			DateofBirth VARCHAR(MAX) '$.DateofBirth',
			Gender VARCHAR(MAX) '$.Gender',
			UniqueLearnerNumber VARCHAR(MAX) '$.UniqueLearnerNumber',
			OptInUserResearch VARCHAR(MAX) '$.OptInUserResearch',
			DateOfTermination VARCHAR(MAX) '$.DateOfTermination',
			ReasonForTermination VARCHAR(MAX) '$.ReasonForTermination',
			IntroducedBy VARCHAR(MAX) '$.IntroducedBy',
			IntroducedByAdditionalInfo VARCHAR(MAX) '$.IntroducedByAdditionalInfo',
			LastModifiedDate VARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(MAX) '$.LastModifiedTouchpointId'
			) as Coll

	IF OBJECT_ID('[dss-customers]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-customers]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-customers](
						 [id] uniqueidentifier NULL,
						 [DateOfRegistration] datetime NULL,
						 [Title] int NULL,
						 [GivenName] [varchar](max) NULL,
						 [FamilyName] [varchar](max) NULL,
						 [DateofBirth] datetime NULL,
						 [Gender] int NULL,
						 [UniqueLearnerNumber] [varchar](15) NULL,
						 [OptInUserResearch] bit NULL,
						 [DateOfTermination] datetime NULL,
						 [ReasonForTermination] int NULL,
						 [IntroducedBy] int NULL,
						 [IntroducedByAdditionalInfo] [varchar](max) NULL,
						 [LastModifiedDate] date NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL) 
						 ON [PRIMARY]	
		END

		INSERT INTO [dss-customers] 
				SELECT
				CONVERT(uniqueidentifier, [id]) as [id],
				CONVERT(datetime2, [DateOfRegistration]) as [DateOfRegistration],
				CONVERT(int, [Title]) as [Title],
				[GivenName],
				[FamilyName],
				CONVERT(datetime2, [DateOfBirth]) as [DateOfBirth],
				CONVERT(int, [Gender]) as [Gender],
				[UniqueLearnerNumber],
				CONVERT(bit, [OptInUserResearch]) as [OptInUserResearch],
				CONVERT(datetime2, [DateOfTermination]) as [DateOfTermination],
				CONVERT(int, [ReasonForTermination]) as [ReasonForTermination],
				CONVERT(int, [IntroducedBy]) as [IntroducedBy],
				[IntroducedByAdditionalInfo],
				CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
				[LastModifiedTouchpointId]
				FROM #customers

		DROP TABLE #customers

END
