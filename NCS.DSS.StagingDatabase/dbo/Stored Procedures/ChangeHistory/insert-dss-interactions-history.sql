CREATE PROCEDURE [dbo].[insert-dss-interactions-history] (@Json NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO [dss-interactions-history]
		SELECT DATEADD(MINUTE, _ts/60, DATEADD(SECOND, _ts%60, '19700101')) as CosmosTimeStamp, id, CustomerId, TouchpointId, AdviserDetailsId, DateandTimeOfInteraction, Channel, 
		       InteractionType, LastModifiedDate, LastModifiedTouchpointId
			FROM OPENJSON(@Json) WITH (
			    _ts BIGINT	
				,id UNIQUEIDENTIFIER
				,CustomerId UNIQUEIDENTIFIER
				,TouchpointId VARCHAR(Max)
				,AdviserDetailsId UNIQUEIDENTIFIER
				,DateandTimeOfInteraction DATETIME2
				,Channel INT
				,InteractionType INT
				,LastModifiedDate DATETIME2
				,LastModifiedTouchpointId VARCHAR(Max)
				)
END				