CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-adviserdetails](@Json NVARCHAR(MAX))
AS BEGIN
MERGE INTO [dss-adviserdetails] AS adviserdetails
USING (
    SELECT *
    FROM  OPENJSON(@Json)
          WITH (Id uniqueidentifier, SubcontractorId varchar(max), AdviserName Varchar(Max), AdviserEmailAddress Varchar(Max), AdviserContactNumber varchar(max),
				LastModifiedDate datetime2, LastModifiedTouchpointId varchar(max))) as InputJSON
   ON (adviserdetails.id = InputJSON.Id)
WHEN MATCHED THEN
    UPDATE SET adviserdetails.SubcontractorId = InputJSON.SubcontractorId,
               adviserdetails.AdviserName = InputJSON.AdviserName,
			   adviserdetails.AdviserEmailAddress = InputJSON.AdviserEmailAddress,
			   adviserdetails.AdviserContactNumber = InputJSON.AdviserContactNumber,
			   adviserdetails.LastModifiedDate = InputJSON.LastModifiedDate,
			   adviserdetails.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId               
WHEN NOT MATCHED THEN
    INSERT (Id, SubcontractorId, AdviserName, AdviserEmailAddress, AdviserContactNumber, LastModifiedDate, LastModifiedTouchpointId)
    VALUES (InputJSON.Id, InputJSON.SubcontractorId, InputJSON.AdviserName, InputJSON.AdviserEmailAddress, InputJSON.AdviserContactNumber, 
	InputJSON.LastModifiedDate, InputJSON.LastModifiedTouchpointId);
END
