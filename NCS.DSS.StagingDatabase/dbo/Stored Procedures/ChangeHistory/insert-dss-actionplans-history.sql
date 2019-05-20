CREATE PROCEDURE [dbo].[insert-dss-actionplans-history] (@Json NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO [dss-actionplans-history]	
	SELECT DATEADD(MINUTE, _ts/60, DATEADD(SECOND, _ts%60, '19700101')) as CosmosTimeStamp, id, CustomerId, InteractionId, SessionId, SubContractorId, DateActionPlanCreated, 
				   CustomerCharterShownToCustomer, DateAndTimeCharterShown, DateActionPlanSentToCustomer, ActionPlanDeliveryMethod,
				   DateActionPlanAcknowledged, PriorityCustomer, CurrentSituation, LastModifiedDate, LastModifiedTouchpointId, CreatedBy		  
	FROM OPENJSON(@Json)
		WITH (	
				_ts bigint 			
				,id UNIQUEIDENTIFIER
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
				,CreatedBy VARCHAR(MAX)
			)
END