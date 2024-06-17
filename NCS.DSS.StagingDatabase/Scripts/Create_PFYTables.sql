
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'pfy-dss-pbi-outcome' AND TABLE_SCHEMA = 'PowerBI')
BEGIN	
	DROP TABLE [PowerBI].[pfy-dss-pbi-outcome];
END

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


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'pfy-dss-pbi-outcome-actualvolume' AND TABLE_SCHEMA = 'PowerBI')
BEGIN	
	DROP TABLE [PowerBI].[pfy-dss-pbi-outcome-actualvolume];
END

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


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'pfy-dss-pbi-outcomeactualfact' AND TABLE_SCHEMA = 'PowerBI')
BEGIN	
	DROP TABLE [PowerBI].[pfy-dss-pbi-outcomeactualfact];	
END

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


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'pfy-dss-pbi-conversionrate' AND TABLE_SCHEMA = 'PowerBI')
BEGIN	
	DROP TABLE [PowerBI].[pfy-dss-pbi-conversionrate];
END

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


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'pfy-dss-pbi-actual' AND TABLE_SCHEMA = 'PowerBI')
BEGIN	
	DROP TABLE [PowerBI].[pfy-dss-pbi-actual];
END

CREATE TABLE [PowerBI].[pfy-dss-pbi-actual](
	[RegionName] [varchar](30) ,
	[FinancialYear] [varchar](9) ,
	[PriorityOrNot] [varchar](2) ,
	[MonthShortName] [varchar](3) ,
	[CustomerCount] [int] ,
	[YTD_CustomerCount] [int] ,
	CONSTRAINT [pfy-dss-pbi-actual] PRIMARY KEY CLUSTERED 
	(
		[RegionName] ASC,
		[FinancialYear] ASC,
		[PriorityOrNot] ASC,
		[MonthShortName] ASC
	 )WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
)


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'pfy-dss-pbi-contractinformation' AND TABLE_SCHEMA = 'PowerBI')
BEGIN	
	DROP TABLE [PowerBI].[pfy-dss-pbi-contractinformation];
END
CREATE TABLE [PowerBI].[pfy-dss-pbi-contractinformation](
	[TouchpointID]int,
[ProfileCategory] varchar(23),
[Date] datetime,
[Fiscal Year] varchar(9),
[ProfileCategoryValue] decimal(38,2),
	
CONSTRAINT [pfy-dss-pbi-contractinformation] PRIMARY KEY CLUSTERED 
	(
		[TouchpointID] ASC,
		[ProfileCategory] ASC,
		[Date] ASC,
		[Fiscal Year] ASC
	 )WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
)


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'pfy-dss-pbi-customercount' AND TABLE_SCHEMA = 'PowerBI')
BEGIN	
	DROP TABLE [PowerBI].[pfy-dss-pbi-customercount];
END

CREATE TABLE [PowerBI].[pfy-dss-pbi-customercount](
	TouchpointID varchar(max),
	PeriodYear varchar(61),
	PeriodMonth int,
	PriorityOrNot varchar(2),
	CustomerCount int,	
CONSTRAINT [pfy-dss-pbi-customercount] PRIMARY KEY CLUSTERED 
	(
	TouchpointID ASC,
	PeriodYear ASC,
	PeriodMonth ASC,
	PriorityOrNot ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
)


IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'pfy-dss-pbi-outcomeprofilevolume' AND TABLE_SCHEMA = 'PowerBI')
BEGIN	
	DROP TABLE [PowerBI].[pfy-dss-pbi-outcomeprofilevolume];
END

CREATE TABLE [PowerBI].[pfy-dss-pbi-outcomeprofilevolume](
	[TouchpointID] varchar(4)
        ,[ProfileCategory] varchar(10)
        ,[PriorityOrNot] varchar(2)
        ,[PeriodMonth] int not null
		,[date] datetime2(7)
        ,[PeriodYear] varchar(9)
        ,[OutcomeNumber] decimal(10,2)
        ,[YTD_OutcomeNumber] decimal(10,2)
CONSTRAINT [pfy-dss-pbi-outcomeprofilevolume] PRIMARY KEY CLUSTERED 
	(
	TouchpointID ASC,
	[ProfileCategory] ASC,
	[PriorityOrNot] ASC,
	[PeriodMonth] ASC,
	[date] ASC,
	[PeriodYear] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
)
GO