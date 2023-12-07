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
    FROM (
         SELECT
            AF.[TouchpointID] 
            , PD.[Fiscal Year]
            , SUM(AF.[YTD OutcomeFinance]) AS [EOD Value Achieved]
        FROM [PowerBI].[v-dss-pbi-outcomeactualfact] AS AF
            INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD ON AF.[Date] = PD.[Date] AND AF.[TouchpointID] > 200
        WHERE AF.[Outcome ID] in (2,6,11) AND PD.[Month Number] =  Month(DATEADD(d,-1, GETDATE()))
        GROUP BY  AF.[TouchpointID] 
                ,PD.[Fiscal Year]
                ) as eod
        JOIN (Select dp.TouchpointID
                    , pd.[Fiscal Year]
                    , SUM(dp.DailyPerformance) as ProfileToday
                FROM [PowerBI].[v-dss-pbi-daily-performance] as dp
                INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD ON  PD.[Date] = dp.CalendarDate
            --where CalendarDate < GETDATE()
            group by dp.TouchpointID
                        ,pd.[Fiscal Year]
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
                        ,SUM(PF.[Financial Profile YTD]) AS [EOM Profile Value]
                FROM [PowerBI].[v-dss-pbi-outcomeprofilefact] AS PF
                INNER JOIN [PowerBI].[v-dss-pbi-date] AS PD ON PF.[Date] = PD.[Date] AND PF.[TouchpointID] > 200
                WHERE PF.[Outcome ID] in (2,6,11) AND PD.[Month Number] =  Month(DATEADD(d,-1, GETDATE()))
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
        INNER JOIN @EodPercentage as eod on eod.TouchpointID = t1.TouchpointID;
    RETURN
END
GO  