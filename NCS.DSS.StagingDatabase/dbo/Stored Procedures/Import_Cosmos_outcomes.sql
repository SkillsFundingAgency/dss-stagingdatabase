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
						 [SessionId] [VARCHAR](MAX) NULL,
						 [SubcontractorId] [VARCHAR](MAX) NULL,						 
						 [OutcomeType] [VARCHAR](MAX) NULL,
						 [OutcomeClaimedDate] [VARCHAR](MAX) NULL,
						 [OutcomeEffectiveDate] [VARCHAR](MAX) NULL,
						 [ClaimedPriorityGroup] [VARCHAR](MAX) NULL,
						 [IsPriorityCustomer] [VARCHAR](MAX) NULL,
						 [TouchpointId] [VARCHAR](MAX) NULL,					 
						 [LastModifiedDate] [VARCHAR](MAX) NULL,
						 [LastModifiedTouchpointId] [VARCHAR](MAX) NULL,
						 [CreatedBy] [VARCHAR](MAX) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#outcomes]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(MAX) '$.id', 
			CustomerId VARCHAR(MAX) '$.CustomerId',
			ActionPlanId VARCHAR(MAX) '$.ActionPlanId',		
			SessionId VARCHAR(MAX) '$.SessionId',
			SubcontractorId VARCHAR(MAX) '$.SubcontractorId',			
			OutcomeType VARCHAR(MAX) '$.OutcomeType',
			OutcomeClaimedDate VARCHAR(MAX) '$.OutcomeClaimedDate',
			OutcomeEffectiveDate VARCHAR(MAX) '$.OutcomeEffectiveDate',
			ClaimedPriorityGroup VARCHAR(MAX) '$.ClaimedPriorityGroup',
			IsPriorityCustomer VARCHAR(MAX) '$.IsPriorityCustomer',
			TouchpointId VARCHAR(MAX) '$.TouchpointId',
			LastModifiedDate VARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(MAX) '$.LastModifiedTouchpointId',
			CreatedBy VARCHAR(MAX) '$.CreatedBy'
			) AS Coll


	IF OBJECT_ID('[dss-outcomes]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-outcomes]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-outcomes](
						 [id] UNIQUEIDENTIFIER NOT NULL,
						 [CustomerId] UNIQUEIDENTIFIER NULL,
						 [ActionPlanId] UNIQUEIDENTIFIER NULL,
						 [SessionId] UNIQUEIDENTIFIER NULL,
						 [SubcontractorId] VARCHAR(50) NULL,						 
						 [OutcomeType] INT NULL,
						 [OutcomeClaimedDate] DATETIME2 NULL,
						 [OutcomeEffectiveDate] DATETIME2 NULL,
						 [ClaimedPriorityGroup] int NULL,
						 [IsPriorityCustomer] bit null,
						 [TouchpointId] [VARCHAR](MAX) NULL,					 
						 [LastModifiedDate] DATETIME2 NULL,
						 [LastModifiedTouchpointId] [VARCHAR](MAX) NULL,
						 [CreatedBy] [VARCHAR](MAX) NULL,
						 CONSTRAINT [PK_dss-outcomes] PRIMARY KEY ([id])) 
						 ON [PRIMARY]
		END
        
		INSERT INTO [dss-outcomes] 
					SELECT
					CONVERT(UNIQUEIDENTIFIER, [id]) AS [id],
					CONVERT(UNIQUEIDENTIFIER, [CustomerId]) AS [CustomerId],
					CONVERT(UNIQUEIDENTIFIER, [ActionPlanId]) AS [ActionPlanId],					
					CONVERT(UNIQUEIDENTIFIER, [SessionId]) AS [SessionId],
					[SubcontractorId],					
					CONVERT(int, [OutcomeType]) as [OutcomeType],
					CONVERT(datetime2, [OutcomeClaimedDate], 105) as [OutcomeClaimedDate],
					CONVERT(datetime2, [OutcomeEffectiveDate], 105) as [OutcomeEffectiveDate],
					CONVERT(int, [ClaimedPriorityGroup]) as [ClaimedPriorityGroup],
					CONVERT(bit, [IsPriorityCustomer]) as [IsPriorityCustomer],
					[TouchpointId],					
					CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
					[LastModifiedTouchpointId],
					[CreatedBy]
					FROM #outcomes 

		DROP TABLE #outcomes

END
