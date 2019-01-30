CREATE PROCEDURE [dbo].[Import_Cosmos_actionplans]

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
					as ActionPlans)'
	
	SET @ParmDef = N'@retvalOUT NVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

	CREATE TABLE [#actionplans](
				[id] [varchar](max) NULL,
				[CustomerId] [varchar](max) NULL,
				[InteractionId] [varchar](max) NULL,
				[DateActionPlanCreated] [varchar](max) NULL,
				[CustomerCharterShownToCustomer] [varchar](max) NULL,
				[DateAndTimeCharterShown] [varchar](max) NULL,
				[DateActionPlanSentToCustomer] [varchar](max) NULL,
				[ActionPlanDeliveryMethod] [varchar](max) NULL,
				[DateActionPlanAcknowledged] [varchar](max) NULL,
				[PriorityCustomer] [varchar](max) NULL,
				[CurrentSituation] [varchar](max) NULL,
				[LastModifiedDate] [varchar](max) NULL,
				[LastModifiedTouchpointId] [varchar](max) NULL
			) ON [PRIMARY]									


	INSERT INTO [#actionplans]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(MAX) '$.id', 
			CustomerId VARCHAR(MAX) '$.CustomerId',
			InteractionId VARCHAR(MAX) '$.InteractionId',
			DateActionPlanCreated VARCHAR(MAX) '$.DateActionPlanCreated',
			CustomerCharterShownToCustomer VARCHAR(MAX) '$.CustomerCharterShownToCustomer',
			DateAndTimeCharterShown VARCHAR(MAX) '$.DateAndTimeCharterShown',
			DateActionPlanSentToCustomer VARCHAR(MAX) '$.DateActionPlanSentToCustomer',
			ActionPlanDeliveryMethod VARCHAR(MAX) '$.ActionPlanDeliveryMethod',
			DateActionPlanAcknowledged VARCHAR(MAX) '$.DateActionPlanAcknowledged',
			PriorityCustomer VARCHAR(MAX) '$.PriorityCustomer',
			CurrentSituation VARCHAR(MAX) '$.CurrentSituation',
			LastModifiedDate VARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(MAX) '$.LastModifiedTouchpointId'
			) as Coll

	
	IF OBJECT_ID('[dss-actionplans]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-actionplans]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-actionplans](
						[id] uniqueidentifier NULL,
						[CustomerId] uniqueidentifier NULL,
						[InteractionId] uniqueidentifier NULL,
						[DateActionPlanCreated] datetime2 NULL,
						[CustomerCharterShownToCustomer] bit NULL,
						[DateAndTimeCharterShown] datetime2 NULL,
						[DateActionPlanSentToCustomer] datetime2 NULL,
						[ActionPlanDeliveryMethod] int NULL,
						[DateActionPlanAcknowledged] datetime2 NULL,
						[PriorityCustomer] int NULL,
						[CurrentSituation] [varchar](max) NULL,
						[LastModifiedDate] datetime2 NULL,
						[LastModifiedTouchpointId] [varchar](max) NULL) 
			ON [PRIMARY]
		END

		INSERT INTO [dss-actionplans] 
			SELECT  
			CONVERT(uniqueidentifier, [id]) as [id],
			CONVERT(uniqueidentifier, [CustomerId]) as [CustomerId],
			CONVERT(uniqueidentifier, [InteractionId]) as [InteractionId],
			CONVERT(datetime2, [DateActionPlanCreated]) as [DateActionPlanCreated],
			CONVERT(bit, [CustomerCharterShownToCustomer]) as [CustomerCharterShownToCustomer],
			CONVERT(datetime2, DateAndTimeCharterShown) as [DateAndTimeCharterShown],
			CONVERT(datetime2, DateActionPlanSentToCustomer) as [DateActionPlanSentToCustomer],
			CONVERT(int, ActionPlanDeliveryMethod) as [ActionPlanDeliveryMethod],
			CONVERT(datetime2, [DateActionPlanAcknowledged]) as [DateActionPlanAcknowledged],
			CONVERT(int, [PriorityCustomer]) as [PriorityCustomer],
			[CurrentSituation],
			CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
			[LastModifiedTouchpointId]
			FROM #actionplans

		DROP TABLE #actionplans
		
END