CREATE PROCEDURE [dbo].[Import_Cosmos_webchats]

	@JsonFile NVarchar(Max),
	@DataSource NVarchar(max)
AS
BEGIN
	SET CONCAT_NULL_YIELDS_NULL OFF
	SET NOCOUNT ON
	
	DECLARE @ORowSet AS NVarchar(max)
	DECLARE @retvalue NVarchar(max)  
	DECLARE @ParmDef NVarchar(50);
	
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
						 [id] [varchar](50) NULL,
						 [CustomerId] [varchar](50) NULL,
						 [InteractionId] [varchar](50) NULL,
						 [DigitalReference] [varchar](50) NULL,
						 [WebChatStartDateandTime] [varchar](50) NULL,	
						 [WebChatEndDateandTime] [varchar](50) NULL,
						 [WebChatDuration] [varchar](50) NULL,
						 [WebChatNarrative] [varchar](50) NULL,
						 [SentToCustomer] [varchar](50) NULL,
						 [DateandTimeSentToCustomers] [varchar](50) NULL,
						 [LastModifiedDate] [varchar](50) NULL,
						 [LastModifiedTouchpointId] [varchar](50) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#webchats]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(50) '$.id',
			CustomerId VARCHAR(50) '$.CustomerId',
			InteractionId VARCHAR(50) '$.InteractionId',
			DigitalReference VARCHAR(50) '$.DigitalReference',
			WebChatStartDateandTime VARCHAR(50) '$.WebChatStartDateandTime',
			WebChatEndDateandTime VARCHAR(50) '$.WebChatEndDateandTime',
			WebChatDuration VARCHAR(50) '$.WebChatDuration',
			WebChatNarrative VARCHAR(50) '$.WebChatNarrative',
			SentToCustomer VARCHAR(50) '$.SentToCustomer',
			DateandTimeSentToCustomers VARCHAR(50) '$.DateandTimeSentToCustomers',
			LastModifiedDate VARCHAR(50) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(50) '$.LastModifiedTouchpointId'
			) as Coll

	IF OBJECT_ID('[dss-webchats]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-webchats]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-webchats](
						 [id] uniqueidentifier NULL,
						 [CustomerId] uniqueidentifier NULL,
						 [InteractionId] uniqueidentifier NULL,
						 [DigitalReference] [varchar](50) NULL,
						 [WebChatStartDateandTime] datetime NULL,	
						 [WebChatEndDateandTime] datetime NULL,
						 [WebChatDuration] time NULL,
						 [WebChatNarrative] [varchar](50) NULL,
						 [SentToCustomer] bit NULL,
						 [DateandTimeSentToCustomers] datetime NULL,
						 [LastModifiedDate] datetime NULL,
						 [LastModifiedTouchpointId] [varchar](10) NULL) 
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
