CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-webchats] (@Json NVARCHAR(MAX))
AS
BEGIN
	MERGE INTO [dss-webchats] AS dsswebchats
	USING (
		SELECT *
		FROM OPENJSON(@Json) WITH (
				id  UNIQUEIDENTIFIER,
				CustomerId UNIQUEIDENTIFIER,
				InteractionId UNIQUEIDENTIFIER,
				DigitalReference VARCHAR (max),
				WebChatStartDateandTime	datetime2,
				WebChatEndDateandTime datetime2,
				WebChatDuration	TIME (7),
				WebChatNarrative VARCHAR (max),
				SentToCustomer BIT,
				DateandTimeSentToCustomers datetime2,
				LastModifiedDate datetime2,
				LastModifiedTouchpointId VARCHAR (max)  
				)
		) AS InputJSON
		ON (dsswebchats.id = InputJSON.id)
	WHEN MATCHED
		THEN
			UPDATE
			SET dsswebchats.id = InputJSON.id
				,dsswebchats.CustomerId = InputJSON.CustomerId
				,dsswebchats.InteractionId = InputJSON.InteractionId
				,dsswebchats.DigitalReference = InputJSON.DigitalReference
				,dsswebchats.WebChatStartDateandTime = InputJSON.WebChatStartDateandTime
				,dsswebchats.WebChatEndDateandTime = InputJSON.WebChatEndDateandTime
				,dsswebchats.WebChatDuration = InputJSON.WebChatDuration
				,dsswebchats.WebChatNarrative = InputJSON.WebChatNarrative
				,dsswebchats.SentToCustomer = InputJSON.SentToCustomer
				,dsswebchats.DateandTimeSentToCustomers = InputJSON.DateandTimeSentToCustomers
				,dsswebchats.LastModifiedDate = InputJSON.LastModifiedDate
				,dsswebchats.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId
	WHEN NOT MATCHED
		THEN
			INSERT (
				id
				,CustomerId
				,InteractionId
				,DigitalReference
				,WebChatStartDateandTime
				,WebChatEndDateandTime
				,WebChatDuration
				,WebChatNarrative
				,SentToCustomer
				,DateandTimeSentToCustomers
				,LastModifiedDate
				,LastModifiedTouchpointId
				)
			VALUES (
				InputJSON.id
				,InputJSON.CustomerId
				,InputJSON.InteractionId
				,InputJSON.DigitalReference
				,InputJSON.WebChatStartDateandTime
				,InputJSON.WebChatEndDateandTime
				,InputJSON.WebChatDuration
				,InputJSON.WebChatNarrative
				,InputJSON.SentToCustomer
				,InputJSON.DateandTimeSentToCustomers
				,InputJSON.LastModifiedDate
				,InputJSON.LastModifiedTouchpointId
				);

	exec [dbo].[insert-dss-webchats-history] @Json
END