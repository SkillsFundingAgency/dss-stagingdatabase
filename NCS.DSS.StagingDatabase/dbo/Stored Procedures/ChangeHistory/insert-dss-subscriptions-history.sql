CREATE PROCEDURE [dbo].[insert-dss-subscriptions-history] (@Json NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO [dss-subscriptions-history]
		SELECT DATEADD(MINUTE, _ts/60, DATEADD(SECOND, _ts%60, '19700101')) as CosmosTimeStamp, id, CustomerId, TouchPointId, Subscribe, LastModifiedDate, LastModifiedTouchpointId
			FROM OPENJSON(@Json) WITH (
			    _ts BIGINT	,
				id uniqueidentifier,
				CustomerId uniqueidentifier,
				TouchPointId varchar(max),
				Subscribe bit,			 
				LastModifiedDate datetime2,
				LastModifiedTouchpointId varchar(max)
				)
END				