CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-collections] (@Json NVARCHAR(MAX))
AS
BEGIN
	MERGE INTO [dss-collections] AS collections
	USING (
		SELECT *
		FROM OPENJSON(@Json) WITH (
				id UNIQUEIDENTIFIER
				,ContainerName VARCHAR (MAX)
				,ReportFileName VARCHAR (MAX)
				,CollectionReports VARCHAR(MAX)
				,TouchPointId VARCHAR(MAX)
				,Ukprn VARCHAR(MAX)
				,LastModifiedDate DATETIME2
				)
		) AS InputJSON
		ON (collections.id = InputJSON.id)
	WHEN MATCHED
		THEN

			UPDATE
			SET collections.id = InputJSON.id
				,collections.ContainerName = InputJSON.ContainerName
				,collections.ReportFileName = InputJSON.ReportFileName
				,collections.CollectionReports = InputJSON.CollectionReports
				,collections.TouchPointId = InputJSON.TouchPointId
				,collections.Ukprn = InputJSON.Ukprn
				,collections.LastModifiedDate = InputJSON.LastModifiedDate

	WHEN NOT MATCHED
		THEN
			INSERT (
				id
				,ContainerName
				,ReportFileName
				,CollectionReports
				,TouchPointId
				,Ukprn				
				,LastModifiedDate				
				)
			VALUES (
				InputJSON.id
				,InputJSON.ContainerName
				,InputJSON.ReportFileName
				,InputJSON.CollectionReports
				,InputJSON.TouchPointId
				,InputJSON.Ukprn
				,InputJSON.LastModifiedDate
				);

	exec [insert-dss-collections-history] @Json  
END