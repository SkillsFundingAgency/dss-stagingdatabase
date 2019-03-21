CREATE PROCEDURE [dbo].[insert-dss-outcomes-history] (@Json NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO [dss-outcomes-history]
		SELECT DATEADD(MINUTE, _ts/60, DATEADD(SECOND, _ts%60, '19700101')) as CosmosTimeStamp, id, CustomerId, ActionPlanId, SubcontractorId, OutcomeType, OutcomeClaimedDate,
		       OutcomeEffectiveDate, ClaimedPriorityGroup, TouchpointId, LastModifiedDate, LastModifiedTouchpointId
			FROM OPENJSON(@Json) WITH (
				_ts BIGINT
				,id UNIQUEIDENTIFIER
				,CustomerId UNIQUEIDENTIFIER
				,ActionPlanId UNIQUEIDENTIFIER
				,SubcontractorId VARCHAR(50)
				,OutcomeType INT
				,OutcomeClaimedDate DATETIME2
				,OutcomeEffectiveDate DATETIME2
				,ClaimedPriorityGroup VARCHAR(max)
				,TouchpointId VARCHAR(max)
				,LastModifiedDate DATETIME2
				,LastModifiedTouchpointId VARCHAR(max)
				)
END