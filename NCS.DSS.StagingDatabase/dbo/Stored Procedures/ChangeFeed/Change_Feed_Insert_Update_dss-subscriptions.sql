CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-subscriptions] (@Json NVARCHAR(MAX))
AS
BEGIN
	MERGE INTO [dss-subscriptions] AS dsssubscriptions
	USING (
		SELECT *
		FROM OPENJSON(@Json) WITH (
				id uniqueidentifier,
				CustomerId uniqueidentifier,
				TouchPointId varchar(max),
				Subscribe bit,			 
				LastModifiedDate datetime2,
				LastModifiedTouchpointId varchar(max) 
				)
		) AS InputJSON
		ON (dsssubscriptions.id = InputJSON.id)
	WHEN MATCHED
		THEN
			UPDATE
			SET dsssubscriptions.id = InputJSON.id
				,dsssubscriptions.CustomerId = InputJSON.CustomerId
				,dsssubscriptions.TouchPointId = InputJSON.TouchPointId
				,dsssubscriptions.Subscribe = InputJSON.Subscribe
				,dsssubscriptions.LastModifiedDate = InputJSON.LastModifiedDate
				,dsssubscriptions.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId
	WHEN NOT MATCHED
		THEN
			INSERT (
				id
				,CustomerId
				,TouchPointId
				,Subscribe
				,LastModifiedDate
				,LastModifiedTouchpointId
				)
			VALUES (
				InputJSON.id
				,InputJSON.CustomerId
				,InputJSON.TouchPointId
				,InputJSON.Subscribe
				,InputJSON.LastModifiedDate
				,InputJSON.LastModifiedTouchpointId
				);

	exec [dbo].[insert-dss-subscriptions-history] @Json
END