
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

ALTER VIEW [PowerBI].[v-dss-pbi-customercount] WITH SCHEMABINDING 
AS 
    WITH RelevantData AS (
        SELECT	
        RIGHT(AP.CreatedBy, 3) AS TouchpointID,
        AP.CustomerId AS CustomerID,
        AP.id AS ActionPlanId,
        P.PriorityGroup AS PriorityCustomer,
        AP.DateActionPlanCreated AS DateActionPlanCreated,
        CASE WHEN P.PriorityGroup IN (1, 2, 3, 4, 5, 6) OR (ep.EconomicShockStatus = 2 AND ep.EconomicShockCode LIKE 'Aspen%') THEN 'PG' ELSE 'NP' END AS PriorityOrNot,
        CASE WHEN MONTH(AP.DateActionPlanCreated) < 4 THEN MONTH(AP.DateActionPlanCreated) + 9 ELSE MONTH(AP.DateActionPlanCreated) - 3 END AS PeriodMonth,
        CASE WHEN MONTH(AP.DateActionPlanCreated) < 4 THEN CONCAT(YEAR(AP.DateActionPlanCreated) - 1, '-', YEAR(AP.DateActionPlanCreated)) ELSE CONCAT(YEAR(AP.DateActionPlanCreated), '-', YEAR(AP.DateActionPlanCreated) + 1) END AS PeriodYear,
        (CONVERT(INT, CONVERT(CHAR(8), AP.DateActionPlanCreated, 112)) - CONVERT(CHAR(8), C.DateofBirth, 112)) / 10000 AS Age,
        RANK() OVER (PARTITION BY AP.CustomerID, CASE WHEN MONTH(AP.DateActionPlanCreated) < 4 THEN CONCAT(YEAR(AP.DateActionPlanCreated) - 1, '-', YEAR(AP.DateActionPlanCreated)) ELSE CONCAT(YEAR(AP.DateActionPlanCreated), '-', YEAR(AP.DateActionPlanCreated) + 1) END ORDER BY AP.DateActionPlanCreated, AP.LastModifiedDate, P.PriorityGroup, RIGHT(AP.CreatedBy, 3)) AS RankID
    FROM [dbo].[dss-actionplans] AS AP 
        INNER JOIN [dbo].[dss-customers] AS C ON C.id = AP.CustomerId
	    LEFT JOIN [dbo].[dss-outcomes] AS DO ON DO.[ActionPlanId] = AP.[id]
        LEFT JOIN [dbo].[dss-prioritygroups] AS P ON P.CustomerId = AP.CustomerId
	    LEFT JOIN [dbo].[dss-employmentprogressions] ep on ep.CustomerId = C.id AND ep.DateProgressionRecorded BETWEEN DATEADD(MONTH, -12, DO.OutcomeEffectiveDate) AND DO.OutcomeEffectiveDate
	    INNER JOIN PowerBI.[dss-pbi-financialyear] AS DR ON AP.DateActionPlanCreated BETWEEN DR.StartDateTime AND DR.EndDateTime
    WHERE (C.ReasonForTermination IS NULL OR C.ReasonForTermination <> 3)
    )	   
    SELECT	
        R.TouchpointID,
        R.PeriodYear,
        R.PeriodMonth,
        R.PriorityOrNot,
        COUNT(DISTINCT R.CustomerID) AS CustomerCount
    FROM RelevantData AS R
    WHERE (R.Age >= 19 OR (R.PriorityCustomer = 1 AND R.Age >= 18 AND R.Age <= 24))
        AND R.RankID = 1 
    GROUP BY R.TouchpointID, R.PeriodYear, R.PeriodMonth, R.PriorityOrNot;
;
GO

ALTER VIEW [PowerBI].[v-dss-pbi-outcomeprofilevolume] 
AS 
    WITH MYProfile 
    (
        [TouchpointID]
        ,[ProfileCategory]
        ,[PriorityOrNot]
        ,[PeriodMonth]
        ,[PeriodYear] 
        ,[OutcomeNumber] 
        ,[YTD_OutcomeNumber]
    ) 
    AS 
    (
        SELECT 
            PPP.[TouchpointID] 
            ,PPP.[ProfileCategory] 
            ,PPP.[PriorityOrNot] 
            ,PNT.[PeriodMonth] 
            ,PPP.[FinancialYear] AS [PeriodYear] 
            ,CONVERT(DECIMAL(11, 2), 
			(PPP.[ProfileCategoryValue] * PNT.[TargetCategoryValue]) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ1] * PNT.[PMP1], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ2] * PNT.[PMP2], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ3] * PNT.[PMP3], 0) / 100 
			) AS [OutcomeNumber] 
            ,SUM(CONVERT(DECIMAL(11, 2), 
			(PPP.[ProfileCategoryValue] * PNT.[TargetCategoryValue]) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ1] * PNT.[PMP1], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ2] * PNT.[PMP2], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ3] * PNT.[PMP3], 0) / 100 
			)) OVER(PARTITION BY PPP.[TouchpointID], PPP.[FinancialYear], PPP.[ProfileCategory], PPP.[PriorityOrNot] 
			ORDER BY PNT.[PeriodMonth]) AS [YTD_OutcomeNumber] 
        FROM [PowerBI].[dss-pbi-primeprofile] AS PPP 
        INNER JOIN [PowerBI].[v-dss-pbi-nationaltarget] AS PNT 
        ON PPP.[ProfileCategory] = PNT.[TargetCategory] 
        AND PPP.[FinancialYear] = PNT.[FinancialYear] 
        AND PPP.[PriorityOrNot] = PNT.[PriorityOrNot] 
		inner join [powerbi].[dss-pbi-financialyear] as fy
on fy.FinancialYear=PPP.[FinancialYear]
        WHERE PPP.[FinancialsOrNot] = 0 --Selecting the target/profile number set in the contract 
        AND PPP.[ProfileCategory] IN ('CMO', 'JO', 'LO') 
        UNION ALL 
        SELECT 
            PPP.[TouchpointID] 
            ,'CUS' AS [ProfileCategory] 
            ,PPP.[PriorityOrNot] 
            ,PNT.[PeriodMonth] 
            ,PPP.[FinancialYear] AS [PeriodYear] 
			,CONVERT(DECIMAL(11, 2), 
			((PPP.[ProfileCategoryValue] * PNT.[TargetCategoryValue]) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ1] * PNT.[PMP1], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ2] * PNT.[PMP2], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ3] * PNT.[PMP3], 0) / 100 
			) / [PRF].[ReferenceValue]) AS [OutcomeNumber] 
			,SUM(CONVERT(DECIMAL(11, 2), 
			((PPP.[ProfileCategoryValue] * PNT.[TargetCategoryValue]) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ1] * PNT.[PMP1], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ2] * PNT.[PMP2], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ3] * PNT.[PMP3], 0) / 100 
			) / [PRF].[ReferenceValue])) 
			OVER(PARTITION BY PPP.[TouchpointID], PPP.[FinancialYear], PPP.[ProfileCategory], PPP.[PriorityOrNot] 
			ORDER BY PNT.[PeriodMonth]) AS [YTD_OutcomeNumber]
        FROM [PowerBI].[dss-pbi-primeprofile] AS PPP 
        INNER JOIN [PowerBI].[v-dss-pbi-nationaltarget] AS PNT 
        ON PPP.[ProfileCategory] = PNT.[TargetCategory] 
        AND PPP.[FinancialYear] = PNT.[FinancialYear] 
        AND PPP.[PriorityOrNot] = PNT.[PriorityOrNot] 
        INNER JOIN [PowerBI].[dss-pbi-reference] AS PRF 
        ON PRF.ReferenceCategory = 'CUS' 
		inner join [powerbi].[dss-pbi-financialyear] as fy
on fy.FinancialYear=PPP.[FinancialYear]
        WHERE PPP.[FinancialsOrNot] = 0 --Selecting the target/profile number set in the contract 
        AND PPP.[ProfileCategory] = 'CMO' 
        UNION ALL 
        SELECT 
            PPP.[TouchpointID] 
            ,'CMD' AS [ProfileCategory] 
            ,PPP.[PriorityOrNot] 
            ,PNT.[PeriodMonth] 
            ,PPP.[FinancialYear] AS [PeriodYear] 
            ,CONVERT(DECIMAL(11, 2), 
			(PPP.[ProfileCategoryValue] * PNT.[TargetCategoryValue]) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ1] * PNT.[PMP1], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ2] * PNT.[PMP2], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ3] * PNT.[PMP3], 0) / 100 
			) AS [OutcomeNumber] 
            ,SUM(CONVERT(DECIMAL(11, 2), 
			(PPP.[ProfileCategoryValue] * PNT.[TargetCategoryValue]) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ1] * PNT.[PMP1], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ2] * PNT.[PMP2], 0) / 100 
			+ ISNULL(PPP.[ProfileCategoryValueQ3] * PNT.[PMP3], 0) / 100 
			)) OVER(PARTITION BY PPP.[TouchpointID], PPP.[FinancialYear], PPP.[ProfileCategory], PPP.[PriorityOrNot] 
			ORDER BY PNT.[PeriodMonth]) AS [YTD_OutcomeNumber] 
        FROM [PowerBI].[dss-pbi-primeprofile] AS PPP 
        INNER JOIN [PowerBI].[v-dss-pbi-nationaltarget] AS PNT 
        ON PPP.[ProfileCategory] = PNT.[TargetCategory] 
        AND PPP.[FinancialYear] = PNT.[FinancialYear] 
        AND PPP.[PriorityOrNot] = PNT.[PriorityOrNot] 
		inner join [powerbi].[dss-pbi-financialyear] as fy
on fy.FinancialYear=PPP.[FinancialYear]
        WHERE PPP.[FinancialsOrNot] = 0 --Selecting the target/profile number set in the contract 
        AND PPP.[ProfileCategory] = 'CMO' 
    )
    SELECT 
        MY.[TouchpointID]
        ,MY.[ProfileCategory]
        ,MY.[PriorityOrNot]
        ,MY.[PeriodMonth]
        ,PT.[Date]
        ,MY.[PeriodYear] 
        ,CAST(CASE WHEN MY.[ProfileCategory] = 'CMD' THEN 
                IIF(MY.[OutcomeNumber] > 0, 
                    MY.[OutcomeNumber] - LAG(MY.[OutcomeNumber]) OVER (PARTITION BY MY.[TouchpointID], MY.[PeriodYear], MY.[ProfileCategory], MY.[PriorityOrNot] 
                                                                    ORDER BY MY.PeriodMonth), 0) 
                ELSE 
                    MY.[OutcomeNumber]
                END AS DECIMAL(10, 2)) AS [OutcomeNumber]
        ,[YTD_OutcomeNumber]
    FROM 
    (
        SELECT 
            MY1.[TouchpointID]
            ,MY1.[ProfileCategory]
            ,MY1.[PriorityOrNot]
            ,MY1.[PeriodMonth]
            ,MY1.[PeriodYear] 
            ,CAST(CASE WHEN MY1.[ProfileCategory] = 'CMD' THEN 
                    IIF(MY1.[YTD_OutcomeNumber] > ((DP.[ProfileCategoryValue] + DP.[ProfileCategoryValueQ1] + DP.[ProfileCategoryValueQ2] + DP.[ProfileCategoryValueQ3])  * DRR.[ReferenceValue] / 100), 
                        MY1.[YTD_OutcomeNumber] - ((DP.[ProfileCategoryValue] + DP.[ProfileCategoryValueQ1] + DP.[ProfileCategoryValueQ2] + DP.[ProfileCategoryValueQ3]) * DRR.[ReferenceValue] / 100), 0) 
                    ELSE 
                        MY1.[OutcomeNumber]
                    END AS DECIMAL(10, 2)) AS [OutcomeNumber]
            ,CAST(CASE WHEN MY1.[ProfileCategory] = 'CMD' THEN 
                    IIF(MY1.[YTD_OutcomeNumber] > ((DP.[ProfileCategoryValue] + DP.[ProfileCategoryValueQ1] + DP.[ProfileCategoryValueQ2] + DP.[ProfileCategoryValueQ3]) * DRR.[ReferenceValue] / 100), 
                        MY1.[YTD_OutcomeNumber] - ((DP.[ProfileCategoryValue] + DP.[ProfileCategoryValueQ1] + DP.[ProfileCategoryValueQ2] + DP.[ProfileCategoryValueQ3]) * DRR.[ReferenceValue] / 100), 0) 
                    ELSE 
                        MY1.[YTD_OutcomeNumber]
                    END AS DECIMAL(10, 2)) AS [YTD_OutcomeNumber]
        FROM MYProfile AS MY1 
        LEFT OUTER JOIN [PowerBI].[dss-pbi-primeprofile] AS DP 
        ON MY1.[TouchpointID] = DP.[TouchpointID] 
        AND MY1.[PeriodYear] = DP.[FinancialYear] 
        AND MY1.[ProfileCategory] = 'CMD'
        AND DP.[FinancialsOrNot] = 0
        AND DP.[PriorityOrNot] = 'PG'
        AND DP.[ProfileCategory] = 'CMO'
        LEFT OUTER JOIN [PowerBI].[dss-pbi-reference] AS DRR 
        ON DRR.[ReferenceCategory] = 'CMB' 
    ) AS MY 
    INNER JOIN [PowerBI].[v-dss-pbi-date] AS PT 
    ON MY.[PeriodYear] = PT.[Fiscal Year] 
    AND MY.[PeriodMonth] = PT.[Fiscal Month Number] 
    WHERE DATEPART(DAY, PT.[Date]) = 1 
;
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