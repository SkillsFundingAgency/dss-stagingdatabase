CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-sessions] (@Json NVARCHAR(MAX))
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
				,SessionAttended BIT
				,ReasonForNonAttendance INT
				,LastModifiedDate DATETIME2
				,LastModifiedTouchpointId VARCHAR(Max)
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
				,dsssessions.SessionAttended = InputJSON.SessionAttended
				,dsssessions.ReasonForNonAttendance = InputJSON.ReasonForNonAttendance
				,dsssessions.LastModifiedDate = InputJSON.LastModifiedDate
				,dsssessions.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId
	WHEN NOT MATCHED
		THEN
			INSERT (
				id
				,CustomerId
				,InteractionId
				,SubcontractorId
				,DateandTimeOfSession
				,VenuePostCode
				,SessionAttended
				,ReasonForNonAttendance
				,LastModifiedDate
				,LastModifiedTouchpointId
				)
			VALUES (
				InputJSON.id
				,InputJSON.CustomerId
				,InputJSON.InteractionId
				,InputJSON.SubcontractorId
				,InputJSON.DateandTimeOfSession
				,InputJSON.VenuePostCode
				,InputJSON.SessionAttended
				,InputJSON.ReasonForNonAttendance
				,InputJSON.LastModifiedDate
				,InputJSON.LastModifiedTouchpointId
				);
END