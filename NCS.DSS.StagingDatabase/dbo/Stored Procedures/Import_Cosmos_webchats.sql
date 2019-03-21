CREATE PROCEDURE [dbo].[Import_Cosmos_webchats]

	@JsonFile NVarchar(Max),
	@DataSource NVarchar(max)
AS
BEGIN
	SET CONCAT_NULL_YIELDS_NULL OFF
	SET NOCOUNT ON
	
	DECLARE @ORowSet AS NVarchar(max)
	DECLARE @retvalue NVarchar(max)  
	DECLARE @ParmDef NVARCHAR(MAX);
	
	SET @ORowSet = '(SELECT @retvalOUT = [BulkColumn] FROM 
					OPENROWSET (BULK ''' + @JsonFile + ''', 
					DATA_SOURCE = ''' + @DataSource + ''', 
					SINGLE_CLOB) 
					as Webchats)'
	
	SET @ParmDef = N'@retvalOUT NVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

    IF OBJECT_ID('#webchats', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE #webchats
		END
	ELSE
		BEGIN
			CREATE TABLE [#webchats](
						 [id] [varchar](max) NULL,
						 [CustomerId] [varchar](max) NULL,
						 [InteractionId] [varchar](max) NULL,
						 [DigitalReference] [varchar](max) NULL,
						 [WebChatStartDateandTime] [varchar](max) NULL,	
						 [WebChatEndDateandTime] [varchar](max) NULL,
						 [WebChatDuration] [varchar](max) NULL,
						 [WebChatNarrative] [varchar](max) NULL,
						 [SentToCustomer] [varchar](max) NULL,
						 [DateandTimeSentToCustomers] [varchar](max) NULL,
						 [LastModifiedDate] [varchar](max) NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#webchats]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(MAX) '$.id',
			CustomerId VARCHAR(MAX) '$.CustomerId',
			InteractionId VARCHAR(MAX) '$.InteractionId',
			DigitalReference VARCHAR(MAX) '$.DigitalReference',
			WebChatStartDateandTime VARCHAR(MAX) '$.WebChatStartDateandTime',
			WebChatEndDateandTime VARCHAR(MAX) '$.WebChatEndDateandTime',
			WebChatDuration VARCHAR(MAX) '$.WebChatDuration',
			WebChatNarrative VARCHAR(MAX) '$.WebChatNarrative',
			SentToCustomer VARCHAR(MAX) '$.SentToCustomer',
			DateandTimeSentToCustomers VARCHAR(MAX) '$.DateandTimeSentToCustomers',
			LastModifiedDate VARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(MAX) '$.LastModifiedTouchpointId'
			) as Coll

	IF OBJECT_ID('[dss-webchats]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-webchats]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-webchats](
						 [id] uniqueidentifier,
						 [CustomerId] uniqueidentifier NULL,
						 [InteractionId] uniqueidentifier NULL,
						 [DigitalReference] [varchar](max) NULL,
						 [WebChatStartDateandTime] datetime2 NULL,	
						 [WebChatEndDateandTime] datetime2 NULL,
						 [WebChatDuration] time NULL,
						 [WebChatNarrative] [varchar](max) NULL,
						 [SentToCustomer] bit NULL,
						 [DateandTimeSentToCustomers] datetime2 NULL,
						 [LastModifiedDate] datetime2 NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL,
						 CONSTRAINT [PK_dss-webchats] PRIMARY KEY ([id])) 
						 ON [PRIMARY]
		END

		INSERT INTO [dss-webchats] 
				SELECT
				CONVERT(uniqueidentifier, [id]) as [id],
				CONVERT(uniqueidentifier, [CustomerId]) as [CustomerId],
				CONVERT(uniqueidentifier, [InteractionId]) as [InteractionId],
				[DigitalReference],	
				CONVERT(datetime2, [WebChatStartDateandTime]) as [WebChatStartDateandTime],
				CONVERT(datetime2, [WebChatEndDateandTime]) as [WebChatEndDateandTime],
				CONVERT(time, [WebChatDuration]) as [WebChatDuration],
				[WebChatNarrative],
				CONVERT(bit, [SentToCustomer]) as [SentToCustomer],
				CONVERT(datetime2, [DateandTimeSentToCustomers]) as [DateandTimeSentToCustomers],
				CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
				[LastModifiedTouchpointId]
				FROM #webchats
		
		DROP TABLE #webchats

END
