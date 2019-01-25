CREATE PROCEDURE [dbo].[Import_Cosmos_outcomes]

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
					as Outcomes)'
	
	SET @ParmDef = N'@retvalOUT NVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

    IF OBJECT_ID('#outcomes', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE #outcomes
		END
	ELSE
		BEGIN
			CREATE TABLE [#outcomes](
						 [id] [varchar](max) NULL,
						 [CustomerId] [varchar](max) NULL,
						 [ActionPlanId] [varchar](max) NULL,
						 [OutcomeType] [varchar](max) NULL,
						 [OutcomeClaimedDate] [varchar](max) NULL,
						 [OutcomeEffectiveDate] [varchar](max) NULL,
						 [TouchpointId] [varchar](max) NULL,					 
						 [LastModifiedDate] [varchar](max) NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#outcomes]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(MAX) '$.id', 
			CustomerId VARCHAR(MAX) '$.CustomerId',
			ActionPlanId VARCHAR(MAX) '$.ActionPlanId',
			OutcomeType VARCHAR(MAX) '$.OutcomeType',
			OutcomeClaimedDate VARCHAR(MAX) '$.OutcomeClaimedDate',
			OutcomeEffectiveDate VARCHAR(MAX) '$.OutcomeEffectiveDate',
			TouchpointId VARCHAR(MAX) '$.TouchpointId',
			LastModifiedDate VARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(MAX) '$.LastModifiedTouchpointId'
			) as Coll



	IF OBJECT_ID('[dss-outcomes]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-outcomes]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-outcomes](
						 [id] uniqueidentifier NULL,
						 [CustomerId] uniqueidentifier NULL,
						 [ActionPlanId] uniqueidentifier NULL,
						 [OutcomeType] int NULL,
						 [OutcomeClaimedDate] datetime NULL,
						 [OutcomeEffectiveDate] datetime NULL,
						 [TouchpointId] [varchar](max) NULL,					 
						 [LastModifiedDate] datetime NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL) 
						 ON [PRIMARY]
		END

		INSERT INTO [dss-outcomes] 
					SELECT
					CONVERT(uniqueidentifier, [id]) as [id],
					CONVERT(uniqueidentifier, [CustomerId]) as [CustomerId],
					CONVERT(uniqueidentifier, [ActionPlanId]) as [ActionPlanId],
					CONVERT(int, [OutcomeType]) as [OutcomeType],
					CONVERT(datetime2, [OutcomeClaimedDate]) as [OutcomeClaimedDate],
					CONVERT(datetime2, [OutcomeEffectiveDate]) as [OutcomeEffectiveDate],
					[TouchpointId],
					CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
					[LastModifiedTouchpointId]
					FROM #outcomes 

		DROP TABLE #outcomes

END
