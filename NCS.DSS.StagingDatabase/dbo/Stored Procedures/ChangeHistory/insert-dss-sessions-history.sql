CREATE PROCEDURE [dbo].[insert-dss-sessions-history] (@Json NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO [dss-sessions-history]
		SELECT DATEADD(MINUTE, _ts/60, DATEADD(SECOND, _ts%60, '19700101')) as CosmosTimeStamp, id, CustomerId, InteractionId, SubcontractorId, DateandTimeOfSession, 
		       VenuePostCode, Longitude, Latitude, SessionAttended, ReasonForNonAttendance, LastModifiedDate, LastModifiedTouchpointId
			FROM OPENJSON(@Json) WITH (
			    _ts BIGINT	
				,id UNIQUEIDENTIFIER
				,CustomerId UNIQUEIDENTIFIER
				,InteractionId UNIQUEIDENTIFIER
				,SubcontractorId VARCHAR(50)
				,DateandTimeOfSession DATETIME2
				,VenuePostCode VARCHAR(Max)
				,Longitude FLOAT
				,Latitude FLOAT
				,SessionAttended BIT
				,ReasonForNonAttendance INT
				,LastModifiedDate DATETIME2
				,LastModifiedTouchpointId VARCHAR(Max)
				)
END				