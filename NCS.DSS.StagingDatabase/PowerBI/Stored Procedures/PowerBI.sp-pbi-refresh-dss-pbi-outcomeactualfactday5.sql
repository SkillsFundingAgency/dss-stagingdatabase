CREATE PROCEDURE [PowerBI].[sp-pbi-refresh-dss-pbi-outcomeactualfactday5](@pr1 int)
AS
BEGIN
    DECLARE @CalendarDate DATE = 
(
	SELECT MY.CalendarDate
	FROM 
	(
		SELECT CalendarDate, ROW_NUMBER() OVER(PARTITION BY CalendarYear, MonthId ORDER BY DateID) AS ROW_NUM 
			FROM [PowerBI].[dss-pbi-date]
		WHERE WeekDay = 1 
		AND BankHoliday = 0
		AND MonthID = MONTH(GETDATE())
		AND CalendarYear = YEAR(GETDATE())
	) AS MY 
	WHERE MY.ROW_NUM = 5
)

IF @CalendarDate = CONVERT(DATE, GETDATE())
BEGIN
	TRUNCATE TABLE [PowerBI].[dss-pbi-outcome]
	;
	INSERT INTO [PowerBI].[dss-pbi-outcome]
	SELECT * FROM [PowerBI].[v-dss-pbi-outcome]
	;
	TRUNCATE TABLE [PowerBI].[dss-pbi-outcomeactualvolume]
	;
	INSERT INTO [PowerBI].[dss-pbi-outcomeactualvolume]
	SELECT * FROM [PowerBI].[v-dss-pbi-outcomeactualvolume]
	;
	DELETE FROM [PowerBI].[dss-pbi-outcomeactualfactday5] 
	WHERE [DATE] >= DATEADD(d, 1, EOMONTH(@CalendarDate, -2))
	;
	INSERT INTO [PowerBI].[dss-pbi-outcomeactualfactday5] 
	SELECT * FROM [PowerBI].[v-dss-pbi-outcomeactualfact]
	WHERE [DATE] = DATEADD(d, 1, EOMONTH(@CalendarDate, -2))
END; 


END
GO
