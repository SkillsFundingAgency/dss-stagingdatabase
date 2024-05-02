-- Update_month_Week_Ref.sql
-- Created by Pradeep
-- Last Modified by Mridul
-- Last Modified Date 07-12-2023

DECLARE @WHILE_LOOP INT = 0;
DECLARE @WHILE_DATE DATETIME = CONVERT(DATETIME, '01-04-2023', 103), @LOOP_DATE DATETIME = CONVERT(DATETIME, '01-04-2023', 103); 

DELETE FROM [PowerBI].[dss-pbi-date] WHERE [CalendarDate] >= @WHILE_DATE AND [CalendarDate] < CONVERT(DATETIME, '01-04-2024', 103) 
;

SET @WHILE_LOOP = 0;

WHILE DATEDIFF(d, DATEADD(d, @WHILE_LOOP, @WHILE_DATE), CONVERT(DATETIME, '01-04-2024', 103)) > 0 
BEGIN
	SET @LOOP_DATE = DATEADD(d, @WHILE_LOOP, @WHILE_DATE);

	INSERT INTO [PowerBI].[dss-pbi-date] 
	(
		[DateID] 
		,[CalendarDate] 
		,[CalendarYear] 
		,[MonthID] 
		,[WeekDay] 
		,[BankHoliday] 
	)
	VALUES 
	(
		CAST(FORMAT(@LOOP_DATE, 'yyyyMMdd') AS INT)
		,@LOOP_DATE 
		,YEAR(@LOOP_DATE) 
		,MONTH(@LOOP_DATE)
		,CASE WHEN DATEPART(WEEKDAY, @LOOP_DATE) IN (1, 7) THEN 0 ELSE 1 END -- 1 is Sunday and 7 is Saturday 
		,0
	)
	;

	SET @WHILE_LOOP = @WHILE_LOOP + 1;
END
;

UPDATE [PowerBI].[dss-pbi-date] 
SET [BankHoliday] = 1 
WHERE [DateID] IN (20230407, 20230410, 20230501, 20230508, 20230529, 20230828, 20231225, 20231226, 20240101, 20240329)

SELECT MonthID,CalendarYear,COUNT(DateID) as 'NoOfDays'
INTO #tmp_dateDays
FROM [PowerBI].[dss-pbi-date]
WHERE [WeekDay]= 1 AND BankHoliday = 0 
AND MonthRefId IS NULL 
GROUP BY MonthID, CalendarYear

-- update monthRefId
UPDATE pd 
SET pd.MonthRefId = mr.MonthRefId
FROM [PowerBI].[dss-pbi-date] as pd
JOIN #tmp_dateDays as td ON td.MonthID = pd.MonthID AND td.CalendarYear = pd.CalendarYear 
JOIN [PowerBI].[dss-pbi-month-ref] as mr ON td.NoOfDays = mr.NoOfDays

DROP TABLE #tmp_dateDays;

DECLARE @minId INT = 1;
DECLARE @maxId INT = 12;
WHILE (@minId <= @maxId)
BEGIN
    -- update weekrefid
    select pd.DateID, pd.MonthID, pd.CalendarYear, pd.monthRefId, mr.NoOfDays, RANK () OVER ( 
                PARTITION BY pd.monthRefId, pd.CalendarYear
                ORDER by pd.DateID
            ) DayId
        INTO #tmp_monthRef
    FROM [PowerBI].[dss-pbi-date] as pd
        JOIN [PowerBI].[dss-pbi-month-ref] mr on mr.MonthRefID = pd.monthRefId
    WHERE pd.[WeekDay]= 1 AND pd.BankHoliday = 0 
        AND pd.MonthID = @minId
	AND pd.WeekRefID IS NULL 
        order by pd.DateID asc

    Declare @inc INT = 1;
    Declare @wDaysCount1 INT = 1;
    Declare @wDaysCount2 INT = 0;
    Declare @monthRef INT = (SELECT Min(MonthRefId)  from #tmp_monthRef where MonthID = @minId)
    WHILE(@inc <= 4)
    BEGIN
        DECLARE @wRefId INT, @wDays INT;

        Select @wRefId = WeekRefID,
                @wDays = NoOfDays 
            from [PowerBI].[dss-pbi-week-ref] 
        where MonthRefID = @monthRef and 
            WeekName like '%Week '+ CONVERT(varchar(2), @inc) + '%' 
        order by WeekRefID asc
        SET @wDaysCount2 = @wDaysCount2 + @wDays;

        UPDATE pd
           SET WeekRefID = @wRefId 
        FROM [PowerBI].[dss-pbi-date] as pd
            JOIN #tmp_monthRef as tm on tm.MonthID = pd.MonthID and tm.CalendarYear = pd.CalendarYear and tm.DateID = pd.DateID
        WHERE tm.DayId BETWEEN @wDaysCount1 AND @wDaysCount2
            AND tm.MonthRefID = @monthRef
        SET @wDaysCount1 = @wDaysCount2 + 1;
        SET @inc = @inc + 1;
    END


    SET @minId = @minId + 1;
    DROP TABLE #tmp_monthRef;
END

-- End of Script

