CREATE PROCEDURE [dbo].[Import_Cosmos_outcomes]

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
						 [id] [varchar](50) NULL,
						 [CustomerId] [varchar](50) NULL,
						 [ActionPlanId] [varchar](50) NULL,
						 [OutcomeType] [varchar](50) NULL,
						 [OutcomeClaimedDate] [varchar](50) NULL,
						 [OutcomeEffectiveDate] [varchar](50) NULL,
						 [TouchpointId] [varchar](50) NULL,					 
						 [LastModifiedDate] [varchar](50) NULL,
						 [LastModifiedTouchpointId] [varchar](50) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#outcomes]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(50) '$.id', 
			CustomerId VARCHAR(50) '$.CustomerId',
			ActionPlanId VARCHAR(50) '$.ActionPlanId',
			OutcomeType VARCHAR(50) '$.OutcomeType',
			OutcomeClaimedDate VARCHAR(50) '$.OutcomeClaimedDate',
			OutcomeEffectiveDate VARCHAR(50) '$.OutcomeEffectiveDate',
			TouchpointId VARCHAR(50) '$.TouchpointId',
			LastModifiedDate VARCHAR(50) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(50) '$.LastModifiedTouchpointId'
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
						 [TouchpointId] [varchar](10) NULL,					 
						 [LastModifiedDate] datetime NULL,
						 [LastModifiedTouchpointId] [varchar](50) NULL) 
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
