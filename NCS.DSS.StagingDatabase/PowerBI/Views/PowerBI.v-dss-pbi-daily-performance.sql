CREATE VIEW [PowerBI].[v-dss-pbi-daily-performance]
AS
    WITH primeTotals (
        [TouchpointID]
        ,[Outcome ID]
        ,[Date]
        ,[ProfileTotal]
    ) as (
        SELECT [TouchpointID]
        ,[Outcome ID]
        ,[Date]
        ,SUM([Financial Profile total]) as ProfileTotal
    FROM [PowerBI].[v-dss-pbi-outcomeprofilefact]
    Where [Outcome ID] = 10 
    GROUP BY [TouchpointID]
        ,[Outcome ID]
        ,[Date]
    )

    SELECT 
            sp.TouchpointID,
            pd.CalendarDate,
            pd.CalendarYear,
            my.[MonthFullName],
            sp.WeekName,
            ROUND(((pt.ProfileTotal * sp.percentage / 100) / wr.NoOfDays) ,2) as DailyPerformance
    FROM [PowerBI].[dss-pbi-date] as pd 
        JOIN [PowerBI].[dss-pbi-monthsinyear] as my ON my.MonthID = pd.MonthID
        JOIN [PowerBI].[dss-pbi-week-ref] wr on wr.WeekRefID = pd.WeekRefID
        JOIN [PowerBI].[dss-pbi-submission-pattern] as sp on wr.WeekName like '%'+ sp.WeekName +'%' 
        JOIN primeTotals as pt on sp.TouchpointID = pt.[TouchpointID] AND DATEPART(Month, pt.[DATE]) = pd.MonthID 
    WHERE [WeekDay]= 1 
        AND BankHoliday = 0 
    UNION ALL
    SELECT dp.TouchpointID,
            dp.CalendarDate,
            dp.CalendarYear,
            dp.[MonthFullName],
            dp.WeekName,
            dp.DailyPerformance
    FROM (
        SELECT res.TouchpointID,
            res.MonthID,
            res.CalendarDate,
            res.CalendarYear,
            my1.[MonthFullName],
            sp1.WeekName,
            ROUND(((pt1.ProfileTotal * sp1.percentage / 100) / 5) ,2) as DailyPerformance,
            RANK () OVER ( 
                PARTITION BY res.TouchpointID,
                            res.MonthID,
                            res.CalendarYear,
                            my1.[MonthFullName],
                            sp1.WeekName
                ORDER by res.CalendarDate
            ) as RankID 
        FROM (
            SELECT 
                    sp.TouchpointID,
                    IIF(pd.MonthID = 1,12,pd.MonthID - 1) as MonthID,
                    pd.CalendarDate,
                    pd.CalendarYear
            FROM [PowerBI].[dss-pbi-date] as pd
                JOIN [PowerBI].[dss-pbi-monthsinyear] as my on my.MonthID = pd.MonthID
                JOIN [PowerBI].[dss-pbi-week-ref] wr on wr.WeekRefID = pd.WeekRefID 
                JOIN [PowerBI].[dss-pbi-submission-pattern] as sp on wr.WeekName like '%'+ sp.WeekName +'%' and sp.WeekName = 'Week 1'
                JOIN primeTotals as pt on sp.TouchpointID = pt.[TouchpointID] AND DATEPART(Month, pt.[DATE]) = pd.MonthID    
            WHERE [WeekDay]= 1 
                AND BankHoliday = 0 
        ) as res
        JOIN [PowerBI].[dss-pbi-submission-pattern] as sp1 on sp1.WeekName = 'Week 5' and sp1.TouchpointID = res.TouchpointID
        JOIN primeTotals as pt1 on sp1.TouchpointID = pt1.[TouchpointID] AND DATEPART(Month, pt1.[DATE]) = res.MonthID
        JOIN [PowerBI].[dss-pbi-monthsinyear] as my1 on my1.MonthID = res.MonthID
    ) as dp
    WHERE RankID < 6
GO