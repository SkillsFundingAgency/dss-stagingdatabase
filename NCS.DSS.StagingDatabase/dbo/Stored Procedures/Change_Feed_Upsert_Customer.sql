CREATE PROCEDURE [dbo].[Change_Feed_Upsert_Customer](@CustomerJson NVARCHAR(MAX))
AS BEGIN
MERGE INTO [dss-customers] AS customers
USING (
    SELECT *
    FROM  OPENJSON(@CustomerJson)
          WITH (id uniqueidentifier, DateOfRegistration datetime2, Title int, GivenName varchar(max), FamilyName varchar(max),
                DateofBirth datetime2, Gender int, UniqueLearnerNumber varchar(15), OptInUserResearch bit, DateOfTermination datetime2,
				ReasonForTermination int, IntroducedBy int, IntroducedByAdditionalInfo varchar(max), LastModifiedDate datetime2, LastModifiedTouchpointId varchar(max))) as InputJSON
   ON (customers.id = InputJSON.id)
WHEN MATCHED THEN
    UPDATE SET customers.DateOfRegistration = InputJSON.DateOfRegistration,
               customers.Title = InputJSON.Title,
			   customers.GivenName = InputJSON.GivenName,
			   customers.FamilyName = InputJSON.FamilyName,
			   customers.DateOfBirth = InputJSON.DateOfBirth,
			   customers.Gender = InputJSON.Gender,
			   customers.UniqueLearnerNumber = InputJSON.UniqueLearnerNumber,
			   customers.OptInUserResearch = InputJSON.OptInUserResearch,
			   customers.DateOfTermination = InputJSON.DateOfTermination,
			   customers.ReasonForTermination = InputJSON.ReasonForTermination,
			   customers.IntroducedBy = InputJSON.IntroducedBy,
			   customers.IntroducedByAdditionalInfo = InputJSON.IntroducedByAdditionalInfo,
			   customers.LastModifiedDate = InputJSON.LastModifiedDate,
			   customers.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId               
WHEN NOT MATCHED THEN
    INSERT (id, DateOfRegistration, Title, GivenName, FamilyName, DateofBirth, Gender, UniqueLearnerNumber, OptInUserResearch, DateOfTermination, ReasonForTermination, IntroducedBy, IntroducedByAdditionalInfo, LastModifiedDate, LastModifiedTouchpointId)
    VALUES (InputJSON.id, InputJSON.DateOfRegistration, InputJSON.Title, InputJSON.GivenName, InputJSON.FamilyName, InputJSON.DateofBirth, InputJSON.Gender, InputJSON.UniqueLearnerNumber, InputJSON.OptInUserResearch, InputJSON.DateOfTermination, InputJSON.ReasonForTermination, InputJSON.IntroducedBy, InputJSON.IntroducedByAdditionalInfo, InputJSON.LastModifiedDate, InputJSON.LastModifiedTouchpointId);
END
GO


