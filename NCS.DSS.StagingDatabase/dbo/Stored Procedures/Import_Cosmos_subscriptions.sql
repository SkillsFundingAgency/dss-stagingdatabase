CREATE PROCEDURE [dbo].[Import_Cosmos_subscriptions]

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
						 [CustomerId] [varchar](50) NULL,
						 [SubscriptionId] [varchar](50) NULL,
						 [TouchPointId] [varchar](50) NULL,
						 [Subscribe] [varchar](50) NULL,			 
						 [LastModifiedDate] [varchar](50) NULL,
						 [LastModifiedTouchpointId] [varchar](50) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#subscriptions]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			CustomerId VARCHAR(50) '$.CustomerId',
			SubscriptionId VARCHAR(50) '$.SubscriptionId',
			TouchPointId VARCHAR(50) '$.TouchPointId',
			Subscribe VARCHAR(50) '$.Subscribe',
			LastModifiedDate VARCHAR(50) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(50) '$.LastModifiedTouchpointId'
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
						 [TouchPointId] [varchar](10) NULL,
						 [Subscribe] bit NULL,			 
						 [LastModifiedDate] datetime NULL,
						 [LastModifiedTouchpointId] [varchar](10) NULL) 
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
