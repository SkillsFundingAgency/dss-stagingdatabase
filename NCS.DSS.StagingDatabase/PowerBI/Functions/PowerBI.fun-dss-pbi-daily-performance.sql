/****** Object:  UserDefinedFunction [PowerBI].[fun-dss-pbi-daily-performance]    Script Date: 03/01/2024 14:26:53 ******/

CREATE FUNCTION [PowerBI].[fun-dss-pbi-daily-performance]()
RETURNS @funReturn Table
(
    TouchpointID INT,
    [Fiscal Year] VARCHAR(32),
    [YTD Forecast] DECIMAL(11,2),
    [EOD Value Achieved] DECIMAL(11,2),
    [EOD Percentage] DECIMAL(11,2),
    [EOD Profile] DECIMAL(11,2),
    [EOM Profile Value] DECIMAL(11,2),
    [EOM Forecast]  DECIMAL(11,2),
    [YTD Profile Value] DECIMAL(11,2),
    [Daily Average] DECIMAL(11,2),
    [Yesterday] VARCHAR(32)
)
AS
BEGIN
    DECLARE @EodPercentage TABLE (
        TouchpointID INT,
        [Fiscal Year] VARCHAR(32),
        [EOD Value Achieved] DECIMAL(11,2),
        [EOD Profile] DECIMAL(11,2),
        [EOD Percentage] DECIMAL(11,2))

    INSERT INTO @EodPercentage
    SELECT eod.TouchpointID,
        eod.[Fiscal Year],
        eod.[EOD Value Achieved],
        [ProfileToday],
        ROUND(eod.[EOD Value Achieved]/[ProfileToday],2) * 100
    FROM 
	(
		SELECT 
			A.[TouchpointID] 
			,A.[Fiscal Year]
			,A.[EOD Value Achieved] - ISNULL(B.[EOD Value Achieved], 0) AS [EOD Value Achieved]
		FROM 
		(
				SELECT
					AF.[TouchpointID] 
					, PD.[Fiscal Year]
					, SUM(AF.[YTD OutcomeFinance]) AS [EOD Value Achieved]
				FROM [PowerBI].[v-dss-pbi-outcomeactualfact] AS AF
					INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD ON AF.[Date] = PD.[Date] AND AF.[TouchpointID] > 200
					INNER JOIN [PowerBI].[v-dss-pbi-date] AS  PD1 ON  Pd1.[Fiscal Year]=pd.[Fiscal Year]
				WHERE AF.[Outcome ID] in (2,6,11) AND PD.[Month Number] =  Month(DATEADD(d,-1, GETDATE()))
				and  PD1.[Date] = convert(date,DATEADD(d,-1, GETDATE()))
				GROUP BY  AF.[TouchpointID] 
						,PD.[Fiscal Year]
		) AS A 
		LEFT OUTER JOIN 
		(
				SELECT
					AF.[TouchpointID] 
					, PD.[Fiscal Year] AS [Fiscal Year]
					, SUM(AF.[PaymentMade]) AS [EOD Value Achieved]
				FROM [PowerBI].[dss-pbi-actualpaymentsmade] AS AF 
				INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD ON PD.[Fiscal Year] = AF.[FinancialYear]
				WHERE AF.MonthID <= PD.[Month Number] 
				AND PD.[Date] = CONVERT(DATE, DATEADD(d, -1, GETDATE()))
				AND AF.[TouchpointID] > 200 
				GROUP BY  AF.[TouchpointID] 
						,PD.[Fiscal Year]
		) AS B 
		ON A.[TouchpointID] = B.[TouchpointID] 
		AND A.[Fiscal Year] = B.[Fiscal Year]
/*
         SELECT
            AF.[TouchpointID] 
            , PD.[Fiscal Year]
            , SUM(AF.[Outcome Finance]) AS [EOD Value Achieved]
        FROM [PowerBI].[v-dss-pbi-outcomeactualfact] AS AF
            INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD ON AF.[Date] = PD.[Date] AND AF.[TouchpointID] > 200
			INNER JOIN [PowerBI].[v-dss-pbi-date] AS  PD1 ON  Pd1.[Fiscal Year]=pd.[Fiscal Year]
        WHERE AF.[Outcome ID] in (2,6,11) AND PD.[Month Number] =  Month(DATEADD(d,-1, GETDATE()))
		and  PD1.[Date] = convert(date,DATEADD(d,-1, GETDATE()))
        GROUP BY  AF.[TouchpointID] 
                ,PD.[Fiscal Year] */
                ) as eod
        JOIN (
				SELECT 
					A.[TouchpointID]
					, A.[Fiscal Year]
					, A.[ProfileToday] - B.[EOM Profile Value] AS [ProfileToday]
				FROM 
				(
				Select DP.[TouchpointID] 
						, PD.[Fiscal Year]
						, SUM(DP.[DailyPerformance]) AS ProfileToday
					FROM [PowerBI].[v-dss-pbi-daily-performance] AS DP 
					INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD ON PD.[Date] = DP.CalendarDate 
					INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD1 ON PD1.[Fiscal Year] = PD.[Fiscal Year]
				WHERE DP.CalendarDate <= CONVERT(DATE, DATEADD(d, -1, GETDATE())) 
				AND PD1.[Date] = CONVERT(DATE, DATEADD(d, -1, GETDATE()))
				AND PD.[Month Number] <= Month(DATEADD(d,-1, GETDATE()))
				GROUP BY DP.[TouchpointID]
							,PD.[Fiscal Year] 
				) AS A 
				LEFT OUTER JOIN 
				(
				SELECT PF.[TouchpointID] 
                        ,PD.[Fiscal Year]
                        ,SUM(PF.[Financial Profile Total]) AS [EOM Profile Value]
                FROM [PowerBI].[v-dss-pbi-outcomeprofilefact] AS PF
                INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD ON PF.[Date] = PD.[Date] AND PF.[TouchpointID] > 200
				INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD1 ON Pd1.[Fiscal Year]=pd.[Fiscal Year]
				INNER JOIN (SELECT MY.CalendarDate
							FROM 
							(
								SELECT CalendarDate, ROW_NUMBER() OVER(PARTITION BY CalendarYear, MonthId ORDER BY DateID) AS ROW_NUM 
								  FROM [PowerBI].[dss-pbi-date]
								WHERE WeekDay = 1 
								AND BankHoliday = 0
								AND MonthID = MONTH(GETDATE())
								AND CalendarYear = YEAR(GETDATE())
							) AS MY 
							WHERE MY.ROW_NUM = 6
							) AS DT 
				ON PF.[Date] < DT.CalendarDate 
                WHERE PF.[Outcome ID] IN (2,6,11) 
				AND PD.[Month Number] <= (MONTH(GETDATE()) - CASE WHEN DATEDIFF(d, DT.CalendarDate, GETDATE()) < 0 THEN 2 ELSE 1 END)
				AND PD1.[Date] = convert(date,DATEADD(d,-1, GETDATE()))
                GROUP by PF.[TouchpointID] 
                         ,PD.[Fiscal Year]
				) AS B
				ON A.[TouchpointID]  = B.[TouchpointID] 
				AND A.[Fiscal Year] = B.[Fiscal Year]

		/*Select dp.TouchpointID
                    , pd.[Fiscal Year]
                    , SUM(dp.DailyPerformance) as ProfileToday
                FROM [PowerBI].[v-dss-pbi-daily-performance] as dp
                INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD ON  PD.[Date] = dp.CalendarDate 
				 INNER JOIN [PowerBI].[v-dss-pbi-date] AS  PD1 ON Pd1.[Fiscal Year]=pd.[Fiscal Year]
            where dp.CalendarDate < GETDATE() 
			and  PD1.[Date] = convert(date,DATEADD(d,-1, GETDATE()))
				and PD.[Month Number] =  Month(DATEADD(d,-1, GETDATE()))
            group by dp.TouchpointID
                        ,pd.[Fiscal Year] */
            ) as p on p.TouchpointID = eod.TouchpointID AND p.[Fiscal Year] = eod.[Fiscal Year]

    -- Calculate Average 
    DECLARE @dailyAverage DECIMAL(11,2) = (
        Select ROUND(SUM([EOD Value Achieved]) / SUM([EOD Profile]),2) * 100
        FROM @EodPercentage
        GROUP BY [Fiscal Year]
    )
    

    INSERT INTO @funReturn       
    SELECT t1.TouchpointID,
        t1.[Fiscal Year],
        ROUND((eod.[EOD Percentage] /100) * t1.[YTD Profile Value],2) as 'YTD Forecast',
        eod.[EOD Value Achieved],
        eod.[EOD Percentage],
        eod.[EOD Profile],
        eom.[EOM Profile Value],
        eom.[EOM Forecast],
        t1.[YTD Profile Value],
        @dailyAverage as 'Daily Average',
        FORMAT(DATEADD(d,-1, GETDATE()),'d','en-gb') as 'Yesterday'
    
    FROM (SELECT dp.TouchpointID,
                dp.[Fiscal Year],
                t.[EOM Profile Value],
                ROUND((dp.[EOD Percentage] /100) * t.[EOM Profile Value],2) as 'EOM Forecast'
            FROM @EodPercentage as dp
            JOIN 
                (SELECT PF.[TouchpointID] 
                        ,PD.[Fiscal Year]
                        ,SUM(PF.[Financial Profile Total]) AS [EOM Profile Value]
                FROM [PowerBI].[v-dss-pbi-outcomeprofilefact] AS PF
                INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD ON PF.[Date] = PD.[Date] AND PF.[TouchpointID] > 200
				 INNER JOIN [PowerBI].[v-dss-pbi-date] AS  PD1 ON Pd1.[Fiscal Year]=pd.[Fiscal Year]
                WHERE PF.[Outcome ID] in (2,6,11) AND PD.[Month Number] =  (Month(DATEADD(d,-1, GETDATE())) - 1)
				and   PD1.[Date] = convert(date,DATEADD(d,-1, GETDATE()))
                Group by PF.[TouchpointID] 
                         ,PD.[Fiscal Year]
                ) as t ON t.TouchpointID = dp.TouchpointID AND t.[Fiscal Year] = dp.[Fiscal Year]
        ) AS eom
        INNER JOIN 
            (SELECT
                PF.[TouchpointID] 
                , PD.[Fiscal Year]
                , SUM(PF.[Financial Profile YTD]) AS [YTD Profile Value]
            FROM [PowerBI].[v-dss-pbi-outcomeprofilefact] AS PF
                INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD ON PF.[Date] = PD.[Date] AND PF.[TouchpointID] > 200
                INNER JOIN [PowerBI].[dss-pbi-financialyear] AS FY ON FY.FinancialYear = PD.[Fiscal Year]
            WHERE PF.[Outcome ID] in (2,6,11) AND PD.[Month Number] =  Month(FY.EndDateTime)
            Group by PF.[TouchpointID] ,PD.[Fiscal Year]
            ) as t1 ON eom.TouchpointID = t1.TouchpointID and eom.[Fiscal Year] = t1.[Fiscal Year]
        INNER JOIN @EodPercentage as eod on eod.TouchpointID = t1.TouchpointID and eod.[Fiscal Year] = t1.[Fiscal Year];
    RETURN
END
