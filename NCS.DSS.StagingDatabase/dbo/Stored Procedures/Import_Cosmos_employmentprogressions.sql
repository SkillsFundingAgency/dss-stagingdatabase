CREATE PROCEDURE [dbo].[Import_Cosmos_employmentprogressions]

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
					as EmploymentProgressions)'
	
	SET @ParmDef = N'@retvalOUT NVARCHAR(MAX) OUTPUT';
 
	EXEC sp_executesql @ORowSet, @ParmDef, @retvalOUT=@retvalue OUTPUT;

	CREATE TABLE [#employmentprogressions](
				[id] [varchar](max) NULL,
				[CustomerId] [varchar](max) NULL,
				[DateProgressionRecorded] [varchar](max) NULL,
				[CurrentEmploymentStatus] [VARCHAR](MAX) NULL,
				[EconomicShockStatus] [VARCHAR] (MAX) NULL,
				[EconomicShockCode] [varchar](max) NULL,
				[EmployerName] [varchar](max) NULL,
				[EmployerAddress] [varchar](max) NULL,
				[EmployerPostcode] [varchar](max) NULL,
				[Longitude] [varchar](max) NULL,
				[Latitude] [varchar](max) NULL,
				[EmploymentHours] [varchar](max) NULL,
				[DateOfEmployment] [varchar](max) NULL,
				[LengthOfUnemployment] [varchar](max) NULL,
				[LastModifiedDate] [varchar](max) NULL,
				[LastModifiedTouchpointId] [varchar](max) NULL,
				[CreatedBy] [varchar](max) NULL
			) ON [PRIMARY]									


	INSERT INTO [#employmentprogressions]
	SELECT *
	FROM OPENJSON(@retvalue)
		WITH (
			id VARCHAR(MAX) '$.id', 
			CustomerId VARCHAR(MAX) '$.CustomerId',
			DateProgressionRecorded VARCHAR(MAX) '$.DateProgressionRecorded',
			CurrentEmploymentStatus VARCHAR(MAX) '$.CurrentEmploymentStatus',
			EconomicShockStatus VARCHAR(MAX) '$.EconomicShockStatus',
			EconomicShockCode VARCHAR(MAX) '$.EconomicShockCode',
			EmployerName VARCHAR(MAX) '$.EmployerName',
			EmployerAddress VARCHAR(MAX) '$.EmployerAddress',
			EmployerPostcode VARCHAR(MAX) '$.EmployerPostcode',
			Longitude VARCHAR(MAX) '$.Longitude',
			Latitude VARCHAR(MAX) '$.Latitude',
			EmploymentHours VARCHAR(MAX) '$.EmploymentHours',
			DateOfEmployment VARCHAR(MAX) '$.DateOfEmployment',
			DateOfLastEmployment VARCHAR(MAX) '$.DateOfLastEmployment',
			LengthOfUnemployment VARCHAR(MAX) '$.LengthOfUnemployment',
			LastModifiedDate VARCHAR(MAX) '$.LastModifiedDate',
			LastModifiedTouchpointId VARCHAR(MAX) '$.LastModifiedTouchpointId',
			CreatedBy VARCHAR(MAX) '$.CreatedBy'
			) as Coll

	
	IF OBJECT_ID('[dss-employmentprogressions]', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-employmentprogressions]
		END
	ELSE
		BEGIN
			CREATE TABLE [dss-employmentprogressions](
						[id]                             UNIQUEIDENTIFIER NOT NULL,
						[CustomerId]                     UNIQUEIDENTIFIER NULL,
						[DateProgressionRecorded]        DATETIME2        NULL,
						[CurrentEmploymentStatus]		 INT              NULL,
						[EconomicShockStatus]			 INT              NULL,
						[EconomicShockCode]				 VARCHAR (50)     NULL,
						[EmployerName]					 VARCHAR (200)    NULL,
						[EmployerAddress]				 VARCHAR (500)    NULL,
						[EmployerPostcode]               VARCHAR (10)     NULL,
						[Longitude]						 FLOAT (53)       NULL,
						[Latitude]						 FLOAT (53)       NULL,
						[EmploymentHours]				 INT			  NULL,
						[DateOfEmployment]				 DATETIME2        NULL,
						[DateOfLastEmployment]			 DATETIME2        NULL,
						[LengthOfUnemployment]			 INT              NULL,
						[LastModifiedDate]               DATETIME2        NULL,
						[LastModifiedTouchpointId]       VARCHAR (MAX)    NULL, 
						[CreatedBy]					     VARCHAR (MAX)    NULL,
						CONSTRAINT [PK_dss-employmentprogressions] PRIMARY KEY ([id])) 
			ON [PRIMARY]
		END

		INSERT INTO [dss-employmentprogressions] 
			SELECT  
			CONVERT(UNIQUEIDENTIFIER, [id]) AS [id],
			CONVERT(UNIQUEIDENTIFIER, [CustomerId]) AS [CustomerId],
			CONVERT(datetime2, [DateProgressionRecorded]) as [DateProgressionRecorded],
			CONVERT(int, [CurrentEmploymentStatus]) as [CurrentEmploymentStatus],
			CONVERT(int, [EconomicShockStatus]) as [EconomicShockStatus],
			[EconomicShockCode],
			[EmployerName],
			[EmployerAddress],
			[EmployerPostcode],
			CONVERT(float, [Longitude]) as [Longitude],
			CONVERT(float, [Latitude]) as [Latitude],
			CONVERT(int, [EmploymentHours]) as [EmploymentHours],
			CONVERT(datetime2, [DateOfEmployment]) as [DateOfEmployment],
			CONVERT(datetime2, [DateOfLastEmployment]) as [DateOfLastEmployment],
			CONVERT(datetime2, [LastModifiedDate]) as [LastModifiedDate],
			[LastModifiedTouchpointId],
			[CreatedBy]
			FROM #employmentprogressions

		DROP TABLE #employmentprogressions
		
END