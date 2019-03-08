CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-actionplans] (@Json NVARCHAR(MAX))
AS
BEGIN
	MERGE INTO [dss-actionplans] AS actionplans
	USING (
		SELECT *
		FROM OPENJSON(@Json) WITH (
				id UNIQUEIDENTIFIER
				,CustomerId UNIQUEIDENTIFIER
				,InteractionId UNIQUEIDENTIFIER
				,SessionId UNIQUEIDENTIFIER
				,SubcontractorId VARCHAR(MAX)
				,DateActionPlanCreated DATETIME2
				,CustomerCharterShownToCustomer BIT
				,DateAndTimeCharterShown DATETIME2
				,DateActionPlanSentToCustomer DATETIME2
				,ActionPlanDeliveryMethod INT
				,DateActionPlanAcknowledged DATETIME2
				,PriorityCustomer INT
				,CurrentSituation VARCHAR(MAX)
				,LastModifiedDate DATETIME2
				,LastModifiedTouchpointId VARCHAR(MAX)
				)
		) AS InputJSON
		ON (actionplans.id = InputJSON.id)
	WHEN MATCHED
		THEN
			UPDATE
			SET actionplans.id = InputJSON.id
				,actionplans.CustomerId = InputJSON.CustomerId
				,actionplans.InteractionId = InputJSON.InteractionId
				,actionplans.SessionId = InputJSON.SessionId
				,actionplans.SubcontractorId = InputJSON.SubcontractorId
				,actionplans.DateActionPlanCreated = InputJSON.DateActionPlanCreated
				,actionplans.CustomerCharterShownToCustomer = InputJSON.CustomerCharterShownToCustomer
				,actionplans.DateAndTimeCharterShown = InputJSON.DateAndTimeCharterShown
				,actionplans.DateActionPlanSentToCustomer = InputJSON.DateActionPlanSentToCustomer
				,actionplans.ActionPlanDeliveryMethod = InputJSON.ActionPlanDeliveryMethod
				,actionplans.DateActionPlanAcknowledged = InputJSON.DateActionPlanAcknowledged
				,actionplans.PriorityCustomer = InputJSON.PriorityCustomer
				,actionplans.CurrentSituation = InputJSON.CurrentSituation
				,actionplans.LastModifiedDate = InputJSON.LastModifiedDate
				,actionplans.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId
	WHEN NOT MATCHED
		THEN
			INSERT (
				id
				,CustomerId
				,InteractionId
				,SessionId
				,SubcontractorId
				,DateActionPlanCreated
				,CustomerCharterShownToCustomer
				,DateAndTimeCharterShown
				,DateActionPlanSentToCustomer
				,ActionPlanDeliveryMethod
				,DateActionPlanAcknowledged
				,PriorityCustomer
				,CurrentSituation
				,LastModifiedDate
				,LastModifiedTouchpointId
				)
			VALUES (
				InputJSON.id
				,InputJSON.CustomerId
				,InputJSON.InteractionId
				,InputJSON.SessionId
				,InputJSON.SubcontractorId
				,InputJSON.DateActionPlanCreated
				,InputJSON.CustomerCharterShownToCustomer
				,InputJSON.DateAndTimeCharterShown
				,InputJSON.DateActionPlanSentToCustomer
				,InputJSON.ActionPlanDeliveryMethod
				,InputJSON.DateActionPlanAcknowledged
				,InputJSON.PriorityCustomer
				,InputJSON.CurrentSituation
				,InputJSON.LastModifiedDate
				,InputJSON.LastModifiedTouchpointId
				);
END