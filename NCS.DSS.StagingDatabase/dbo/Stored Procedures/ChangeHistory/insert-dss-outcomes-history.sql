CREATE PROCEDURE [dbo].[insert-dss-outcomes-history] (@Json NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO [dss-outcomes-history]
		SELECT DATEADD(MINUTE, _ts/60, DATEADD(SECOND, _ts%60, '19700101')) as CosmosTimeStamp, id, CustomerId, ActionPlanId, SessionId, SubcontractorId, OutcomeType, OutcomeClaimedDate,
		       OutcomeEffectiveDate, ClaimedPriorityGroup, IsPriorityCustomer, TouchpointId, LastModifiedDate, LastModifiedTouchpointId, CreatedBy
			FROM OPENJSON(@Json) WITH (
				_ts BIGINT
				,id UNIQUEIDENTIFIER
				,CustomerId UNIQUEIDENTIFIER
				,ActionPlanId UNIQUEIDENTIFIER				
				,SessionId UNIQUEIDENTIFIER
				,SubcontractorId VARCHAR(50)				
				,OutcomeType INT
				,OutcomeClaimedDate DATETIME2
				,OutcomeEffectiveDate DATETIME2
				,ClaimedPriorityGroup VARCHAR(max)
				,IsPriorityCustomer BIT
				,TouchpointId VARCHAR(max)
				,LastModifiedDate DATETIME2
				,LastModifiedTouchpointId VARCHAR(max)
				,CreatedBy VARCHAR(max)
				)
END