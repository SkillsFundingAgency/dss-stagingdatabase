CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-actions](@Json NVARCHAR(MAX))
AS BEGIN
MERGE INTO [dss-actions] AS actions
USING (
    SELECT *
    FROM  OPENJSON(@Json)
          WITH (Id uniqueidentifier, CustomerId uniqueidentifier, ActionPlanId uniqueidentifier, SubcontractorId varchar(50), DateActionAgreed datetime2,
                DateActionAimsToBeCompletedBy datetime2, DateActionActuallyCompleted datetime2, ActionSummary varchar(max), SignpostedTo varchar(max), ActionType int,
				ActionStatus int, PersonResponsible int, LastModifiedDate datetime2, LastModifiedTouchpointId varchar(max))) as InputJSON
   ON (actions.id = InputJSON.Id)
WHEN MATCHED THEN
    UPDATE SET actions.CustomerId = InputJSON.CustomerId,
               actions.ActionPlanId = InputJSON.ActionPlanId,
			   actions.SubcontractorId = InputJSON.SubcontractorId,
			   actions.DateActionAgreed = InputJSON.DateActionAgreed,
			   actions.DateActionAimsToBeCompletedBy = InputJSON.DateActionAimsToBeCompletedBy,
			   actions.DateActionActuallyCompleted = InputJSON.DateActionActuallyCompleted,
			   actions.ActionSummary = InputJSON.ActionSummary,
			   actions.SignpostedTo = InputJSON.SignpostedTo,
			   actions.ActionType = InputJSON.ActionType,
			   actions.ActionStatus = InputJSON.ActionStatus,
			   actions.PersonResponsible = InputJSON.PersonResponsible,
			   actions.LastModifiedDate = InputJSON.LastModifiedDate,
			   actions.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId               
WHEN NOT MATCHED THEN
    INSERT (Id, CustomerId, ActionPlanId, SubcontractorId, DateActionAgreed, DateActionAimsToBeCompletedBy, DateActionActuallyCompleted, ActionSummary, SignpostedTo, 
	ActionType, ActionStatus, PersonResponsible, LastModifiedDate, LastModifiedTouchpointId)
    VALUES (InputJSON.Id, InputJSON.CustomerId, InputJSON.ActionPlanId, InputJSON.SubcontractorId, InputJSON.DateActionAgreed, InputJSON.DateActionAimsToBeCompletedBy, 
	InputJSON.DateActionActuallyCompleted, InputJSON.ActionSummary, InputJSON.SignpostedTo, InputJSON.ActionType, InputJSON.ActionStatus, InputJSON.PersonResponsible, 
	InputJSON.LastModifiedDate, InputJSON.LastModifiedTouchpointId);
END



