CREATE PROCEDURE [dbo].[Import_Cosmos_digitalidentities]

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
					as digitalidentities)'
	
	SET @ParmDef = N'@retvalOUT NVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

    IF OBJECT_ID('#digitalidentities', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE #digitalidentities
		END
	ELSE
		BEGIN
			CREATE TABLE [#digitalidentities](
						 [id] [varchar](max),
						 [CustomerId] [varchar](max) NULL,
						 [IdentityStoreId] [varchar](max) NULL,
						 [LegacyIdentity] [varchar](max) NULL,
						 [id_token] [varchar](max) NULL,
						 [LastLoggedInDateTime] [varchar](max) NULL,
						 [LastModifiedDate] [varchar](max) NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL,
						 [DateOfClosure] [varchar](max) NULL,
						 [CreatedBy] [varchar](max) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#digitalidentities]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(MAX) '$.id', 
			CustomerId VARCHAR(MAX) '$.CustomerId',
			IdentityStoreId VARCHAR(MAX) '$.IdentityStoreId',
			LegacyIdentity VARCHAR(MAX) '$.LegacyIdentity',
			id_token VARCHAR(MAX) '$.id_token',
			LastLoggedInDateTime VARCHAR(MAX) '$.LastLoggedInDateTime',
			LastModifiedDate VARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(MAX) '$.LastModifiedTouchpointId',
			DateOfClosure NVARCHAR(MAX) '$.DateOfClosure',
			CreatedBy VARCHAR(MAX) '$.CreatedBy'
			) AS Coll




	IF OBJECT_ID('[dss-digitalidentities]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-digitalidentities]
		END
	ELSE
		BEGIN
			CREATE TABLE [dbo].[dss-digitalidentities] (
				[id]                         UNIQUEIDENTIFIER   NOT NULL,
				[CustomerId]		         UNIQUEIDENTIFIER   NOT NULL,
				[IdentityStoreId]		     UNIQUEIDENTIFIER,
				[LegacyIdentity]             VARCHAR (9)        NULL,
				[id_token]                   VARCHAR (max)       NULL,
				[LastLoggedInDateTime]       datetime2          NULL,
				[LastModifiedDate]           datetime2          NULL,
				[LastModifiedTouchpointId]   VARCHAR (max)      NULL, 
				[DateOfClosure]				 datetime2          NULL,
				[CreatedBy]					 VARCHAR (MAX)      NULL, 
				CONSTRAINT [PK_dss-digitalidentities] PRIMARY KEY ([id]))
				ON [PRIMARY]							
		END

		INSERT INTO [dss-digitalidentities] 
				SELECT
				CONVERT(UNIQUEIDENTIFIER, [id]) AS [id],
				CONVERT(UNIQUEIDENTIFIER, [CustomerId]) AS [CustomerId],
				CONVERT(UNIQUEIDENTIFIER, [IdentityStoreId]) AS [IdentityStoreId],
				[LegacyIdentity],
				[id_token],
				CONVERT(datetime2, [LastLoggedInDateTime]) as [LastLoggedInDateTime],
				CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
				[LastModifiedTouchpointId],
				CONVERT(datetime2, [DateOfClosure]) as [DateOfClosure],
				[CreatedBy]
				FROM #digitalidentities

		DROP TABLE #digitalidentities

END
