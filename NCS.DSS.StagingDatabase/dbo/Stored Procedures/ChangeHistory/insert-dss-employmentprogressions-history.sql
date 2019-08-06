CREATE PROCEDURE [dbo].[insert-dss-employmentprogressions-history] (@Json NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO [dss-employmentprogressions-history]	
	SELECT DATEADD(MINUTE, _ts/60, DATEADD(SECOND, _ts%60, '19700101')) as CosmosTimeStamp, id, CustomerId, DateProgressionRecorded, CurrentEmploymentStatus, EconomicShockStatus,
	EconomicShockCode, EmployerName, EmployerAddress, EmployerPostcode, Longitude, Latitude, EmploymentHours, DateOfEmployment, DateOfLastEmployment, LengthOfUnemployment, LastModifiedDate,
	LastModifiedTouchpointId, CreatedBy		  
	FROM OPENJSON(@Json)
		WITH (	
				_ts bigint 			
				,id UNIQUEIDENTIFIER
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
END