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
						 [SubcontractorId] [VARCHAR](MAX) NULL,
						 [DateandTimeOfSession] [VARCHAR](MAX) NULL,
						 [VenuePostCode] [VARCHAR](MAX) NULL,
						 [SessionAttended] [VARCHAR](MAX) NULL,
						 [ReasonForNonAttendance] [VARCHAR](MAX) NULL,					 
						 [LastModifiedDate] [VARCHAR](MAX) NULL,
						 [LastModifiedTouchpointId] [VARCHAR](MAX) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#sessions]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(MAX) '$.id', 
			CustomerId VARCHAR(MAX) '$.CustomerId',
			InteractionId VARCHAR(MAX) '$.InteractionId',
			SubcontractorId VARCHAR(MAX) '$.SubcontractorId',
			DateandTimeOfSession VARCHAR(MAX) '$.DateandTimeOfSession',
			VenuePostCode VARCHAR(MAX) '$.VenuePostCode',
			SessionAttended VARCHAR(MAX) '$.SessionAttended',
			ReasonForNonAttendance VARCHAR(MAX) '$.ReasonForNonAttendance',
			LastModifiedDate VARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(MAX) '$.LastModifiedTouchpointId'
			) AS Coll


	IF OBJECT_ID('[dss-sessions]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-sessions]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-sessions](
						 [id] UNIQUEIDENTIFIER,
						 [CustomerId] UNIQUEIDENTIFIER NULL,
						 [InteractionId] UNIQUEIDENTIFIER NULL,
						 [SubcontractorId] varchar(50) NULL,
						 [DateandTimeOfSession] DATETIME2 NULL,
						 [VenuePostCode] [VARCHAR](20) NULL,
						 [SessionAttended] BIT NULL,
						 [ReasonForNonAttendance] INT NULL,					 
						 [LastModifiedDate] DATETIME2 NULL,
						 [LastModifiedTouchpointId] [VARCHAR](MAX) NULL,
						 CONSTRAINT [PK_dss-sessions] PRIMARY KEY ([id])) 
						 ON [PRIMARY]
		END

		INSERT INTO [dss-sessions] 
				SELECT
				CONVERT(UNIQUEIDENTIFIER, [id]) AS [id],
				CONVERT(UNIQUEIDENTIFIER, [CustomerId]) AS [CustomerId],
				CONVERT(UNIQUEIDENTIFIER, [InteractionId]) AS [InteractionId],
				[SubContractorId],
				CONVERT(datetime2, [DateandTimeOfSession]) as [DateandTimeOfSession],
				[VenuePostCode],
				CONVERT(bit, [SessionAttended]) as [SessionAttended],
				CONVERT(int, [ReasonForNonAttendance]) as [ReasonForNonAttendance],
				CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
				[LastModifiedTouchpointId]
				FROM #sessions

		DROP TABLE #sessions

END
