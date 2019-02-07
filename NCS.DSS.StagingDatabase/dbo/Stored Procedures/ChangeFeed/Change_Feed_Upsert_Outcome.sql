CREATE PROCEDURE [dbo].[Change_Feed_Upsert_Outcome](@OutcomeJson NVARCHAR(max))
AS
  BEGIN
    MERGE
    INTO         [dss-outcomes] AS outcomes
    USING        (
                        SELECT *
                        FROM OPENJSON(@OutcomeJson) WITH (id uniqueidentifier, CustomerId uniqueidentifier, ActionPlanId uniqueidentifier, SubcontractorId varchar(50), OutcomeType int, OutcomeClaimedDate datetime2, OutcomeEffectiveDate datetime2, ClaimedPriorityGroup int, TouchpointId varchar(max), LastModifiedDate datetime2, LastModifiedTouchpointId varchar(max))) AS inputjson
    ON (
                              outcomes.id = inputjson.id)
    WHEN MATCHED THEN
    UPDATE
    SET              outcomes.CustomerId = inputjson.CustomerId,
                     outcomes.ActionPlanId = inputjson.ActionPlanId,
                     outcomes.SubcontractorId = inputjson.SubcontractorId,
                     outcomes.OutcomeType = inputjson.OutcomeType,
                     outcomes.OutcomeClaimedDate = inputjson.OutcomeClaimedDate,
                     outcomes.OutcomeEffectiveDate = inputjson.OutcomeEffectiveDate,
                     outcomes.ClaimedPriorityGroup = inputjson.ClaimedPriorityGroup,
                     outcomes.TouchpointId = inputjson.TouchpointId,
                     outcomes.LastModifiedDate = inputjson.LastModifiedDate,
                     outcomes.LastModifiedTouchpointId = inputjson.LastModifiedTouchpointId
    WHEN NOT MATCHED THEN
    INSERT
           (
                  id,
                  CustomerId,
                  ActionPlanId,
                  SubcontractorId,
                  OutcomeType,
                  OutcomeClaimedDate,
                  OutcomeEffectiveDate,
                  ClaimedPriorityGroup,
                  TouchpointId,
                  LastModifiedDate,
                  LastModifiedTouchpointId
           )
           VALUES
           (
                  inputjson.id,
                  inputjson.CustomerId,
                  inputjson.ActionPlanId,
                  inputjson.SubcontractorId,
                  inputjson.OutcomeType,
                  inputjson.OutcomeClaimedDate,
                  inputjson.OutcomeEffectiveDate,
                  inputjson.ClaimedPriorityGroup,
                  inputjson.TouchpointId,
                  inputjson.LastModifiedDate,
                  inputjson.LastModifiedTouchpointId
           );
  
END
GO