CREATE PROCEDURE [dbo].[insert-dss-webchats-history] (@Json NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO [dss-webchats-history]	
	SELECT DATEADD(MINUTE, _ts/60, DATEADD(SECOND, _ts%60, '19700101')) as CosmosTimeStamp, id, CustomerId, InteractionId, DigitalReference,
	WebChatStartDateandTime, WebChatEndDateandTime, WebChatDuration, WebChatNarrative, SentToCustomer, DateandTimeSentToCustomers,
	LastModifiedDate, LastModifiedTouchpointId		  
	FROM OPENJSON(@Json)
		WITH (	
				_ts bigint 			
				,id                             UNIQUEIDENTIFIER
				,CustomerId                     UNIQUEIDENTIFIER
				,InteractionId                  UNIQUEIDENTIFIER
				,DigitalReference				VARCHAR (max)     
				,WebChatStartDateandTime		datetime2         
				,WebChatEndDateandTime			datetime2         
				,WebChatDuration				TIME (7)         
				,WebChatNarrative				VARCHAR (max)     
				,SentToCustomer					BIT              
				,DateandTimeSentToCustomers		datetime2         
				,LastModifiedDate				datetime2         
				,LastModifiedTouchpointId		VARCHAR (max)      
			)
END