CREATE PROCEDURE [dbo].[Import_Cosmos_subscriptions]

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
					as Subscriptions)'
	
	SET @ParmDef = N'@retvalOUT NVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

    IF OBJECT_ID('#subscriptions', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE #subscriptions
		END
	ELSE
		BEGIN
			CREATE TABLE [#subscriptions](
						 [CustomerId] [varchar](max) NULL,
						 [SubscriptionId] [varchar](max) NULL,
						 [TouchPointId] [varchar](max) NULL,
						 [Subscribe] [varchar](max) NULL,			 
						 [LastModifiedDate] [varchar](max) NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#subscriptions]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			CustomerId VARCHAR(MAX) '$.CustomerId',
			SubscriptionId VARCHAR(MAX) '$.SubscriptionId',
			TouchPointId VARCHAR(MAX) '$.TouchPointId',
			Subscribe VARCHAR(MAX) '$.Subscribe',
			LastModifiedDate VARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(MAX) '$.LastModifiedTouchpointId'
			) as Coll


	IF OBJECT_ID('[dss-subscriptions]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-subscriptions]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-subscriptions](
						 [CustomerId] uniqueidentifier NULL,
						 [SubscriptionId] uniqueidentifier NULL,
						 [TouchPointId] [varchar](max) NULL,
						 [Subscribe] bit NULL,			 
						 [LastModifiedDate] datetime NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL) 
						 ON [PRIMARY]
		END

		INSERT INTO [dss-subscriptions] 
				SELECT
				CONVERT(uniqueidentifier, [CustomerId]) as [CustomerId],
				CONVERT(uniqueidentifier, [SubscriptionId]) as [SubscriptionId],
				[TouchPointId],
				CONVERT(bit, [Subscribe]) as [Subscribe],
				CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
				[LastModifiedTouchpointId]
				FROM #subscriptions


		DROP TABLE #subscriptions
END
