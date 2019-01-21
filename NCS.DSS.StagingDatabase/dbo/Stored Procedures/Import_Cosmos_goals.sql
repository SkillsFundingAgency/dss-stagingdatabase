CREATE PROCEDURE [dbo].[Import_Cosmos_goals]

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
						 [id] [varchar](50) NULL,
						 [CustomerId] [varchar](50) NULL,
						 [ActionPlanId] [varchar](50) NULL,
						 [DateGoalCaptured] [varchar](50) NULL,
						 [DateGoalShouldBeCompletedBy] [varchar](50) NULL,
						 [DateGoalAchieved] [varchar](50) NULL,
						 [GoalSummary] [varchar](50) NULL,
						 [GoalType] [varchar](50) NULL,
						 [GoalStatus] [varchar](50) NULL,						 
						 [LastModifiedDate] [varchar](50) NULL,
						 [LastModifiedTouchpointId] [varchar](50) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#goals]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(50) '$.id', 
			CustomerId VARCHAR(50) '$.CustomerId',
			ActionPlanId VARCHAR(50) '$.ActionPlanId',
			DateGoalCaptured VARCHAR(50) '$.DateGoalCaptured',
			DateGoalShouldBeCompletedBy VARCHAR(50) '$.DateGoalShouldBeCompletedBy',
			DateGoalAchieved VARCHAR(50) '$.DateGoalAchieved',
			GoalSummary VARCHAR(50) '$.GoalSummary',
			GoalType VARCHAR(50) '$.GoalType',
			GoalStatus VARCHAR(50) '$.GoalStatus',
			LastModifiedDate VARCHAR(50) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(50) '$.LastModifiedTouchpointId'
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
						 [GoalSummary] [varchar](50) NULL,
						 [GoalType] int NULL,
						 [GoalStatus] int NULL,						 
						 [LastModifiedDate] datetime NULL,
						 [LastModifiedTouchpointId] [varchar](10) NULL) 
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
