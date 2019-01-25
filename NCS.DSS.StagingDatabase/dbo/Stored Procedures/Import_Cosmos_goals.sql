CREATE PROCEDURE [dbo].[Import_Cosmos_goals]

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
					as Goals)'
	
	SET @ParmDef = N'@retvalOUT NVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

    IF OBJECT_ID('#goals', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE #goals
		END
	ELSE
		BEGIN
			CREATE TABLE [#goals](
						 [id] [varchar](max) NULL,
						 [CustomerId] [varchar](max) NULL,
						 [ActionPlanId] [varchar](max) NULL,
						 [DateGoalCaptured] [varchar](max) NULL,
						 [DateGoalShouldBeCompletedBy] [varchar](max) NULL,
						 [DateGoalAchieved] [varchar](max) NULL,
						 [GoalSummary] [varchar](max) NULL,
						 [GoalType] [varchar](max) NULL,
						 [GoalStatus] [varchar](max) NULL,						 
						 [LastModifiedDate] [varchar](max) NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#goals]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(MAX) '$.id', 
			CustomerId VARCHAR(MAX) '$.CustomerId',
			ActionPlanId VARCHAR(MAX) '$.ActionPlanId',
			DateGoalCaptured VARCHAR(MAX) '$.DateGoalCaptured',
			DateGoalShouldBeCompletedBy VARCHAR(MAX) '$.DateGoalShouldBeCompletedBy',
			DateGoalAchieved VARCHAR(MAX) '$.DateGoalAchieved',
			GoalSummary VARCHAR(MAX) '$.GoalSummary',
			GoalType VARCHAR(MAX) '$.GoalType',
			GoalStatus VARCHAR(MAX) '$.GoalStatus',
			LastModifiedDate VARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(MAX) '$.LastModifiedTouchpointId'
			) as Coll

	IF OBJECT_ID('[dss-goals]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-goals]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-goals](
						 [id] uniqueidentifier NULL,
						 [CustomerId] uniqueidentifier NULL,
						 [ActionPlanId] uniqueidentifier NULL,
						 [DateGoalCaptured] datetime NULL,
						 [DateGoalShouldBeCompletedBy] datetime NULL,
						 [DateGoalAchieved] datetime NULL,
						 [GoalSummary] [varchar](max) NULL,
						 [GoalType] int NULL,
						 [GoalStatus] int NULL,						 
						 [LastModifiedDate] datetime NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL) 
						 ON [PRIMARY]
		END

		INSERT INTO [dss-goals] 
				SELECT
				CONVERT(uniqueidentifier, [id]) as [id],
				CONVERT(uniqueidentifier, [CustomerId]) as [CustomerId],
				CONVERT(uniqueidentifier, [ActionPlanId]) as [ActionPlanId],
				CONVERT(datetime2, [DateGoalCaptured]) as [DateGoalCaptured],
				CONVERT(datetime2, [DateGoalShouldBeCompletedBy]) as [DateGoalShouldBeCompletedBy],
				CONVERT(datetime2, [DateGoalAchieved]) as [DateGoalAchieved],
				[GoalSummary],
				CONVERT(int, [GoalType]) as [GoalType],
				CONVERT(int, [GoalStatus]) as [GoalStatus],
				CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
				[LastModifiedTouchpointId]
				FROM #goals

		DROP TABLE #goals

END
