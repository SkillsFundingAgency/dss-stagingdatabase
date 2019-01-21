CREATE PROCEDURE [dbo].[Import_Cosmos_addresses]

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
					as Addresses)'
	
	SET @ParmDef = N'@retvalOUT NVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

    IF OBJECT_ID('#addresses', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE #addresses
		END
	ELSE
		BEGIN
			CREATE TABLE [#addresses](
						 [id] [varchar](50) NULL,
						 [CustomerId] [varchar](50) NULL,
						 [Address1] [varchar](50) NULL,
						 [Address2] [varchar](50) NULL,
						 [Address3] [varchar](50) NULL,
						 [Address4] [varchar](50) NULL,
						 [Address5] [varchar](50) NULL,
						 [PostCode] [varchar](50) NULL,
						 [AlternativePostCode] [varchar](50) NULL,
						 [Longitude] [varchar](50) NULL,
						 [Latitude] [varchar](50) NULL,
						 [EffectiveFrom] [varchar](50) NULL,
						 [EffectiveTo] [varchar](50) NULL,
						 [LastModifiedDate] [varchar](50) NULL,
						 [LastModifiedTouchpointId] [varchar](50) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#addresses]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(50) '$.id', 
			CustomerId VARCHAR(50) '$.CustomerId',
			Address1 VARCHAR(50) '$.Address1',
			Address2 VARCHAR(50) '$.Address2',
			Address3 VARCHAR(50) '$.Address3',
			Address4 VARCHAR(50) '$.Address4',
			Address5 VARCHAR(50) '$.Address5',
			PostCode VARCHAR(50) '$.PostCode',
			AlternativePostCode VARCHAR(50) '$.AlternativePostCode',
			Longitude VARCHAR(50) '$.Longitude',
			Latitude VARCHAR(50) '$.Latitude',
			EffectiveFrom VARCHAR(50) '$.EffectiveFrom',
			EffectiveTo VARCHAR(50) '$.EffectiveTo',
			LastModifiedDate VARCHAR(50) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(50) '$.LastModifiedTouchpointId'
			) as Coll




	IF OBJECT_ID('[dss-addresses]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-addresses]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-addresses](
						 [id] uniqueidentifier NULL,
						 [CustomerId] uniqueidentifier NULL,
						 [Address1] [varchar](50) NULL,
						 [Address2] [varchar](50) NULL,
						 [Address3] [varchar](50) NULL,
						 [Address4] [varchar](50) NULL,
						 [Address5] [varchar](50) NULL,
						 [PostCode] [varchar](50) NULL,
						 [AlternativePostCode] [varchar](20) NULL,
						 [Longitude] float NULL,
						 [Latitude] float NULL,
						 [EffectiveFrom] datetime NULL,
						 [EffectiveTo] datetime NULL,
						 [LastModifiedDate] datetime NULL,
						 [LastModifiedTouchpointId] [varchar](10)) 
						 ON [PRIMARY]							
		END

		INSERT INTO [dss-addresses] 
				SELECT
				CONVERT(uniqueidentifier, [id]) as [id],
				CONVERT(uniqueidentifier, [CustomerId]) as [CustomerId],
				[Address1],
				[Address2],
				[Address3],
				[Address4],
				[Address5], 
				[PostCode],
				[AlternativePostCode],
				CONVERT(float, [Longitude]) as [Longitude],
				CONVERT(float, [Latitude]) as [Latitude],
				CONVERT(datetime2, [EffectiveFrom]) as [EffectiveFrom],
				CONVERT(datetime2, [EffectiveTo]) as [EffectiveTo],
				CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
				[LastModifiedTouchpointId]
				FROM #addresses

		DROP TABLE #addresses

END
