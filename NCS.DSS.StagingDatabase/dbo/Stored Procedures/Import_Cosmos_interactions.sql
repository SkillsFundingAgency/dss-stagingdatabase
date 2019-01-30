CREATE PROCEDURE [dbo].[Import_Cosmos_interactions]

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
						 [id] [varchar](max) NULL,
						 [CustomerId] [varchar](max) NULL,
						 [TouchpointId] [varchar](max) NULL,
						 [AdviserDetailsId] [varchar](max) NULL,
						 [DateandTimeOfInteraction] [varchar](max) NULL,
						 [Channel] [varchar](max) NULL,
						 [InteractionType] [varchar](max) NULL,					 
						 [LastModifiedDate] [varchar](max) NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#interactions]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(MAX) '$.id', 
			CustomerId VARCHAR(MAX) '$.CustomerId',
			TouchpointId VARCHAR(MAX) '$.TouchpointId',
			AdviserDetailsId VARCHAR(MAX) '$.AdviserDetailsId',
			DateandTimeOfInteraction VARCHAR(MAX) '$.DateandTimeOfInteraction',
			Channel VARCHAR(MAX) '$.Channel',
			InteractionType VARCHAR(MAX) '$.InteractionType',
			LastModifiedDate VARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(MAX) '$.LastModifiedTouchpointId'
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
						 [TouchpointId] [varchar](max) NULL,
						 [AdviserDetailsId] uniqueidentifier NULL,
						 [DateandTimeOfInteraction] datetime2 NULL,
						 [Channel] int NULL,
						 [InteractionType] int NULL,					 
						 [LastModifiedDate] datetime2 NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL) 
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
