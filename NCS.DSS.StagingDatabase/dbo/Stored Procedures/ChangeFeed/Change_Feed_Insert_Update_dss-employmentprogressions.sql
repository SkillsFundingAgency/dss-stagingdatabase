CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-employmentprogressions] (@Json NVARCHAR(MAX))
AS
BEGIN
	MERGE INTO [dss-employmentprogressions] AS employmentprogression
	USING (
		SELECT *
		FROM OPENJSON(@Json) WITH (
				id UNIQUEIDENTIFIER
				,CustomerId UNIQUEIDENTIFIER 
				,DateProgressionRecorded DATETIME2        
				,CurrentEmploymentStatus INT              
				,EconomicShockStatus INT              
				,EconomicShockCode VARCHAR (50)    
				,EmployerName VARCHAR (200)    
				,EmployerAddress VARCHAR (500)    
				,EmployerPostcode VARCHAR (10)    
				,Longitude FLOAT (53)       
				,Latitude FLOAT (53)       
				,EmploymentHours INT			 
				,DateOfEmployment DATETIME2        
				,DateOfLastEmployment DATETIME2        
				,LengthOfUnemployment INT              
				,LastModifiedDate DATETIME2        
				,LastModifiedTouchpointId VARCHAR (MAX)    
				,CreatedBy VARCHAR (MAX)   
				)
		) AS InputJSON
		ON (employmentprogression.id = InputJSON.id)
	WHEN MATCHED
		THEN
			UPDATE
			SET employmentprogression.id = InputJSON.id
				,employmentprogression.CustomerId = InputJSON.CustomerId
				,employmentprogression.DateProgressionRecorded = InputJSON.DateProgressionRecorded
				,employmentprogression.CurrentEmploymentStatus = InputJSON.CurrentEmploymentStatus
				,employmentprogression.EconomicShockStatus = InputJSON.EconomicShockStatus
				,employmentprogression.EconomicShockCode = InputJSON.EconomicShockCode
				,employmentprogression.EmployerName = InputJSON.EmployerName
				,employmentprogression.EmployerAddress = InputJSON.EmployerAddress
				,employmentprogression.EmployerPostcode = InputJSON.EmployerPostcode
				,employmentprogression.Longitude = InputJSON.Longitude
				,employmentprogression.Latitude = InputJSON.Latitude
				,employmentprogression.EmploymentHours = InputJSON.EmploymentHours
				,employmentprogression.DateOfEmployment = InputJSON.DateOfEmployment
				,employmentprogression.DateOfLastEmployment = InputJSON.DateOfLastEmployment
				,employmentprogression.LengthOfUnemployment = InputJSON.LengthOfUnemployment
				,employmentprogression.LastModifiedDate = InputJSON.LastModifiedDate
				,employmentprogression.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId
				,employmentprogression.CreatedBy = InputJSON.CreatedBy
	WHEN NOT MATCHED
		THEN
			INSERT (
				id, 
				CustomerId, 
				DateProgressionRecorded, 
				CurrentEmploymentStatus, 
				EconomicShockStatus,
				EconomicShockCode, 
				EmployerName, 
				EmployerAddress, 
				EmployerPostcode,
				Longitude, 
				Latitude, 
				EmploymentHours,
				DateOfEmployment, 
				DateOfLastEmployment,
				LengthOfUnemployment,
				LastModifiedDate,
				LastModifiedTouchpointId, 
				CreatedBy		  
				)
			VALUES (
				InputJSON.id
				,InputJSON.CustomerId
				,InputJSON.DateProgressionRecorded
				,InputJSON.CurrentEmploymentStatus
				,InputJSON.EconomicShockStatus
				,InputJSON.EconomicShockCode
				,InputJSON.EmployerName
				,InputJSON.EmployerAddress
				,InputJSON.EmployerPostcode
				,InputJSON.Longitude
				,InputJSON.Latitude
				,InputJSON.EmploymentHours
				,InputJSON.DateOfEmployment
				,InputJSON.DateOfLastEmployment
				,InputJSON.LengthOfUnemployment
				,InputJSON.LastModifiedDate
				,InputJSON.LastModifiedTouchpointId
				,InputJSON.CreatedBy
				);

	exec [insert-dss-employmentprogressions-history] @Json  
END