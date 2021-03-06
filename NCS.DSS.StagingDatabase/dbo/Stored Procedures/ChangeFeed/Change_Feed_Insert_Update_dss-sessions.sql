﻿CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-sessions] (@Json NVARCHAR(MAX))
AS
BEGIN
	MERGE INTO [dss-sessions] AS dsssessions
	USING (
		SELECT *
		FROM OPENJSON(@Json) WITH (
				id UNIQUEIDENTIFIER
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
				,CreatedBy VARCHAR(Max)
				)
		) AS InputJSON
		ON (dsssessions.id = InputJSON.id)
	WHEN MATCHED
		THEN
			UPDATE
			SET dsssessions.id = InputJSON.id
				,dsssessions.CustomerId = InputJSON.CustomerId
				,dsssessions.InteractionId = InputJSON.InteractionId
				,dsssessions.SubcontractorId = InputJSON.SubcontractorId
				,dsssessions.DateandTimeOfSession = InputJSON.DateandTimeOfSession
				,dsssessions.VenuePostCode = InputJSON.VenuePostCode
				,dsssessions.Longitude = InputJSON.Longitude
				,dsssessions.Latitude = InputJSON.Latitude
				,dsssessions.SessionAttended = InputJSON.SessionAttended
				,dsssessions.ReasonForNonAttendance = InputJSON.ReasonForNonAttendance
				,dsssessions.LastModifiedDate = InputJSON.LastModifiedDate
				,dsssessions.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId
				,dsssessions.CreatedBy = InputJSON.CreatedBy
	WHEN NOT MATCHED
		THEN
			INSERT (
				id
				,CustomerId
				,InteractionId
				,SubcontractorId
				,DateandTimeOfSession
				,VenuePostCode
				,Longitude
				,Latitude
				,SessionAttended
				,ReasonForNonAttendance
				,LastModifiedDate
				,LastModifiedTouchpointId
				,CreatedBy
				)
			VALUES (
				InputJSON.id
				,InputJSON.CustomerId
				,InputJSON.InteractionId
				,InputJSON.SubcontractorId
				,InputJSON.DateandTimeOfSession
				,InputJSON.VenuePostCode
				,InputJSON.Longitude
				,InputJSON.Latitude
				,InputJSON.SessionAttended
				,InputJSON.ReasonForNonAttendance
				,InputJSON.LastModifiedDate
				,InputJSON.LastModifiedTouchpointId
				,InputJSON.CreatedBy
				);

	exec [dbo].[insert-dss-sessions-history] @Json
END