CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-interactions] (@Json NVARCHAR(MAX))
AS
BEGIN
	MERGE INTO [dss-interactions] AS dssinteractions
	USING (
		SELECT *
		FROM OPENJSON(@Json) WITH (
				id UNIQUEIDENTIFIER,
				CustomerId UNIQUEIDENTIFIER,
				TouchpointId VARCHAR(Max),
				AdviserDetailsId UNIQUEIDENTIFIER,
				DateandTimeOfInteraction DATETIME2,
				Channel INT,
				InteractionType INT,					 
				LastModifiedDate DATETIME2,
				LastModifiedTouchpointId VARCHAR(Max)
				)
		) AS InputJSON
		ON (dssinteractions.id = InputJSON.id)
	WHEN MATCHED
		THEN
			UPDATE
			SET dssinteractions.id = InputJSON.id
				,dssinteractions.CustomerId = InputJSON.CustomerId
				,dssinteractions.TouchpointId = InputJSON.TouchpointId
				,dssinteractions.AdviserDetailsId = InputJSON.AdviserDetailsId
				,dssinteractions.DateandTimeOfInteraction = InputJSON.DateandTimeOfInteraction
				,dssinteractions.Channel = InputJSON.Channel
				,dssinteractions.InteractionType = InputJSON.InteractionType
				,dssinteractions.LastModifiedDate = InputJSON.LastModifiedDate
				,dssinteractions.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId
	WHEN NOT MATCHED
		THEN
			INSERT (
				 id
				,CustomerId
				,TouchpointId
				,AdviserDetailsId
				,DateandTimeOfInteraction
				,Channel
				,InteractionType
				,LastModifiedDate
				,LastModifiedTouchpointId
				)
			VALUES (
				 InputJSON.id
				,InputJSON.TouchpointId
				,InputJSON.AdviserDetailsId
				,InputJSON.DateandTimeOfInteraction
				,InputJSON.Channel
				,InputJSON.InteractionType
				,InputJSON.LastModifiedDate
				,InputJSON.LastModifiedTouchpointId
				);

	exec [dbo].[insert-dss-interactions-history] @Json
END