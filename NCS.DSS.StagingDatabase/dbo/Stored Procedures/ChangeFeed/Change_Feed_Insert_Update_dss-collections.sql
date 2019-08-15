CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-collections] (@Json NVARCHAR(MAX))
AS
BEGIN
	MERGE INTO [dss-collections] AS collections
	USING (
		SELECT *
		FROM OPENJSON(@Json) WITH (
				id UNIQUEIDENTIFIER
				,CollectionReports VARCHAR(MAX)
				,TouchpointId VARCHAR(MAX)
				,Ukprn VARCHAR(MAX)
				,LastModifiedDate DATETIME2
				)
		) AS InputJSON
		ON (collections.id = InputJSON.id)
	WHEN MATCHED
		THEN

			UPDATE
			SET collections.id = InputJSON.id
				,collections.CollectionReports = InputJSON.CollectionReports
				,collections.TouchpointId = InputJSON.TouchpointId
				,collections.Ukprn = InputJSON.Ukprn
				,collections.LastModifiedDate = InputJSON.LastModifiedDate

	WHEN NOT MATCHED
		THEN
			INSERT (
				id
				,CollectionReports
				,TouchpointId
				,Ukprn				
				,LastModifiedDate				
				)
			VALUES (
				InputJSON.id
				,InputJSON.CollectionReports
				,InputJSON.TouchpointId
				,InputJSON.Ukprn
				,InputJSON.LastModifiedDate
				);

	exec [insert-dss-collections-history] @Json  
END