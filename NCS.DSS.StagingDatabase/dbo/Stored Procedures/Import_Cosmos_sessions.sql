CREATE PROCEDURE [dbo].[Import_Cosmos_sessions]

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
					as Sessions)'
	
	SET @ParmDef = N'@retvalOUT NVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

    IF OBJECT_ID('#sessions', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE #sessions
		END
	ELSE
		BEGIN
			CREATE TABLE [#sessions](
						 [id] [varchar](max) NULL,
						 [CustomerId] [varchar](max) NULL,
						 [InteractionId] [varchar](max) NULL,
						 [DateandTimeOfSession] [varchar](max) NULL,
						 [VenuePostCode] [varchar](max) NULL,
						 [SessionAttended] [varchar](max) NULL,
						 [ReasonForNonAttendance] [varchar](max) NULL,					 
						 [LastModifiedDate] [varchar](max) NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#sessions]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(MAX) '$.id', 
			CustomerId VARCHAR(MAX) '$.CustomerId',
			InteractionId VARCHAR(MAX) '$.InteractionId',
			DateandTimeOfSession VARCHAR(MAX) '$.DateandTimeOfSession',
			VenuePostCode VARCHAR(MAX) '$.VenuePostCode',
			SessionAttended VARCHAR(MAX) '$.SessionAttended',
			ReasonForNonAttendance VARCHAR(MAX) '$.ReasonForNonAttendance',
			LastModifiedDate VARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(MAX) '$.LastModifiedTouchpointId'
			) as Coll


	IF OBJECT_ID('[dss-sessions]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-sessions]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-sessions](
						 [id] uniqueidentifier NULL,
						 [CustomerId] uniqueidentifier NULL,
						 [InteractionId] uniqueidentifier NULL,
						 [DateandTimeOfSession] datetime NULL,
						 [VenuePostCode] [varchar](20) NULL,
						 [SessionAttended] bit NULL,
						 [ReasonForNonAttendance] int NULL,					 
						 [LastModifiedDate] datetime NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL) 
						 ON [PRIMARY]
		END

		INSERT INTO [dss-sessions] 
				SELECT
				CONVERT(uniqueidentifier, [id]) as [id],
				CONVERT(uniqueidentifier, [CustomerId]) as [CustomerId],
				CONVERT(uniqueidentifier, [InteractionId]) as [InteractionId],
				CONVERT(datetime2, [DateandTimeOfSession]) as [DateandTimeOfSession],
				[VenuePostCode],
				CONVERT(bit, [SessionAttended]) as [SessionAttended],
				CONVERT(int, [ReasonForNonAttendance]) as [ReasonForNonAttendance],
				CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
				[LastModifiedTouchpointId]
				FROM #sessions

		DROP TABLE #sessions

END
