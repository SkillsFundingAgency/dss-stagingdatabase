CREATE PROCEDURE [dbo].[Import_Cosmos_sessions]

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
						 [id] [varchar](50) NULL,
						 [CustomerId] [varchar](50) NULL,
						 [InteractionId] [varchar](50) NULL,
						 [DateandTimeOfSession] [varchar](50) NULL,
						 [VenuePostCode] [varchar](50) NULL,
						 [SessionAttended] [varchar](50) NULL,
						 [ReasonForNonAttendance] [varchar](50) NULL,					 
						 [LastModifiedDate] [varchar](50) NULL,
						 [LastModifiedTouchpointId] [varchar](50) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#sessions]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(50) '$.id', 
			CustomerId VARCHAR(50) '$.CustomerId',
			InteractionId VARCHAR(50) '$.InteractionId',
			DateandTimeOfSession VARCHAR(50) '$.DateandTimeOfSession',
			VenuePostCode VARCHAR(50) '$.VenuePostCode',
			SessionAttended VARCHAR(50) '$.SessionAttended',
			ReasonForNonAttendance VARCHAR(50) '$.ReasonForNonAttendance',
			LastModifiedDate VARCHAR(50) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(50) '$.LastModifiedTouchpointId'
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
						 [LastModifiedTouchpointId] [varchar](10) NULL) 
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
