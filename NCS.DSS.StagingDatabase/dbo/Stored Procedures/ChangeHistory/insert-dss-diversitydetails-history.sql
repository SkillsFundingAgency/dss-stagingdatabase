CREATE PROCEDURE [dbo].[insert-dss-diversitydetails-history] (@Json NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO [dss-diversitydetails-history]
		SELECT DATEADD(MINUTE, _ts/60, DATEADD(SECOND, _ts%60, '19700101')) as CosmosTimeStamp, id, CustomerId, ConsentToCollectLLDDHealth, LearningDifficultyOrDisabilityDeclaration, PrimaryLearningDifficultyOrDisability, SecondaryLearningDifficultyOrDisability,
			   DateAndTimeLLDDHealthConsentCollected, ConsentToCollectEthnicity, Ethnicity, DateAndTimeEthnicityCollected, LastModifiedDate, LastModifiedBy
			FROM OPENJSON(@Json) WITH (
				_ts BIGINT
				,id UNIQUEIDENTIFIER
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
				,LastModifiedBy varchar(max)
				)
END