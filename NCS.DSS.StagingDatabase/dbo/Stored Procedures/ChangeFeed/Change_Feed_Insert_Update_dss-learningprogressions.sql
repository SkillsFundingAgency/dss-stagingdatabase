CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-learningprogression] (@Json NVARCHAR(MAX))
AS
BEGIN
	MERGE INTO [dss-learningprogression] AS learningprogression
	USING (
		SELECT *
		FROM OPENJSON(@Json) WITH (
				id UNIQUEIDENTIFIER 
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
		) AS InputJSON
		ON (learningprogression.id = InputJSON.id)
	WHEN MATCHED
		THEN
			UPDATE
			SET learningprogression.id = InputJSON.id
				,learningprogression.CustomerId = InputJSON.CustomerId
				,learningprogression.DateProgressionRecorded = InputJSON.DateProgressionRecorded
				,learningprogression.CurrentLearningStatus = InputJSON.CurrentLearningStatus
				,learningprogression.LearningHours = InputJSON.LearningHours
				,learningprogression.DateLearningStarted = InputJSON.DateLearningStarted
				,learningprogression.CurrentQualificationLevel = InputJSON.CurrentQualificationLevel
				,learningprogression.DateQualificationLevelAchieved = InputJSON.DateQualificationLevelAchieved
				,learningprogression.LastLearningProvidersUKPRN = InputJSON.LastLearningProvidersUKPRN
				,learningprogression.LastModifiedDate = InputJSON.LastModifiedDate
				,learningprogression.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId
				,learningprogression.CreatedBy = InputJSON.CreatedBy
	WHEN NOT MATCHED
		THEN
			INSERT (
				id, 
				CustomerId, 
				DateProgressionRecorded, 
				CurrentLearningStatus, 
				LearningHours,
				DateLearningStarted, 
				CurrentQualificationLevel,
				DateQualificationLevelAchieved,
				LastLearningProvidersUKPRN,
				LastModifiedDate,
				LastModifiedTouchpointId, 
				CreatedBy		  
				)
			VALUES (
				InputJSON.id
				,InputJSON.CustomerId
				,InputJSON.DateProgressionRecorded
				,InputJSON.CurrentLearningStatus
				,InputJSON.LearningHours
				,InputJSON.DateLearningStarted
				,InputJSON.CurrentQualificationLevel
				,InputJSON.DateQualificationLevelAchieved
				,InputJSON.LastLearningProvidersUKPRN
				,InputJSON.LastModifiedDate
				,InputJSON.LastModifiedTouchpointId
				,InputJSON.CreatedBy
				);

	exec [insert-dss-learningprogression-history] @Json  
END