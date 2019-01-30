CREATE PROCEDURE [dbo].[Import_Cosmos_adviserdetails]

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
					as Adviserdetails)'
	
	SET @ParmDef = N'@retvalOUT NVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

    IF OBJECT_ID('#adviserdetails', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE #adviserdetails
		END
	ELSE
		BEGIN
			CREATE TABLE [#adviserdetails](
						 [id] [varchar](max) NULL,
						 [AdviserName] [varchar](max) NULL,
						 [AdviserEmailAddress] [varchar](max) NULL,
						 [AdviserContactNumber] [varchar](max) NULL,
						 [LastModifiedDate] [varchar](max) NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#adviserdetails]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(MAX) '$.id', 
			AdviserName VARCHAR(MAX) '$.AdviserName',
			AdviserEmailAddress VARCHAR(MAX) '$.AdviserEmailAddress',
			AdviserContactNumber VARCHAR(MAX) '$.AdviserContactNumber',
			LastModifiedDate VARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(MAX) '$.LastModifiedTouchpointId'
			) as Coll

	
	IF OBJECT_ID('[dss-adviserdetails]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-adviserdetails]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-adviserdetails](
						 [id] uniqueidentifier NULL,
						 [AdviserName] [varchar](max) NULL,
						 [AdviserEmailAddress] [varchar](max) NULL,
						 [AdviserContactNumber] [varchar](max) NULL,
						 [LastModifiedDate] datetime2 NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL) 
						 ON [PRIMARY]
		END

		INSERT INTO [dss-adviserdetails] 
				SELECT
				CONVERT(uniqueidentifier, [id]) as [id],
				[AdviserName],
				[AdviserEmailAddress],
				[AdviserContactNumber],
				CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
				[LastModifiedTouchpointId]
				FROM #adviserdetails
		
		DROP TABLE #adviserdetails

END
