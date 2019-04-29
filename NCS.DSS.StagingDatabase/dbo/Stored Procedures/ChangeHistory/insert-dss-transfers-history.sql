CREATE PROCEDURE [dbo].[insert-dss-transfers-history] (@Json NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO [dss-transfers-history]	
	SELECT DATEADD(MINUTE, _ts/60, DATEADD(SECOND, _ts%60, '19700101')) as CosmosTimeStamp, id, CustomerId, InteractionId, OriginatingTouchpointId,
	TargetTouchpointId, Context, DateandTimeOfTransfer, DateandTimeofTransferAccepted, RequestedCallbackTime, ActualCallbackTime,
	LastModifiedDate, LastModifiedTouchpointId		  
	FROM OPENJSON(@Json)
		WITH (	
				_ts bigint 			
				,id                            UNIQUEIDENTIFIER
				,CustomerId                    UNIQUEIDENTIFIER
				,InteractionId                 UNIQUEIDENTIFIER
				,OriginatingTouchpointId       VARCHAR (max)  
				,TargetTouchpointId            VARCHAR (max)
				,Context                       VARCHAR (max)
				,DateandTimeOfTransfer         datetime2
				,DateandTimeofTransferAccepted datetime2
				,RequestedCallbackTime         datetime2
				,ActualCallbackTime            datetime2
				,LastModifiedDate              datetime2
				,LastModifiedTouchpointId      VARCHAR (max)
			)
END