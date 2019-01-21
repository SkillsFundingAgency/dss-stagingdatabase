CREATE PROCEDURE [dbo].[Import_Cosmos_customers]

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
						 [id] [varchar](50) NULL,
						 [DateOfRegistration] [varchar](50) NULL,
						 [Title] [varchar](50) NULL,
						 [GivenName] [varchar](50) NULL,
						 [FamilyName] [varchar](50) NULL,
						 [DateofBirth] [varchar](50) NULL,
						 [Gender] [varchar](50) NULL,
						 [UniqueLearnerNumber] [varchar](50) NULL,
						 [OptInUserResearch] [varchar](50) NULL,
						 [DateOfTermination] [varchar](50) NULL,
						 [ReasonForTermination] [varchar](50) NULL,
						 [IntroducedBy] [varchar](50) NULL,
						 [IntroducedByAdditionalInfo] [varchar](50) NULL,
						 [LastModifiedDate] [varchar](50) NULL,
						 [LastModifiedTouchpointId] [varchar](50) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#customers]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(50) '$.id', 
			DateOfRegistration VARCHAR(50) '$.DateOfRegistration',
			Title VARCHAR(50) '$.Title',
			GivenName VARCHAR(50) '$.GivenName',
			FamilyName VARCHAR(50) '$.FamilyName',
			DateofBirth VARCHAR(50) '$.DateofBirth',
			Gender VARCHAR(50) '$.Gender',
			UniqueLearnerNumber VARCHAR(50) '$.UniqueLearnerNumber',
			OptInUserResearch VARCHAR(50) '$.OptInUserResearch',
			DateOfTermination VARCHAR(50) '$.DateOfTermination',
			ReasonForTermination VARCHAR(50) '$.ReasonForTermination',
			IntroducedBy VARCHAR(50) '$.IntroducedBy',
			IntroducedByAdditionalInfo VARCHAR(50) '$.IntroducedByAdditionalInfo',
			LastModifiedDate VARCHAR(50) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(50) '$.LastModifiedTouchpointId'
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
						 [GivenName] [varchar](50) NULL,
						 [FamilyName] [varchar](50) NULL,
						 [DateofBirth] datetime NULL,
						 [Gender] int NULL,
						 [UniqueLearnerNumber] [varchar](15) NULL,
						 [OptInUserResearch] bit NULL,
						 [DateOfTermination] datetime NULL,
						 [ReasonForTermination] int NULL,
						 [IntroducedBy] int NULL,
						 [IntroducedByAdditionalInfo] [varchar](50) NULL,
						 [LastModifiedDate] date NULL,
						 [LastModifiedTouchpointId] [varchar](10) NULL) 
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
