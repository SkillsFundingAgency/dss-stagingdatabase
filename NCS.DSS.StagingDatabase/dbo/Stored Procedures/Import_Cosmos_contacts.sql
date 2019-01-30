CREATE PROCEDURE [dbo].[Import_Cosmos_contacts]

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
					as Contacts)'
	
	SET @ParmDef = N'@retvalOUT NVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

    IF OBJECT_ID('#contacts', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE #contacts
		END
	ELSE
		BEGIN
			CREATE TABLE [#contacts](
						 [id] [varchar](max) NULL,
						 [CustomerId] [varchar](max) NULL,
						 [PreferredContactMethod] [varchar](max) NULL,
						 [MobileNumber] [varchar](max) NULL,
						 [HomeNumber] [varchar](max) NULL,
						 [AlternativeNumber] [varchar](max) NULL,
						 [EmailAddress] [varchar](max) NULL,
						 [LastModifiedDate] [varchar](max) NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#contacts]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(MAX) '$.id', 
			CustomerId VARCHAR(MAX) '$.CustomerId',
			PreferredContactMethod VARCHAR(MAX) '$.PreferredContactMethod',
			MobileNumber VARCHAR(MAX) '$.MobileNumber',
			HomeNumber VARCHAR(MAX) '$.HomeNumber',
			AlternativeNumber VARCHAR(MAX) '$.AlternativeNumber',
			EmailAddress VARCHAR(MAX) '$.EmailAddress',
			LastModifiedDate VARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(MAX) '$.LastModifiedTouchpointId'
			) as Coll



	IF OBJECT_ID('[dss-contacts]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-contacts]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-contacts](
						 [id] uniqueidentifier NULL,
						 [CustomerId] uniqueidentifier NULL,
						 [PreferredContactMethod] int NULL,
						 [MobileNumber] [varchar](max) NULL,
						 [HomeNumber] [varchar](max) NULL,
						 [AlternativeNumber] [varchar](max) NULL,
						 [EmailAddress] [varchar](max) NULL,
						 [LastModifiedDate] datetime2 NULL,
						 [LastModifiedTouchpointId] [varchar](max) NULL) 
						 ON [PRIMARY]		
		END


		INSERT INTO [dss-contacts] 
				SELECT
				CONVERT(uniqueidentifier, [id]) as [id],
				CONVERT(uniqueidentifier, [CustomerId]) as [CustomerId],
				CONVERT(int, [PreferredContactMethod]) as [PreferredContactMethod],
				[MobileNumber],
				[HomeNumber],
				[AlternativeNumber],
				[EmailAddress],
				CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
				[LastModifiedTouchpointId]
				FROM #contacts

		DROP TABLE #contacts
END
