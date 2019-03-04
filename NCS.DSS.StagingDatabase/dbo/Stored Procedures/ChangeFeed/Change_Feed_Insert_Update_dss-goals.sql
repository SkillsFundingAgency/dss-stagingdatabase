CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-goals](@Json NVARCHAR(MAX))
AS BEGIN
MERGE INTO [dss-goals] AS goals
USING (
    SELECT *
    FROM  OPENJSON(@Json)
          WITH (Id uniqueidentifier, CustomerId uniqueidentifier, ActionPlanId uniqueidentifier, SubcontractorId varchar(50), DateGoalCaptured datetime2,
                DateGoalShouldBeCompletedBy datetime2, DateGoalAchieved datetime2, GoalSummary varchar(max), GoalType varchar(max), GoalStatus int,
				LastModifiedDate datetime2, LastModifiedTouchpointId varchar(max))) as InputJSON
   ON (goals.id = InputJSON.Id)
WHEN MATCHED THEN
    UPDATE SET goals.CustomerId = InputJSON.CustomerId,
               goals.ActionPlanId = InputJSON.ActionPlanId,
			   goals.SubcontractorId = InputJSON.SubcontractorId,
			   goals.DateGoalCaptured = InputJSON.DateGoalCaptured,
			   goals.DateGoalShouldBeCompletedBy = InputJSON.DateGoalShouldBeCompletedBy,
			   goals.DateGoalAchieved = InputJSON.DateGoalAchieved,
			   goals.GoalSummary = InputJSON.GoalSummary,
			   goals.GoalType = InputJSON.GoalType,
			   goals.GoalStatus = InputJSON.GoalStatus,
			   goals.LastModifiedDate = InputJSON.LastModifiedDate,
			   goals.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId               
WHEN NOT MATCHED THEN
    INSERT (Id, CustomerId, ActionPlanId, SubcontractorId, DateGoalCaptured, DateGoalShouldBeCompletedBy, DateGoalAchieved, GoalSummary, GoalType, GoalStatus, LastModifiedDate, LastModifiedTouchpointId)
    VALUES (InputJSON.Id, InputJSON.CustomerId, InputJSON.ActionPlanId, InputJSON.SubcontractorId, InputJSON.DateGoalCaptured, InputJSON.DateGoalShouldBeCompletedBy, InputJSON.DateGoalAchieved, InputJSON.GoalSummary, InputJSON.GoalType, InputJSON.GoalStatus, InputJSON.LastModifiedDate, InputJSON.LastModifiedTouchpointId);
END
