CREATE PROCEDURE [dbo].[Import_Cosmos_transfers]

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
					as Transfers)'
	
	SET @ParmDef = N'@retvalOUT NVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

    IF OBJECT_ID('#transfers', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE #transfers
		END
	ELSE
		BEGIN
			CREATE TABLE [#transfers](
						 [id] [varchar](max) NULL,
						 [CustomerId] [varchar](max) NULL,
						 [InteractionId] [varchar](max) NULL,
						 [OriginatingTouchpointId] [varchar](max) NULL,
						 [TargetTouchpointId] [varchar](max) NULL,	
						 [Context] [varchar](max) NULL,
						 [DateandTimeOfTransfer] [varchar](max) NULL,
						 [DateandTimeofTransferAccepted] [varchar](max) NULL,
						 [RequestedCallbackTime] [varchar](max) NULL,
						 [ActualCallbackTime] [varchar](max) NULL,
						 [LastModifiedDate] [varchar](max) NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#transfers]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(MAX) '$.id',
			CustomerId VARCHAR(MAX) '$.CustomerId',
			InteractionId VARCHAR(MAX) '$.InteractionId',
			OriginatingTouchpointId VARCHAR(MAX) '$.OriginatingTouchpointId',
			TargetTouchpointId VARCHAR(MAX) '$.TargetTouchpointId',
			Context VARCHAR(MAX) '$.Context',
			DateandTimeOfTransfer VARCHAR(MAX) '$.DateandTimeOfTransfer',
			DateandTimeofTransferAccepted VARCHAR(MAX) '$.DateandTimeofTransferAccepted',
			RequestedCallbackTime VARCHAR(MAX) '$.RequestedCallbackTime',
			ActualCallbackTime VARCHAR(MAX) '$.ActualCallbackTime',
			LastModifiedDate VARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(MAX) '$.LastModifiedTouchpointId'
			) as Coll

	
	IF OBJECT_ID('[dss-transfers]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-transfers]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-transfers](
						 [id] uniqueidentifier NOT NULL,
						 [CustomerId] uniqueidentifier NULL,
						 [InteractionId] uniqueidentifier NULL,
						 [OriginatingTouchpointId] [varchar](max) NULL,
						 [TargetTouchpointId] [varchar](max) NULL,	
						 [Context] [varchar](max) NULL,
						 [DateandTimeOfTransfer] datetime2 NULL,
						 [DateandTimeofTransferAccepted] datetime2 NULL,
						 [RequestedCallbackTime] datetime2 NULL,
						 [ActualCallbackTime] datetime2 NULL,
						 [LastModifiedDate] datetime2 NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL,
						 CONSTRAINT [PK_dss-transfers] PRIMARY KEY ([id])) 
						 ON [PRIMARY]
		END

		INSERT INTO [dss-transfers] 
				SELECT
				CONVERT(uniqueidentifier, [id]) as [id],
				CONVERT(uniqueidentifier, [CustomerId]) as [CustomerId],
				CONVERT(uniqueidentifier, [InteractionId]) as [InteractionId],
				[OriginatingTouchpointId],
				[TargetTouchpointId],
				[Context],
				CONVERT(datetime2, [DateandTimeOfTransfer]) as [DateandTimeOfTransfer],
				CONVERT(datetime2, [DateandTimeofTransferAccepted]) as [DateandTimeofTransferAccepted],
				CONVERT(datetime2, [RequestedCallbackTime]) as [RequestedCallbackTime],
				CONVERT(datetime2, [ActualCallbackTime]) as [ActualCallbackTime],
				CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
				[LastModifiedTouchpointId]
				FROM #transfers
		
		DROP TABLE #transfers
END
