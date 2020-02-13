CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-outcomes] (@Json NVARCHAR(MAX))
AS
BEGIN
	MERGE INTO [dss-outcomes] AS outcomes
	USING (
		SELECT *
		FROM OPENJSON(@Json) WITH (
				id UNIQUEIDENTIFIER
				,CustomerId UNIQUEIDENTIFIER
				,ActionPlanId UNIQUEIDENTIFIER				
				,SessionId UNIQUEIDENTIFIER
				,SubcontractorId VARCHAR(50)				
				,OutcomeType INT
				,OutcomeClaimedDate DATETIME2
				,OutcomeEffectiveDate DATETIME2
				,ClaimedPriorityGroup VARCHAR(MAX)
				,TouchpointId VARCHAR(MAX)
				,LastModifiedDate DATETIME2
				,LastModifiedTouchpointId VARCHAR(MAX)
				,CreatedBy VARCHAR(Max)
				)
		) AS InputJSON
		ON (outcomes.id = InputJSON.id)
	WHEN MATCHED
		THEN
			UPDATE
			SET outcomes.id = InputJSON.id
				,outcomes.CustomerId = InputJSON.CustomerId
				,outcomes.ActionPlanId = InputJSON.ActionPlanId		
				,outcomes.SessionId = InputJSON.SessionId
				,outcomes.SubcontractorId = InputJSON.SubcontractorId				
				,outcomes.OutcomeType = InputJSON.OutcomeType
				,outcomes.OutcomeClaimedDate = InputJSON.OutcomeClaimedDate
				,outcomes.OutcomeEffectiveDate = InputJSON.OutcomeEffectiveDate
				,outcomes.ClaimedPriorityGroup = InputJSON.ClaimedPriorityGroup
				,outcomes.TouchpointId = InputJSON.TouchpointId
				,outcomes.LastModifiedDate = InputJSON.LastModifiedDate
				,outcomes.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId
				,outcomes.CreatedBy = InputJSON.CreatedBy
	WHEN NOT MATCHED
		THEN
			INSERT (
				id
				,CustomerId
				,ActionPlanId	
				,SessionId
				,SubcontractorId				
				,OutcomeType
				,OutcomeClaimedDate
				,OutcomeEffectiveDate
				,ClaimedPriorityGroup
				,TouchpointId
				,LastModifiedDate
				,LastModifiedTouchpointId
				,CreatedBy
				)
			VALUES (
				InputJSON.id
				,InputJSON.CustomerId
				,InputJSON.ActionPlanId		
				,InputJSON.SessionId
				,InputJSON.SubcontractorId				
				,InputJSON.OutcomeType
				,InputJSON.OutcomeClaimedDate
				,InputJSON.OutcomeEffectiveDate
				,InputJSON.ClaimedPriorityGroup
				,InputJSON.TouchpointId
				,InputJSON.LastModifiedDate
				,InputJSON.LastModifiedTouchpointId
				,InputJSON.CreatedBy
				);

	exec [dbo].[insert-dss-outcomes-history] @Json
END