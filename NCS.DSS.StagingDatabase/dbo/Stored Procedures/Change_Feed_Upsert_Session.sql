CREATE PROCEDURE [dbo].[Change_Feed_Upsert_Session](@SessionJson NVARCHAR(MAX))
AS BEGIN
MERGE INTO [dss-sessions] AS [sessions]
USING (
    SELECT *
    FROM  OPENJSON(@SessionJson)
          WITH (id uniqueidentifier, CustomerId uniqueidentifier, InteractionId uniqueidentifier, DateandTimeOfSession datetime2, VenuePostCode varchar(max),
                SessionAttended bit, ReasonForNonAttendance int, LastModifiedDate datetime2, LastModifiedTouchpointId varchar(max))) as InputJSON
   ON ([sessions].id = InputJSON.id)
WHEN MATCHED THEN
    UPDATE SET [sessions].CustomerId = InputJSON.CustomerId,
               [sessions].InteractionId = InputJSON.InteractionId,
			   [sessions].DateandTimeOfsession = InputJSON.DateandTimeOfSession,
			   [sessions].VenuePostCode = InputJSON.VenuePostCode,
			   [sessions].SessionAttended = InputJSON.SessionAttended,
			   [sessions].REasonForNonAttendance = InputJSON.ReasonForNonAttendance,			   
			   [sessions].LastModifiedDate = InputJSON.LastModifiedDate,
			   [sessions].LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId               
WHEN NOT MATCHED THEN
    INSERT (id, CustomerId, InteractionId, DateandTimeOfSession, VenuePostCode, SessionAttended, ReasonForNonAttendance, LastModifiedDate, LastModifiedTouchpointId)
    VALUES (InputJSON.id, InputJSON.CustomerId, InputJSON.InteractionId, InputJSON.DateandTimeOfSession, InputJSON.VenuePostCode, InputJSON.SessionAttended, InputJSON.ReasonForNonAttendance, InputJSON.LastModifiedDate, InputJSON.LastModifiedTouchpointId);
END

GO
