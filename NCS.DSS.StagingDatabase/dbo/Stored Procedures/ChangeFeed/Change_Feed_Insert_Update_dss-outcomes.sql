CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-outcomes](@Json NVARCHAR(MAX))
AS BEGIN
MERGE INTO [dss-outcomes] AS outcomes
USING (
    SELECT *
    FROM  OPENJSON(@Json)
          WITH (Id uniqueidentifier, CustomerId uniqueidentifier, ActionPlanId uniqueidentifier, SubcontractorId varchar(50), OutcomeType datetime2,
                OutcomeClaimedDate datetime2, OutcomeEffectiveDate datetime2, ClaimedPriorityGroup varchar(max), TouchpointId varchar(max), LastModifiedDate datetime2, LastModifiedTouchpointId varchar(max))) as InputJSON
   ON (outcomes.id = InputJSON.Id)
WHEN MATCHED THEN
    UPDATE SET outcomes.CustomerId = InputJSON.CustomerId,
               outcomes.ActionPlanId = InputJSON.ActionPlanId,
			   outcomes.SubcontractorId = InputJSON.SubcontractorId,
			   outcomes.OutcomeType = InputJSON.OutcomeType,
			   outcomes.OutcomeClaimedDate = InputJSON.OutcomeClaimedDate,
			   outcomes.OutcomeEffectiveDate = InputJSON.OutcomeEffectiveDate,
			   outcomes.ClaimedPriorityGroup = InputJSON.ClaimedPriorityGroup,
			   outcomes.TouchpointId = InputJSON.TouchpointId,
			   outcomes.LastModifiedDate = InputJSON.LastModifiedDate,
			   outcomes.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId               
WHEN NOT MATCHED THEN
    INSERT (Id, CustomerId, ActionPlanId, SubcontractorId, OutcomeType, OutcomeClaimedDate, OutcomeEffectiveDate, ClaimedPriorityGroup, TouchpointId, LastModifiedDate, LastModifiedTouchpointId)
    VALUES (InputJSON.Id, InputJSON.CustomerId, InputJSON.ActionPlanId, InputJSON.SubcontractorId, InputJSON.OutcomeType, InputJSON.OutcomeClaimedDate, InputJSON.OutcomeEffectiveDate, 
	InputJSON.ClaimedPriorityGroup, InputJSON.TouchpointId, InputJSON.LastModifiedDate, InputJSON.LastModifiedTouchpointId);
END
