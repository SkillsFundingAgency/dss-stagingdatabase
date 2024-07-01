
IF NOT EXISTS(
       SELECT 1
       FROM   sys.columns
       WHERE  NAME = 'CurrentYear'
              AND [object_id] = OBJECT_ID('PowerBI.dss-pbi-financialyear')
              AND TYPE_NAME(system_type_id) = 'bit'
   )
BEGIN
	ALTER TABLE [PowerBI].[dss-pbi-financialyear] ADD CurrentYear bit null;
END
ELSE
BEGIN   
    UPDATE [PowerBI].[dss-pbi-financialyear]
        SET CurrentYear = 1
    WHERE GETDATE() BETWEEN StartDateTime AND EndDateTime;

	UPDATE [PowerBI].[dss-pbi-financialyear]
        SET CurrentYear = NULL
    WHERE GETDATE() NOT BETWEEN StartDateTime AND EndDateTime;

END;
GO

IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'pfy-dss-pbi-outcome' AND TABLE_SCHEMA = 'PowerBI')
BEGIN	
	CREATE TABLE [PowerBI].[pfy-dss-pbi-outcome](
		[TouchpointID] [varchar](4) NOT NULL,
		[PriorityOrNot] [varchar](2) NOT NULL,
		[OutcomeTypeValue] [int] NOT NULL,
		[OutcomeTypeGroup] [varchar](4) NOT NULL,
		[PeriodMonth] [int] NOT NULL,
		[PeriodYear] [varchar](9) NOT NULL,
		[OutcomeNumber] [decimal](11, 2) NULL,
		CONSTRAINT [pk-pfy-dss-pbi-outcome] PRIMARY KEY CLUSTERED 
		(
			[TouchpointID] ASC,
			[PeriodYear] ASC,
			[PeriodMonth] ASC,
			[PriorityOrNot] ASC,
			[OutcomeTypeGroup] ASC,
			[OutcomeTypeValue] ASC
		)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	)
END

IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'pfy-dss-pbi-outcome-actualvolume' AND TABLE_SCHEMA = 'PowerBI')
BEGIN	
	CREATE TABLE [PowerBI].[pfy-dss-pbi-outcome-actualvolume] (
    [TouchpointID] INT
	,[ProfileCategory] VARCHAR(4)
	,[PriorityOrNot] VARCHAR(2)
	,[PeriodMonth] INT
	,[DATE] DATETIME
	,[PeriodYear] VARCHAR(9)
	,[OutcomeNumber] DECIMAL(9,2)
	,[YTD_OutcomeNumber] DECIMAL(9,2)
	CONSTRAINT [pk-pfy-dss-pbi-outcome-actualvolume] PRIMARY KEY CLUSTERED 
	(
		[TouchpointID] ASC,
		[ProfileCategory] ASC,
		[PeriodYear] ASC,
		[PeriodMonth] ASC,
		[PriorityOrNot] ASC,
		[DATE] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

	)
END


IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'pfy-dss-pbi-outcomeactualfact' AND TABLE_SCHEMA = 'PowerBI')
BEGIN	
	CREATE TABLE [PowerBI].[pfy-dss-pbi-outcomeactualfact] (
    [TouchpointID] INT
	,[Outcome ID] INT
	,[Group ID] INT
	,[DATE] DATETIME
	,[OutcomeNumber] DECIMAL(9,2)
	,[YTD OutcomeNumber] DECIMAL(9,2)
	,[Outcomefinance] DECIMAL(9,2)
	,[YTD OutcomeFinance] DECIMAL(9,2)
	CONSTRAINT [pk-pfy-dss-pbi-outcomeactualfact] PRIMARY KEY CLUSTERED 
	(
		[TouchpointID] ASC,
		[Outcome ID] ASC,
		[Group ID] ASC,
		[DATE] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

	)
END


IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'pfy-dss-pbi-conversionrate' AND TABLE_SCHEMA = 'PowerBI')
BEGIN	
	CREATE TABLE [PowerBI].[pfy-dss-pbi-conversionrate] (
    [TouchpointID] INT
	,[Outcome ID] INT
	,[DATE] DATETIME
	,[Performance] DECIMAL(9,2)
	,[Performance YTD] DECIMAL(9,2)
	CONSTRAINT [pk-pfy-dss-pbi-conversionrate] PRIMARY KEY CLUSTERED 
	(
		[TouchpointID] ASC,
		[Outcome ID] ASC,
		[DATE] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	)
END


IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'pfy-dss-pbi-actual' AND TABLE_SCHEMA = 'PowerBI')
BEGIN	
	CREATE TABLE [PowerBI].[pfy-dss-pbi-actual](
		[RegionName] [varchar](30) ,
		[FinancialYear] [varchar](9) ,
		[PriorityOrNot] [varchar](2) ,
		[MonthShortName] [varchar](3) ,
		[CustomerCount] [int] ,
		[YTD_CustomerCount] [int] ,
		CONSTRAINT [pk-pfy-dss-pbi-actual] PRIMARY KEY CLUSTERED 
		(
			[RegionName] ASC,
			[FinancialYear] ASC,
			[PriorityOrNot] ASC,
			[MonthShortName] ASC
		 )WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	)
END

IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'pfy-dss-pbi-contractinformation' AND TABLE_SCHEMA = 'PowerBI')
BEGIN	
	CREATE TABLE [PowerBI].[pfy-dss-pbi-contractinformation](
	[TouchpointID]int,
	[ProfileCategory] varchar(23),
	[Date] datetime,
	[Fiscal Year] varchar(9),
	[ProfileCategoryValue] decimal(38,2),
	
	CONSTRAINT [pk-pfy-dss-pbi-contractinformation] PRIMARY KEY CLUSTERED 
		(
			[TouchpointID] ASC,
			[ProfileCategory] ASC,
			[Date] ASC,
			[Fiscal Year] ASC
		 )WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	)
END

IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'pfy-dss-pbi-customercount' AND TABLE_SCHEMA = 'PowerBI')
BEGIN	
	CREATE TABLE [PowerBI].[pfy-dss-pbi-customercount](
		TouchpointID varchar(4) not null,
		PeriodYear varchar(61) not null,
		PeriodMonth int not null,
		PriorityOrNot varchar(2) not null,
		CustomerCount int,	
	CONSTRAINT [pk-pfy-dss-pbi-customercount] PRIMARY KEY CLUSTERED 
		(
		TouchpointID ASC,
		PeriodYear ASC,
		PeriodMonth ASC,
		PriorityOrNot ASC
		)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	)
END


IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'pfy-dss-pbi-outcomeprofilevolume' AND TABLE_SCHEMA = 'PowerBI')
BEGIN	
	CREATE TABLE [PowerBI].[pfy-dss-pbi-outcomeprofilevolume](
		[TouchpointID] varchar(4) not null
        ,[ProfileCategory] varchar(10) not null
        ,[PriorityOrNot] varchar(2) not null
        ,[PeriodMonth] int not null
		,[date] datetime2(7) not null
        ,[PeriodYear] varchar(9) not null
        ,[OutcomeNumber] decimal(10,2)
        ,[YTD_OutcomeNumber] decimal(10,2)
	CONSTRAINT [pk-pfy-dss-pbi-outcomeprofilevolume] PRIMARY KEY CLUSTERED 
	(
		TouchpointID ASC,
		[ProfileCategory] ASC,
		[PriorityOrNot] ASC,
		[PeriodMonth] ASC,
		[date] ASC,
		[PeriodYear] ASC
		)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	)
END
IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'v-dss-pbi-actual-FY' AND TABLE_SCHEMA = 'PowerBI')
BEGIN
	CREATE VIEW [PowerBI].[v-dss-pbi-actual-FY]  AS 
		SELECT 
			MY.RegionName
			,MY.FinancialYear
			,MY.PriorityOrNot
			,MY.MonthShortName
			,MY.CustomerCount
			,MY.YTD_CustomerCount
		FROM
		(
			SELECT
				PR.[RegionName]
				,PF.[FinancialYear]
				,PVC.[PriorityOrNot]
				,PM.[MonthShortName]
				--,PVC.[PeriodMonth]
				,SUM(PVC.[CustomerCount]) AS CustomerCount
				,SUM(PVC.[CustomerCount]) OVER(PARTITION BY PR.[RegionName], PF.[FinancialYear], PVC.[PriorityOrNot] ORDER BY PVC.[PeriodMonth]) AS YTD_CustomerCount
			FROM [PowerBI].[v-dss-pbi-customercount] AS PVC 
			INNER JOIN PowerBI.[dss-pbi-region] AS PR
			ON PVC.[TouchpointID] = PR.[TouchpointID]
			INNER JOIN PowerBI.[dss-pbi-monthsinyear] AS PM
			ON PVC.[PeriodMonth] = PM.[PeriodMonth] 
			INNER JOIN PowerBI.[dss-pbi-financialyear] AS PF
			ON PVC.[PeriodYear] = PF.[FinancialYear] 
			INNER JOIN PowerBI.[dss-pbi-contractyear] AS PC 
			ON PF.[FinancialYear] BETWEEN PC.[StartFinancialYear] AND PC.[EndFinancialYear] 
			WHERE PVC.[PeriodMonth] >= CASE WHEN PC.[StartFinancialYear] = PF.[FinancialYear] THEN PC.[StartPeriodMonth] ELSE 1 END 
			AND PVC.[PeriodMonth] <= CASE WHEN PC.[EndFinancialYear] = PF.[FinancialYear] THEN PC.[EndPeriodMonth] ELSE 12 END 
			 GROUP BY PR.[RegionName] 
			,PF.[FinancialYear] 
			,PVC.[PriorityOrNot] 
			,PM.[MonthShortName] 
			,PVC.[PeriodMonth]
			,PVC.[CustomerCount] 
		) AS MY  
	GO
END
