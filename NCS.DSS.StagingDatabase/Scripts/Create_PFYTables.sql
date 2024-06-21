
ALTER VIEW [PowerBI].[v-dss-pbi-date] WITH SCHEMABINDING 
AS 
    SELECT 
        PD.[CalendarDate] AS [Date] 
        ,PD.[CalendarYear] AS [Year]
        ,PM.[MonthFullName] AS [Month]
        ,PM.[MonthId] AS [Month Number]
        ,PM.[PeriodMonth] AS [Fiscal Month Number]
        ,PM.[Quarter] AS [Quarter]
        ,PM.[PeriodQuarter] AS [Fiscal Quarter]
        ,PF.[FinancialYear] AS [Fiscal Year]
        ,PF.CurrentYear
    FROM [PowerBI].[dss-pbi-date] AS PD 
    INNER JOIN [PowerBI].[dss-pbi-monthsinyear] AS PM 
    ON PM.[MonthId] = PD.[MonthID]
    INNER JOIN [PowerBI].[dss-pbi-financialyear] AS PF 
    ON PD.[CalendarDate] BETWEEN PF.[StartDateTime] AND PF.[EndDateTime] 
;
GO

ALTER VIEW [PowerBI].[v-dss-pbi-outcome] AS
SELECT
              MY3.[TouchpointID]
              ,MY3.[PriorityOrNot]
              ,MY3.[OutcomeTypeValue]
              ,MY3.[OutcomeTypeGroup]
              ,MY3.[PeriodMonth]
              ,MY3.[PeriodYear]
              ,SUM(MY3.[OutcomeNumber]) AS [OutcomeNumber]
FROM
(
              SELECT
                             MY2.[TouchpointID]
                             ,MY2.[PriorityOrNot]
                             ,MY2.[OutcomeTypeValue]
                             ,MY2.[OutcomeTypeGroup]
                             ,MY2.[PeriodMonth]
                             ,MY2.[PeriodYear]
                             ,COUNT(*) AS OutcomeNumber
              FROM
              (
                             SELECT
                                           MY1.[TouchpointID]
                                           ,MY1.[CustomerID]
                                           ,MY1.[PriorityOrNot]
                                           ,MY1.[SessionID]                                                                                 
                                           ,MY1.[SessionDate]
                                           ,MY1.[OutcomeID]
                                           ,MY1.[OutcomeEffectiveDate]
                                           ,MY1.[OutcomeTypeValue]                                                                            
                                           ,MY1.[OutcomeTypeGroup]                                                                           
                                           ,MY1.[OutcomeClaimedDate]
                                           ,MY1.[SessionClosureDate]
                                           ,MY1.[PriorSessionDate]
                                           ,MY1.[SessionRank]
                                           ,MY1.[PeriodMonth]
                                           ,MY1.[PrevOutcomeType]
                                           ,MY1.[PeriodYear]
                             FROM
                             (
                                           SELECT
                                                          MY.[TouchpointID]
                                                          ,MY.[CustomerID]
                                                          ,MY.[PriorityOrNot]
                                                          ,MY.[SessionID]                                                                                    
                                                          ,MY.[SessionDate]
                                                          ,MY.[OutcomeID]
                                                          ,MY.[OutcomeEffectiveDate]
                                                          ,MY.[OutcomeTypeValue]                                                                               
                                                          ,MY.[OutcomeTypeGroup]                                                                              
                                                          ,MY.[OutcomeClaimedDate]
                                                          ,MY.[SessionClosureDate]
                                                          ,MY.[PriorSessionDate]
                                                          ,MY.[SessionRank]
                                                          ,MY.[PeriodMonth]
                                                          ,MY.[PeriodYear]
                                                          ,LAG(MY.[OutcomeTypeValue]) OVER (PARTITION BY MY.[CustomerID], MY.[PeriodYear] ORDER BY MY.[OutcomeEffectiveDate], MY.[OutcomeTypeValue]) AS [PrevOutcomeType]
                                           FROM
                                           (
                                                          SELECT
                                                                        RIGHT(DO.[TouchpointID], 3) AS 'TouchpointID'
                                                                        ,DO.[CustomerId] AS 'CustomerID'
                                                                        ,CASE
                                                                                      WHEN IIF(ep.EconomicShockStatus = 2 AND ep.EconomicShockCode LIKE 'Aspen%', 1, COALESCE(DO.[IsPriorityCustomer], IIF(DO.[ClaimedPriorityGroup] <= 6, 1, 0))) = 1 THEN 'PG' --Groups 1 to 6
                                                                                      WHEN IIF(ep.EconomicShockStatus = 2 AND ep.EconomicShockCode LIKE 'Aspen%', 1, COALESCE(DO.[IsPriorityCustomer], IIF(DO.[ClaimedPriorityGroup] <= 6, 1, 0))) = 0 THEN 'NP' --inc 98(unknown) and 99
                                                                                      ELSE 'UNKNOWN' --should be none in this group
                                                                        END      AS 'PriorityOrNot'
                                                                        ,DS.[id] AS 'SessionID'                                                                         
                                                                        ,CONVERT(DATE, DS.[DateandTimeOfSession]) AS 'SessionDate'
                                                                        ,DO.[id] AS 'OutcomeID'
                                                                        ,DO.[OutcomeEffectiveDate] AS 'OutcomeEffectiveDate'
                                                                        ,DR.[description] AS 'OutcomeType' --Excel only
                                                                        ,DO.[OutcomeType] AS 'OutcomeTypeValue'                                                                          
                                                                        ,CASE
                                                                                      WHEN DO.[OutcomeType] = 1 THEN 'CSO'
                                                                                      WHEN DO.[OutcomeType] = 2 THEN 'CMO'
                                                                                      WHEN DO.[OutcomeType] = 4 THEN 'LO'                     
                                                                                      ELSE 'JO'                                                                                                  -- Type 3 or 5
                                                                        END AS 'OutcomeTypeGroup'                                                                                      
                                                                        ,DO.[OutcomeClaimedDate] AS 'OutcomeClaimedDate'
                                                                        ,CASE DO.[OutcomeType]
                                                                                      WHEN 3 THEN              DATEADD(mm, 13, DS.[DateandTimeOfSession])
                                                                                      ELSE DATEADD(mm, 12, DS.[DateandTimeOfSession])
                                                                        END AS 'SessionClosureDate' --date limit for Effective Outcomes
                                                                        ,DATEADD(mm, -12, CONVERT(DATE, DS.[DateandTimeOfSession])) AS 'PriorSessionDate'              --12 months before current session (latest possible previous session)
                                                                        ,RANK() OVER(PARTITION BY DS.[CustomerID], FY.FinancialYear, IIF(DS.[DateandTimeOfSession] < CONVERT(DATETIME, '01-10-2022', 103), 100, 0), DO.OutcomeType
                                                                                                     ORDER BY DO.[OutcomeEffectiveDate], DO.[LastModifiedDate], DO.[id]) AS 'SessionRank'  -- we rank to remove duplicates
                                                                        -- ##### FUNDING RULES #####                             -- JLOs have been split into JOs and LOs since 1/Oct/2020
                                                                        ,PeriodMonth = CASE
                                                                                      WHEN MONTH(DO.[OutcomeEffectiveDate]) < 4 THEN MONTH(DO.[OutcomeEffectiveDate]) + 9
                                                                                      ELSE MONTH(DO.[OutcomeEffectiveDate]) - 3
                                                                        END
                                                                        ,CASE
                                                                                      WHEN MONTH(DO.[OutcomeEffectiveDate]) < 4
                                                                                                     THEN CONCAT(CAST(YEAR(DO.[OutcomeEffectiveDate]) - 1 AS VARCHAR), '-', CAST(YEAR(DO.[OutcomeEffectiveDate]) AS VARCHAR)) 
                                                                                      ELSE CONCAT(CAST(YEAR(DO.[OutcomeEffectiveDate]) AS VARCHAR), '-', CAST(YEAR(DO.[OutcomeEffectiveDate]) + 1 AS VARCHAR))
                                                                        END                                                                                                                                                                                                                                             AS 'PeriodYear'
                                                          FROM [dbo].[dss-sessions] AS DS
                                                          INNER JOIN [dbo].[dss-customers] AS DC
                                                          ON DC.[id] = DS.[CustomerId]
                                                          INNER JOIN [dbo].[dss-actionplans] AS DA
                                                          ON DA.[SessionId] = DS.[id]
                                                          INNER JOIN [dbo].[dss-interactions] AS DI
                                                          ON DI.[id] = DA.[InteractionId]
                                                          INNER JOIN [dbo].[dss-outcomes] AS DO
                                                          ON DO.[ActionPlanId] = DA.[id]
                                                          INNER JOIN [dbo].[dss-reference-data] AS DR
                                                          ON DR.[value] = DO.[OutcomeType]
                                                          AND DR.[name] = 'OutcomeType'
														  LEFT JOIN [dss-employmentprogressions] ep on ep.CustomerId = DC.id AND ep.DateProgressionRecorded BETWEEN DATEADD(MONTH, -12, DO.OutcomeEffectiveDate) AND DO.OutcomeEffectiveDate
														  JOIN PowerBI.[dss-pbi-financialyear] AS FY ON (CAST(DO.OutcomeEffectiveDate as Date) BETWEEN fy.StartDateTime AND fy.EndDateTime)					AND (CAST(DO.OutcomeClaimedDate as Date) BETWEEN fy.StartDateTime AND fy.EndDateTime)
                                                          WHERE (DC.ReasonForTermination IS NULL OR DC.ReasonForTermination <> 3) 												  
                                           ) AS MY
                                           WHERE MY.[SessionRank] = 1
                             ) AS MY1
                             WHERE
                             (
                                           (MY1.[OutcomeTypeValue] IN (1, 2, 4)
                                           AND CONVERT(DATE, MY1.OutcomeEffectiveDate) <= MY1.SessionClosureDate                                                                                                         -- within 12 or 13 months of the session date date
                                           AND MY1.TouchpointID <> '999' --exclude NCH (helpline)
                                           AND      NOT EXISTS
                                                          (
                                                                        SELECT priorO.id
                                                                        FROM [dbo].[dss-sessions] AS priorS
                                                                        INNER JOIN [dbo].[dss-outcomes] AS priorO
                                                                        ON priorS.id = priorO.SessionId
                                                                        WHERE priorO.[id] <> MY1.[OutcomeID]
                                                                        AND              priorO.[OutcomeEffectiveDate] < MY1.[OutcomeEffectiveDate]
                                                                        AND              priorO.[OutcomeClaimedDate] IS NOT NULL                -- and claimed
                                                                        AND      priorO.[CustomerId] = MY1.[CustomerId]                                    -- and they belong to the same customer
                                                                        AND              RIGHT(priorO.[TouchpointId], 3) <> '999'                       -- and previous touchpoint was not helpline
                                                                        AND      CONVERT(DATE, priorS.[DateandTimeOfSession]) > MY1.[PriorSessionDate]  -- and the prior session date is more then 12 months before current session date
                                                                        AND     
                                                                        (             -- check validity of the previous outcomes we are considering
                                                                                      (             -- the previous outcome should have been claimed within 13 months of the previous session date for Outcome Type 3
                                                                                                    MY1.[OutcomeTypeValue] = 3                                                                                                   
                                                                                                     AND DATEADD(mm, 13, CONVERT(DATE, priorS.[DateandTimeOfSession])) >= CONVERT(DATE, priorO.[OutcomeEffectiveDate])
                                                                                      )
                                                                                      OR         -- the previous outcome should have been claimed within 12 months of the previous session date for Outcome Types 1,2,4,5
                                                                                      (
                                                                                                    MY1.[OutcomeTypeValue] IN (1, 2, 4, 5)                                     
                                                                                                     AND DATEADD(mm, 12, CONVERT(DATE, priorS.[DateandTimeOfSession])) >= CONVERT(DATE, priorO.[OutcomeEffectiveDate])
                                                                                      )                                                                                                                                                                                                        
                                                                        )
                                                                        AND     
                                                                        (
                                                                                      (             -- check there are no Outcomes of the same type (CSO and CMO)
                                                                                                    MY1.[OutcomeTypeValue] IN (1, 2)
                                                                                                     AND              MY1.[OutcomeTypeValue] = priorO.[OutcomeType]
                                                                                      )
                                                                        OR
                                                                                      (             -- check there are no outcomes of the same type (JLO)
                                                                                                    MY1.[OutcomeTypeValue] IN (3, 5)
                                                                                                     AND priorO.[OutcomeType] IN (3, 5)
                                                                                      )
                                                                        )
                                                         )
                                           )
                                           OR (MY1.[OutcomeTypeValue] = 3 AND MY1.[PrevOutcomeType] IS  NULL)
                                           OR (MY1.[OutcomeTypeValue] = 3 AND MY1.[PrevOutcomeType] <> 5)
                                           OR (MY1.[OutcomeTypeValue] = 5 AND MY1.[PrevOutcomeType] IS  NULL)
                                           OR (MY1.[OutcomeTypeValue] = 5 AND MY1.[PrevOutcomeType] <> 3)
                             )
              ) AS MY2
              GROUP BY
                             MY2.[TouchpointID]
                             ,MY2.[PriorityOrNot]
                             ,MY2.[OutcomeTypeValue]
                             ,MY2.[OutcomeTypeGroup]
                             ,MY2.[PeriodMonth]
                             ,MY2.[PeriodYear]
              UNION ALL
              SELECT
                             RE.TouchpointID AS [TouchpointID]
                             ,GD.[Group abbreviation] AS [PriorityOrNot]
                             ,OT.[OutcomeTypeValue]
                             ,OT.[OutcomeTypeGroup]
                             ,PD.[PeriodMonth]
                             ,PD.[PeriodYear]
                             ,0 AS [OutcomeNumber]
              FROM [PowerBI].[dss-pbi-region] AS RE,
              [PowerBI].[v-dss-pbi-groupdim] AS GD,
              (
                             SELECT 2 AS [OutcomeTypeValue], 'CMO' AS [OutcomeTypeGroup]
                             UNION ALL
                             SELECT 3 AS [OutcomeTypeValue], 'JO' AS [OutcomeTypeGroup]
                             UNION ALL
                             SELECT 5 AS [OutcomeTypeValue], 'JO' AS [OutcomeTypeGroup]
                             UNION ALL
                             SELECT 4 AS [OutcomeTypeValue], 'LO' AS [OutcomeTypeGroup]
              ) AS OT,
              (
                             SELECT DISTINCT [Fiscal Year] AS [PeriodYear], [Fiscal Month Number] AS [PeriodMonth]
                             FROM [PowerBI].[v-dss-pbi-date]
                             WHERE [Date] >= CONVERT(DATETIME, '01-10-2022', 103)
                             AND [Date] < GETDATE() 
              ) AS PD
) AS MY3
GROUP BY
    MY3.[TouchpointID]
    ,MY3.[PeriodYear]
    ,MY3.[PeriodMonth]
    ,MY3.[PriorityOrNot]
    ,MY3.[OutcomeTypeGroup]
    ,MY3.[OutcomeTypeValue]
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