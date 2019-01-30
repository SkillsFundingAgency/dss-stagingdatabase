CREATE PROCEDURE [dbo].[Import_Cosmos_addresses]

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
						 [id] [varchar](max) NULL,
						 [CustomerId] [varchar](max) NULL,
						 [Address1] [varchar](max) NULL,
						 [Address2] [varchar](max) NULL,
						 [Address3] [varchar](max) NULL,
						 [Address4] [varchar](max) NULL,
						 [Address5] [varchar](max) NULL,
						 [PostCode] [varchar](max) NULL,
						 [AlternativePostCode] [varchar](max) NULL,
						 [Longitude] [varchar](max) NULL,
						 [Latitude] [varchar](max) NULL,
						 [EffectiveFrom] [varchar](max) NULL,
						 [EffectiveTo] [varchar](max) NULL,
						 [LastModifiedDate] [varchar](max) NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#addresses]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(MAX) '$.id', 
			CustomerId VARCHAR(MAX) '$.CustomerId',
			Address1 VARCHAR(MAX) '$.Address1',
			Address2 VARCHAR(MAX) '$.Address2',
			Address3 VARCHAR(MAX) '$.Address3',
			Address4 VARCHAR(MAX) '$.Address4',
			Address5 VARCHAR(MAX) '$.Address5',
			PostCode VARCHAR(MAX) '$.PostCode',
			AlternativePostCode VARCHAR(MAX) '$.AlternativePostCode',
			Longitude VARCHAR(MAX) '$.Longitude',
			Latitude VARCHAR(MAX) '$.Latitude',
			EffectiveFrom VARCHAR(MAX) '$.EffectiveFrom',
			EffectiveTo VARCHAR(MAX) '$.EffectiveTo',
			LastModifiedDate VARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(MAX) '$.LastModifiedTouchpointId'
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
						 [Address1] [varchar](max) NULL,
						 [Address2] [varchar](max) NULL,
						 [Address3] [varchar](max) NULL,
						 [Address4] [varchar](max) NULL,
						 [Address5] [varchar](max) NULL,
						 [PostCode] [varchar](max) NULL,
						 [AlternativePostCode] [varchar](20) NULL,
						 [Longitude] float NULL,
						 [Latitude] float NULL,
						 [EffectiveFrom] datetime2 NULL,
						 [EffectiveTo] datetime2 NULL,
						 [LastModifiedDate] datetime2 NULL,
						 [LastModifiedTouchpointId] [varchar](max)) 
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
