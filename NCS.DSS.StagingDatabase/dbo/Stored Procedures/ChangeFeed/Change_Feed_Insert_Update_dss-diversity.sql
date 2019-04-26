CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-diversity] (@Json NVARCHAR(MAX))
AS
BEGIN
	MERGE INTO [dss-diversitydetails] AS diversity
	USING (
		SELECT *
		FROM OPENJSON(@Json) WITH (
				id UNIQUEIDENTIFIER
				,CustomerId uniqueidentifier
				,ConsentToCollectLLDDHealth bit
				,LearningDifficultyOrDisabilityDeclaration int
				,PrimaryLearningDifficultyOrDisability int
				,SecondaryLearningDifficultyOrDisability int
				,DateAndTimeLLDDHealthConsentCollected datetime2
				,ConsentToCollectEthnicity bit
				,Ethnicity int
				,DateAndTimeEthnicityCollected datetime2
				,LastModifiedDate datetime2
				,LastModifiedTouchpointId varchar(max)
				)
		) AS InputJSON
		ON (diversity.id = InputJSON.id)
	WHEN MATCHED
		THEN
			UPDATE
			SET diversity.id = InputJSON.id
				,diversity.CustomerId = InputJSON.CustomerId
				,diversity.ConsentToCollectLLDDHealth = InputJSON.ConsentToCollectLLDDHealth
				,diversity.LearningDifficultyOrDisabilityDeclaration = InputJSON.LearningDifficultyOrDisabilityDeclaration
				,diversity.PrimaryLearningDifficultyOrDisability = InputJSON.PrimaryLearningDifficultyOrDisability
				,diversity.SecondaryLearningDifficultyOrDisability = InputJSON.SecondaryLearningDifficultyOrDisability
				,diversity.DateAndTimeLLDDHealthConsentCollected = InputJSON.DateAndTimeLLDDHealthConsentCollected
				,diversity.ConsentToCollectEthnicity = InputJSON.ConsentToCollectEthnicity
				,diversity.Ethnicity = InputJSON.Ethnicity
				,diversity.DateAndTimeEthnicityCollected = InputJSON.DateAndTimeEthnicityCollected
				,diversity.LastModifiedDate = InputJSON.LastModifiedDate
				,diversity.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId
	WHEN NOT MATCHED
		THEN
			INSERT (
				id
				,CustomerId
				,ConsentToCollectLLDDHealth
				,LearningDifficultyOrDisabilityDeclaration
				,PrimaryLearningDifficultyOrDisability
				,SecondaryLearningDifficultyOrDisability
				,DateAndTimeLLDDHealthConsentCollected
				,ConsentToCollectEthnicity
				,Ethnicity
				,DateAndTimeEthnicityCollected
				,LastModifiedDate
				,LastModifiedTouchpointId
				)
			VALUES (
				InputJSON.id
				,InputJSON.CustomerId
				,InputJSON.ConsentToCollectLLDDHealth
				,InputJSON.LearningDifficultyOrDisabilityDeclaration
				,InputJSON.PrimaryLearningDifficultyOrDisability
				,InputJSON.SecondaryLearningDifficultyOrDisability
				,InputJSON.DateAndTimeLLDDHealthConsentCollected
				,InputJSON.ConsentToCollectEthnicity
				,InputJSON.Ethnicity
				,InputJSON.DateAndTimeEthnicityCollected
				,InputJSON.LastModifiedDate
				,InputJSON.LastModifiedTouchpointId
				);

	exec [dbo].[insert-dss-diversitydetails-history] @Json
END