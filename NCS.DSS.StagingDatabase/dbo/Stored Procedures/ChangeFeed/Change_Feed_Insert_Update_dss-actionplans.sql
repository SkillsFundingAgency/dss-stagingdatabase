CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-actionplans](@Json NVARCHAR(MAX))
AS BEGIN
MERGE INTO [dss-actionplans] AS actionplans
USING (
    SELECT *
    FROM  OPENJSON(@Json)
          WITH (Id uniqueidentifier, CustomerId uniqueidentifier, InteractionId uniqueidentifier, SessionId uniqueidentifier, SubcontractorId varchar(max),
                DateActionPlanCreated datetime2, CustomerCharterShownToCustomer bit, DateAndTimeCharterShown datetime2, DateActionPlanSentToCustomer datetime2, ActionPlanDeliveryMethod int,
				DateActionPlanAcknowledged datetime2, PriorityCustomer int,  CurrentSituation Varchar(Max), LastModifiedDate datetime2, LastModifiedTouchpointId varchar(max))) as InputJSON
   ON (actionplans.id = InputJSON.Id)
WHEN MATCHED THEN
    UPDATE SET actionplans.CustomerId = InputJSON.CustomerId,
               actionplans.InteractionId = InputJSON.InteractionId,
			   actionplans.SessionId = InputJSON.SessionId,
			   actionplans.SubcontractorId = InputJSON.SubcontractorId,
			   actionplans.DateActionPlanCreated = InputJSON.DateActionPlanCreated,
			   actionplans.CustomerCharterShownToCustomer = InputJSON.CustomerCharterShownToCustomer,
			   actionplans.DateAndTimeCharterShown = InputJSON.DateAndTimeCharterShown,
			   actionplans.DateActionPlanSentToCustomer = InputJSON.DateActionPlanSentToCustomer,
			   actionplans.ActionPlanDeliveryMethod = InputJSON.ActionPlanDeliveryMethod,
			   actionplans.DateActionPlanAcknowledged = InputJSON.DateActionPlanAcknowledged,
			   actionplans.PriorityCustomer = InputJSON.PriorityCustomer,
			   actionplans.CurrentSituation = InputJSON.CurrentSituation,
			   actionplans.LastModifiedDate = InputJSON.LastModifiedDate,
			   actionplans.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId               
WHEN NOT MATCHED THEN
    INSERT (Id, CustomerId, InteractionId, SessionId, SubcontractorId, DateActionPlanCreated, CustomerCharterShownToCustomer, DateAndTimeCharterShown, DateActionPlanSentToCustomer, 
	ActionPlanDeliveryMethod, DateActionPlanAcknowledged, PriorityCustomer, CurrentSituation, LastModifiedDate, LastModifiedTouchpointId)
    VALUES (InputJSON.Id, InputJSON.CustomerId, InputJSON.InteractionId, InputJSON.SessionId, InputJSON.SubcontractorId, InputJSON.DateActionPlanCreated, 
	InputJSON.CustomerCharterShownToCustomer, InputJSON.DateAndTimeCharterShown, InputJSON.DateActionPlanSentToCustomer, InputJSON.ActionPlanDeliveryMethod, 
	InputJSON.DateActionPlanAcknowledged, InputJSON.PriorityCustomer, InputJSON.CurrentSituation, InputJSON.LastModifiedDate, InputJSON.LastModifiedTouchpointId);
END

