CREATE PROCEDURE [dbo].[insert-dss-collections-history] (@Json NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO [dss-collections-history]	
	SELECT DATEADD(MINUTE, _ts/60, DATEADD(SECOND, _ts%60, '19700101')) as CosmosTimeStamp, id, ContainerName,  ReportFileName, CollectionReports, TouchPointId, Ukprn, LastModifiedDate		  
	FROM OPENJSON(@Json)
		WITH (	
				_ts bigint 			
				,id UNIQUEIDENTIFIER
				,ContainerName VARCHAR(MAX)
				,ReportFileName VARCHAR(MAX)
				,CollectionReports VARCHAR(MAX)
				,TouchPointId VARCHAR(MAX)
				,Ukprn VARCHAR(MAX)
				,LastModifiedDate DATETIME2
			)
END