CREATE PROCEDURE [dbo].[insert-dss-learningprogressions-history] (@Json NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO [dss-learningprogressions-history]	
	SELECT DATEADD(MINUTE, _ts/60, DATEADD(SECOND, _ts%60, '19700101')) as CosmosTimeStamp, id, CustomerId, DateProgressionRecorded, CurrentLearningStatus, LearningHours,
	DateLearningStarted, CurrentQualificationLevel, DateQualificationLevelAchieved, LastLearningProvidersUKPRN, LastModifiedDate, LastModifiedTouchpointId, CreatedBy		  
	FROM OPENJSON(@Json)
		WITH (	
				_ts bigint 			
				,id UNIQUEIDENTIFIER 
				,CustomerId UNIQUEIDENTIFIER 
				,DateProgressionRecorded DATETIME2        
				,CurrentLearningStatus INT              
				,LearningHours INT			   
				,DateLearningStarted DATETIME2        
				,CurrentQualificationLevel INT              
				,DateQualificationLevelAchieved DATETIME2        
				,LastLearningProvidersUKPRN VARCHAR (MAX)    
				,LastModifiedDate DATETIME2        
				,LastModifiedTouchpointId VARCHAR (MAX)    
				,CreatedBy VARCHAR (MAX)     
			)
END