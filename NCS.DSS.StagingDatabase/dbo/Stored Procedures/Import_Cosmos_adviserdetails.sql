CREATE PROCEDURE [dbo].[Import_Cosmos_adviserdetails]

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
						 [id] [varchar](50) NULL,
						 [AdviserName] [varchar](50) NULL,
						 [AdviserEmailAddress] [varchar](50) NULL,
						 [AdviserContactNumber] [varchar](50) NULL,
						 [LastModifiedDate] [varchar](50) NULL,
						 [LastModifiedTouchpointId] [varchar](50) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#adviserdetails]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(50) '$.id', 
			AdviserName VARCHAR(50) '$.AdviserName',
			AdviserEmailAddress VARCHAR(50) '$.AdviserEmailAddress',
			AdviserContactNumber VARCHAR(50) '$.AdviserContactNumber',
			LastModifiedDate VARCHAR(50) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(50) '$.LastModifiedTouchpointId'
			) as Coll

	
	IF OBJECT_ID('[dss-adviserdetails]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-adviserdetails]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-adviserdetails](
						 [id] uniqueidentifier NULL,
						 [AdviserName] [varchar](50) NULL,
						 [AdviserEmailAddress] [varchar](50) NULL,
						 [AdviserContactNumber] [varchar](50) NULL,
						 [LastModifiedDate] datetime NULL,
						 [LastModifiedTouchpointId] [varchar](10) NULL) 
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
