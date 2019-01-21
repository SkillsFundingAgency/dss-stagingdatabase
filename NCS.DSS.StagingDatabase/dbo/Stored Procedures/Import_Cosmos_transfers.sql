CREATE PROCEDURE [dbo].[Import_Cosmos_transfers]

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
						 [id] [varchar](50) NULL,
						 [CustomerId] [varchar](50) NULL,
						 [InteractionId] [varchar](50) NULL,
						 [OriginatingTouchpointId] [varchar](50) NULL,
						 [TargetTouchpointId] [varchar](50) NULL,	
						 [Context] [varchar](50) NULL,
						 [DateandTimeOfTransfer] [varchar](50) NULL,
						 [DateandTimeofTransferAccepted] [varchar](50) NULL,
						 [RequestedCallbackTime] [varchar](50) NULL,
						 [ActualCallbackTime] [varchar](50) NULL,
						 [LastModifiedDate] [varchar](50) NULL,
						 [LastModifiedTouchpointId] [varchar](50) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#transfers]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(50) '$.id',
			CustomerId VARCHAR(50) '$.CustomerId',
			InteractionId VARCHAR(50) '$.InteractionId',
			OriginatingTouchpointId VARCHAR(50) '$.OriginatingTouchpointId',
			TargetTouchpointId VARCHAR(50) '$.TargetTouchpointId',
			Context VARCHAR(50) '$.Context',
			DateandTimeOfTransfer VARCHAR(50) '$.DateandTimeOfTransfer',
			DateandTimeofTransferAccepted VARCHAR(50) '$.DateandTimeofTransferAccepted',
			RequestedCallbackTime VARCHAR(50) '$.RequestedCallbackTime',
			ActualCallbackTime VARCHAR(50) '$.ActualCallbackTime',
			LastModifiedDate VARCHAR(50) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(50) '$.LastModifiedTouchpointId'
			) as Coll

	
	IF OBJECT_ID('[dss-transfers]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-transfers]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-transfers](
						 [id] uniqueidentifier NULL,
						 [CustomerId] uniqueidentifier NULL,
						 [InteractionId] uniqueidentifier NULL,
						 [OriginatingTouchpointId] [varchar](10) NULL,
						 [TargetTouchpointId] [varchar](10) NULL,	
						 [Context] [varchar](50) NULL,
						 [DateandTimeOfTransfer] datetime NULL,
						 [DateandTimeofTransferAccepted] datetime NULL,
						 [RequestedCallbackTime] datetime NULL,
						 [ActualCallbackTime] datetime NULL,
						 [LastModifiedDate] datetime NULL,
						 [LastModifiedTouchpointId] [varchar](10) NULL) 
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
