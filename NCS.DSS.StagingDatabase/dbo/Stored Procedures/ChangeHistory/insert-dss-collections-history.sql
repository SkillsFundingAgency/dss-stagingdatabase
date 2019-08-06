CREATE PROCEDURE [dbo].[insert-dss-collections-history] (@Json NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO [dss-collections-history]	
	SELECT DATEADD(MINUTE, _ts/60, DATEADD(SECOND, _ts%60, '19700101')) as CosmosTimeStamp, id, CollectionReports, TouchpointId, Ukprn, LastModifiedDate		  
	FROM OPENJSON(@Json)
		WITH (	
				_ts bigint 			
				,id UNIQUEIDENTIFIER
				,CollectionReports VARCHAR(MAX)
				,TouchpointId VARCHAR(MAX)
				,Ukprn VARCHAR(MAX)
				,LastModifiedDate DATETIME2
			)
END