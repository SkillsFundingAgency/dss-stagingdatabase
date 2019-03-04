CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-sessions](@Json NVARCHAR(MAX))
AS BEGIN
MERGE INTO [dss-sessions] AS dsssessions
USING (
    SELECT *
    FROM  OPENJSON(@Json)
          WITH (Id uniqueidentifier, CustomerId uniqueidentifier, InteractionId uniqueidentifier, SubcontractorId varchar(50), DateandTimeOfSession datetime2,
                VenuePostCode datetime2, SessionAttended datetime2, ReasonForNonAttendance varchar(max), LastModifiedDate datetime2, LastModifiedTouchpointId varchar(max))) as InputJSON
   ON (dsssessions.id = InputJSON.Id)
WHEN MATCHED THEN
    UPDATE SET dsssessions.CustomerId = InputJSON.CustomerId,
               dsssessions.InteractionId = InputJSON.InteractionId,
			   dsssessions.SubcontractorId = InputJSON.SubcontractorId,
			   dsssessions.DateandTimeOfSession = InputJSON.DateandTimeOfSession,
			   dsssessions.VenuePostCode = InputJSON.VenuePostCode,
			   dsssessions.SessionAttended = InputJSON.SessionAttended,
			   dsssessions.ReasonForNonAttendance = InputJSON.ReasonForNonAttendance,
			   dsssessions.LastModifiedDate = InputJSON.LastModifiedDate,
			   dsssessions.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId               
WHEN NOT MATCHED THEN
    INSERT (Id, CustomerId, InteractionId, SubcontractorId, DateandTimeOfSession, VenuePostCode, SessionAttended, ReasonForNonAttendance, LastModifiedDate, LastModifiedTouchpointId)
    VALUES (InputJSON.Id, InputJSON.CustomerId, InputJSON.InteractionId, InputJSON.SubcontractorId, InputJSON.DateandTimeOfSession, InputJSON.VenuePostCode, InputJSON.SessionAttended, 
	InputJSON.ReasonForNonAttendance, InputJSON.LastModifiedDate, InputJSON.LastModifiedTouchpointId);
END
