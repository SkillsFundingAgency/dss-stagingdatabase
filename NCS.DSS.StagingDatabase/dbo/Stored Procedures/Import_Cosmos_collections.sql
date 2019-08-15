CREATE PROCEDURE [dbo].[Import_Cosmos_collections]

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
					as Collections)'
	
	SET @ParmDef = N'@retvalOUT NVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

	CREATE TABLE [#collections](
				[id] [varchar](max) NULL,
				[CollectionReports] [varchar](max) NULL,
				[TouchpointId] [varchar](max) NULL,
				[Ukprn] [varchar](max) NULL,
				[LastModifiedDate] [varchar](max) NULL,
			) ON [PRIMARY]									


	INSERT INTO [#collections]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(MAX) '$.id', 
			CollectionReports VARCHAR(MAX) '$.CollectionReports',
			TouchpointId VARCHAR(MAX) '$.TouchpointId',
			Ukprn VARCHAR(MAX) '$.Ukprn',
			LastModifiedDate VARCHAR(MAX) '$.LastModifiedDate'
			) as Coll

	
	IF OBJECT_ID('[dss-collections]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-collections]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-collections](
						[id]				UNIQUEIDENTIFIER NOT NULL,
						[CollectionReports] VARCHAR (max) NULL,
						[TouchpointId]		VARCHAR (max) NULL,
						[Ukprn]				VARCHAR (max) NULL,
						[LastModifiedDate]	DATETIME2 (7) NULL,
						CONSTRAINT [PK_dss-collections] PRIMARY KEY ([id])) 
			ON [PRIMARY]
		END

		INSERT INTO [dss-collections] 
			SELECT  
			CONVERT(UNIQUEIDENTIFIER, [id]) AS [id],
			[CollectionReports],
			[TouchpointId],
			[Ukprn],
			CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate]
			FROM #collections

		DROP TABLE #collections
		
END