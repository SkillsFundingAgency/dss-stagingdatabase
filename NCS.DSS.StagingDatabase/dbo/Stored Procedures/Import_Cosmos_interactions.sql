CREATE PROCEDURE [dbo].[Import_Cosmos_interactions]

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
					as Interactions)'
	
	SET @ParmDef = N'@retvalOUT NVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

    IF OBJECT_ID('#interactions', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE #interactions
		END
	ELSE
		BEGIN
			CREATE TABLE [#interactions](
						 [id] [varchar](50) NULL,
						 [CustomerId] [varchar](50) NULL,
						 [TouchpointId] [varchar](50) NULL,
						 [AdviserDetailsId] [varchar](50) NULL,
						 [DateandTimeOfInteraction] [varchar](50) NULL,
						 [Channel] [varchar](50) NULL,
						 [InteractionType] [varchar](50) NULL,					 
						 [LastModifiedDate] [varchar](50) NULL,
						 [LastModifiedTouchpointId] [varchar](50) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#interactions]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(50) '$.id', 
			CustomerId VARCHAR(50) '$.CustomerId',
			TouchpointId VARCHAR(50) '$.TouchpointId',
			AdviserDetailsId VARCHAR(50) '$.AdviserDetailsId',
			DateandTimeOfInteraction VARCHAR(50) '$.DateandTimeOfInteraction',
			Channel VARCHAR(50) '$.Channel',
			InteractionType VARCHAR(50) '$.InteractionType',
			LastModifiedDate VARCHAR(50) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(50) '$.LastModifiedTouchpointId'
			) as Coll


	IF OBJECT_ID('[dss-interactions]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-interactions]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-interactions](
						 [id] uniqueidentifier NULL,
						 [CustomerId] uniqueidentifier NULL,
						 [TouchpointId] [varchar](10) NULL,
						 [AdviserDetailsId] uniqueidentifier NULL,
						 [DateandTimeOfInteraction] datetime NULL,
						 [Channel] int NULL,
						 [InteractionType] int NULL,					 
						 [LastModifiedDate] datetime NULL,
						 [LastModifiedTouchpointId] [varchar](10) NULL) 
						 ON [PRIMARY]	
		END

		INSERT INTO [dss-interactions] 
				SELECT
				CONVERT(uniqueidentifier, [id]) as [id],
				CONVERT(uniqueidentifier, [CustomerId]) as [CustomerId],
				[TouchpointId],
				CONVERT(uniqueidentifier, [AdviserDetailsId]) as [AdviserDetailsId],
				CONVERT(datetime2, [DateandTimeOfInteraction]) as [DateandTimeOfInteraction],
				CONVERT(int, [Channel]) as [Channel],
				CONVERT(int, [InteractionType]) as [InteractionType],
				CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
				[LastModifiedTouchpointId]
				FROM #interactions

		DROP TABLE #interactions
END
