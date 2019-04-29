CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-transfers] (@Json NVARCHAR(MAX))
AS
BEGIN
	MERGE INTO [dss-transfers] AS dsstransfers
	USING (
		SELECT *
		FROM OPENJSON(@Json) WITH (
				id  UNIQUEIDENTIFIER,
				CustomerId UNIQUEIDENTIFIER,
				InteractionId UNIQUEIDENTIFIER,
				OriginatingTouchpointId VARCHAR (max),  
				TargetTouchpointId VARCHAR (max),
				Context VARCHAR (max),
				DateandTimeOfTransfer datetime2,
				DateandTimeofTransferAccepted datetime2,
				RequestedCallbackTime datetime2,
				ActualCallbackTime datetime2,
				LastModifiedDate datetime2,
				LastModifiedTouchpointId VARCHAR (max)
				)
		) AS InputJSON
		ON (dsstransfers.id = InputJSON.id)
	WHEN MATCHED
		THEN
			UPDATE
			SET dsstransfers.id = InputJSON.id
				,dsstransfers.CustomerId = InputJSON.CustomerId
				,dsstransfers.InteractionId = InputJSON.InteractionId
				,dsstransfers.OriginatingTouchpointId = InputJSON.OriginatingTouchpointId
				,dsstransfers.TargetTouchpointId = InputJSON.TargetTouchpointId
				,dsstransfers.Context = InputJSON.Context
				,dsstransfers.DateandTimeOfTransfer = InputJSON.DateandTimeOfTransfer
				,dsstransfers.DateandTimeofTransferAccepted = InputJSON.DateandTimeofTransferAccepted
				,dsstransfers.RequestedCallbackTime = InputJSON.RequestedCallbackTime
				,dsstransfers.ActualCallbackTime = InputJSON.ActualCallbackTime
				,dsstransfers.LastModifiedDate = InputJSON.LastModifiedDate
				,dsstransfers.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId
	WHEN NOT MATCHED
		THEN
			INSERT (
				id
				,CustomerId
				,InteractionId
				,OriginatingTouchpointId
				,TargetTouchpointId
				,Context
				,DateandTimeOfTransfer
				,DateandTimeofTransferAccepted
				,RequestedCallbackTime
				,ActualCallbackTime
				,LastModifiedDate
				,LastModifiedTouchpointId
				)
			VALUES (
				InputJSON.id
				,InputJSON.CustomerId
				,InputJSON.InteractionId
				,InputJSON.OriginatingTouchpointId
				,InputJSON.TargetTouchpointId
				,InputJSON.Context
				,InputJSON.DateandTimeOfTransfer
				,InputJSON.DateandTimeofTransferAccepted
				,InputJSON.RequestedCallbackTime
				,InputJSON.ActualCallbackTime
				,InputJSON.LastModifiedDate
				,InputJSON.LastModifiedTouchpointId
				);

	exec [dbo].[insert-dss-transfers-history] @Json
END