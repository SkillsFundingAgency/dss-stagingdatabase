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
    --EOD Actual B198(B12-B114)---
	--B12--
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
				WHERE AF.[Outcome ID] in (2,6,11,8) 
                AND PD.[Month Number] =  Month(DATEADD(d,-1, GETDATE()))
				and  PD1.[Date] = convert(date,DATEADD(d,-1, GETDATE()))
				GROUP BY  AF.[TouchpointID] 
						,PD.[Fiscal Year] 
		--B12 end--
		) AS A 
		LEFT OUTER JOIN 
		(
		--B114--
		SELECT
					AF.[TouchpointID] 
					, AF.[FinancialYear] AS [Fiscal Year]
					,SUM(IsNull(AF.[PaymentMade],0)) AS [EOD Value Achieved]									
				FROM [PowerBI].[dss-pbi-actualpaymentsmade] AS AF 
			  WHERE								
				AF.[FinancialYear]=(select top 1[Fiscal Year] from [PowerBI].[v-dss-pbi-date]  where CurrentYear=1)
				AND AF.[TouchpointID] > 200 
				GROUP BY  AF.[TouchpointID] 
				,AF.[FinancialYear] 
		--B114--     
	 ) AS B 
		ON A.[TouchpointID] = B.[TouchpointID] 
		AND A.[Fiscal Year] = B.[Fiscal Year]
                ) as eod 
		-- EOD Actual end---

        JOIN (
		-- EOd profile B199(B193-b164)
				SELECT 
					A.[TouchpointID]
					, A.[Fiscal Year]
					, A.[ProfileToday] - B.[ProfileValue] AS [ProfileToday]
				FROM 
				(
				--B93 To correct--
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
				--B164--
				  SELECT  [TouchPointId],[ProfileValue],pd.[FinancialYear]
				  FROM [PowerBI].[dss-5thworkingDayProfile] PD 
				  INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD1 ON Pd1.[Fiscal Year]=pd.[FinancialYear]
				  AND PD1.[Fiscal Month Number] = pd.MonthID
				  AND PD.MonthID = Month(DATEADD(d,-1, GETDATE()))
				  Group by [TouchPointId],[ProfileValue],pd.[FinancialYear],pd.MonthID
				) AS B
				ON A.[TouchpointID]  = B.[TouchpointID] 
				AND A.[Fiscal Year] = B.FinancialYear
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
                (
                --EOM Profile B205(B11-B164)
                SELECT 
					A.[TouchpointID]
					, A.[Fiscal Year]
					, A.[ProfileCategoryValue]  - B.[ProfileValue]  AS [EOM Profile Value]
				FROM 
				( --B11--
	SELECT 
		AF.[TouchpointID] 
		 ,PD.[Fiscal Year]
		,SUM(AF.[Financial Profile YTD]) AS [ProfileCategoryValue] 
	FROM [PowerBI].[v-dss-pbi-outcomeprofilefact] AS AF 
	INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD 
	ON AF.[Date] = PD.[Date] 
	inner join [powerbi].[dss-pbi-financialyear] as fy
on fy.FinancialYear=pd.[Fiscal Year]
	WHERE AF.[Outcome ID] = 10 --Sum total of all payable values 
	and fy.CurrentYear=1
       AND PD.[Month Number] =  Month(DATEADD(d,-1, GETDATE()))
	GROUP BY 
		AF.[TouchpointID] 
		,PD.[Date] 
		,PD.[Fiscal Year] --B11 end

			) AS A 
				LEFT OUTER JOIN 
				(-- b164 .
				  SELECT  [TouchPointId],[ProfileValue],pd.[FinancialYear]
				  FROM [PowerBI].[dss-5thworkingDayProfile] PD 
				  INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD1 ON Pd1.[Fiscal Year]=pd.[FinancialYear]
				  AND PD1.[Fiscal Month Number] = pd.MonthID
				  AND PD.MonthID = Month(DATEADD(d,-1, GETDATE()))
				  Group by [TouchPointId],[ProfileValue],pd.[FinancialYear],pd.MonthID
				) AS B
				ON A.[TouchpointID]  = B.[TouchpointID] 
				AND A.[Fiscal Year] = B.FinancialYear
                 --EOM Profile B205(B11-B164) end
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
            WHERE PF.[Outcome ID] in (2,6,11,8) AND PD.[Month Number] =  Month(FY.EndDateTime)
            Group by PF.[TouchpointID] ,PD.[Fiscal Year]
            ) as t1 ON eom.TouchpointID = t1.TouchpointID and eom.[Fiscal Year] = t1.[Fiscal Year]
        INNER JOIN @EodPercentage as eod on eod.TouchpointID = t1.TouchpointID and eod.[Fiscal Year] = t1.[Fiscal Year];
    RETURN
END