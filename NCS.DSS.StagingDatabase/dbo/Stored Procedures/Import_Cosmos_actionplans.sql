CREATE PROCEDURE [dbo].[Import_Cosmos_actionplans]

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
					as ActionPlans)'
	
	SET @ParmDef = N'@retvalOUT NVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

	CREATE TABLE [#actionplans](
				[id] [varchar](50) NULL,
				[CustomerId] [varchar](50) NULL,
				[InteractionId] [varchar](50) NULL,
				[DateActionPlanCreated] [varchar](50) NULL,
				[CustomerCharterShownToCustomer] [varchar](50) NULL,
				[DateAndTimeCharterShown] [varchar](50) NULL,
				[DateActionPlanSentToCustomer] [varchar](50) NULL,
				[ActionPlanDeliveryMethod] [varchar](50) NULL,
				[DateActionPlanAcknowledged] [varchar](50) NULL,
				[PriorityCustomer] [varchar](50) NULL,
				[CurrentSituation] [varchar](50) NULL,
				[LastModifiedDate] [varchar](50) NULL,
				[LastModifiedTouchpointId] [varchar](50) NULL
			) ON [PRIMARY]									


	INSERT INTO [#actionplans]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(50) '$.id', 
			CustomerId VARCHAR(50) '$.CustomerId',
			InteractionId VARCHAR(50) '$.InteractionId',
			DateActionPlanCreated VARCHAR(50) '$.DateActionPlanCreated',
			CustomerCharterShownToCustomer VARCHAR(50) '$.CustomerCharterShownToCustomer',
			DateAndTimeCharterShown VARCHAR(50) '$.DateAndTimeCharterShown',
			DateActionPlanSentToCustomer VARCHAR(50) '$.DateActionPlanSentToCustomer',
			ActionPlanDeliveryMethod VARCHAR(50) '$.ActionPlanDeliveryMethod',
			DateActionPlanAcknowledged VARCHAR(50) '$.DateActionPlanAcknowledged',
			PriorityCustomer VARCHAR(50) '$.PriorityCustomer',
			CurrentSituation VARCHAR(50) '$.CurrentSituation',
			LastModifiedDate VARCHAR(50) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(50) '$.LastModifiedTouchpointId'
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
						[DateActionPlanCreated] datetime NULL,
						[CustomerCharterShownToCustomer] bit NULL,
						[DateAndTimeCharterShown] datetime2 NULL,
						[DateActionPlanSentToCustomer] datetime NULL,
						[ActionPlanDeliveryMethod] int NULL,
						[DateActionPlanAcknowledged] datetime NULL,
						[PriorityCustomer] int NULL,
						[CurrentSituation] [varchar](50) NULL,
						[LastModifiedDate] datetime NULL,
						[LastModifiedTouchpointId] [varchar](10) NULL) 
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