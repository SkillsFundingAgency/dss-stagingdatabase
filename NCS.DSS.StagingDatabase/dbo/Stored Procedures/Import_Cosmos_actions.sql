CREATE PROCEDURE [dbo].[Import_Cosmos_actions]

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
					as Actions)'

	SET @ParmDef = N'@retvalOUT NVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

    IF OBJECT_ID('#actions', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE #actions
		END
	ELSE
		BEGIN
			CREATE TABLE [#actions](
						 [id] [varchar](50) NULL,
						 [CustomerId] [varchar](50) NULL,
						 [ActionPlanId] [varchar](50) NULL,
						 [DateActionAgreed] [varchar](50) NULL,
						 [DateActionAimsToBeCompletedBy] [varchar](50) NULL,
						 [DateActionActuallyCompleted] [varchar](50) NULL,
						 [ActionSummary] [varchar](50) NULL,
						 [SignpostedTo] [varchar](50) NULL,
						 [ActionType] [varchar](50) NULL,
						 [ActionStatus] [varchar](50) NULL,
						 [PersonResponsible] [varchar](50) NULL,
						 [LastModifiedDate] [varchar](50) NULL,
						 [LastModifiedTouchpointId] [varchar](50) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#actions]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(50) '$.id', 
			CustomerId VARCHAR(50) '$.CustomerId',
			ActionPlanId VARCHAR(50) '$.ActionPlanId',
			DateActionAgreed VARCHAR(50) '$.DateActionAgreed',
			DateActionAimsToBeCompletedBy VARCHAR(50) '$.DateActionAimsToBeCompletedBy',
			DateActionActuallyCompleted VARCHAR(50) '$.DateActionActuallyCompleted',
			ActionSummary VARCHAR(50) '$.ActionSummary',
			SignpostedTo VARCHAR(50) '$.SignpostedTo',
			ActionType VARCHAR(50) '$.ActionType',
			ActionStatus VARCHAR(50) '$.ActionStatus',
			PersonResponsible VARCHAR(50) '$.PersonResponsible',
			LastModifiedDate VARCHAR(50) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(50) '$.LastModifiedTouchpointId'
			) as Coll

	
	IF OBJECT_ID('[dss-actions]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-actions]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-actions](
						 [id] uniqueidentifier NULL,
						 [CustomerId] uniqueidentifier NULL,
						 [ActionPlanId] uniqueidentifier NULL,
						 [DateActionAgreed] datetime NULL,
						 [DateActionAimsToBeCompletedBy] datetime NULL,
						 [DateActionActuallyCompleted] datetime NULL,
						 [ActionSummary] [varchar](50) NULL,
						 [SignpostedTo] [varchar](50) NULL,
						 [ActionType] int NULL,
						 [ActionStatus] int NULL,
						 [PersonResponsible] int NULL,
						 [LastModifiedDate] [varchar](50) NULL,
						 [LastModifiedTouchpointId] [varchar](10) NULL) 
						 ON [PRIMARY]					

		END

		INSERT INTO [dss-actions] 
				SELECT
				CONVERT(uniqueidentifier, [id]) as [id],
				CONVERT(uniqueidentifier, [CustomerId]) as [CustomerId],
				CONVERT(uniqueidentifier, [ActionPlanId]) as [ActionPlanId],
				CONVERT(datetime2, [DateActionAgreed]) as [DateActionAgreed],
				CONVERT(datetime2, [DateActionAimsToBeCompletedBy]) as [DateActionAimsToBeCompletedBy],
				CONVERT(datetime2, [DateActionActuallyCompleted]) as [DateActionActuallyCompleted],
				[ActionSummary],
				[SignpostedTo],
				CONVERT(int, [ActionType]) as [ActionType],
				CONVERT(int, [ActionStatus]) as [ActionStatus],
				CONVERT(int, [PersonResponsible]) as [PersonResponsible],
				CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
				[LastModifiedTouchpointId]
				FROM #actions


		DROP TABLE #actions

END
