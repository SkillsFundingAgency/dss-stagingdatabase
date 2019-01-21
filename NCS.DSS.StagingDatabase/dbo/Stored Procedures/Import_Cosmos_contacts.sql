CREATE PROCEDURE [dbo].[Import_Cosmos_contacts]

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
						 [id] [varchar](50) NULL,
						 [CustomerId] [varchar](50) NULL,
						 [PreferredContactMethod] [varchar](50) NULL,
						 [MobileNumber] [varchar](50) NULL,
						 [HomeNumber] [varchar](50) NULL,
						 [AlternativeNumber] [varchar](50) NULL,
						 [EmailAddress] [varchar](50) NULL,
						 [LastModifiedDate] [varchar](50) NULL,
						 [LastModifiedTouchpointId] [varchar](50) NULL
			) ON [PRIMARY]									
		END

	INSERT INTO [#contacts]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(50) '$.id', 
			CustomerId VARCHAR(50) '$.CustomerId',
			PreferredContactMethod VARCHAR(50) '$.PreferredContactMethod',
			MobileNumber VARCHAR(50) '$.MobileNumber',
			HomeNumber VARCHAR(50) '$.HomeNumber',
			AlternativeNumber VARCHAR(50) '$.AlternativeNumber',
			EmailAddress VARCHAR(50) '$.EmailAddress',
			LastModifiedDate VARCHAR(50) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(50) '$.LastModifiedTouchpointId'
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
						 [MobileNumber] [varchar](50) NULL,
						 [HomeNumber] [varchar](50) NULL,
						 [AlternativeNumber] [varchar](50) NULL,
						 [EmailAddress] [varchar](50) NULL,
						 [LastModifiedDate] datetime NULL,
						 [LastModifiedTouchpointId] [varchar](10) NULL) 
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
