CREATE FUNCTION [dbo].[fnYearsOld] (@DOB datetime, @CurrentDate datetime)
RETURNS varchar(3) AS 
BEGIN 
DECLARE @YearsOld varchar(3)

SET @DOB = ISNULL(@DOB, GETDATE())

Set @YearsOld = Year(@CurrentDate) - Year(@DOB) - 
(CASE WHEN CONVERT(datetime,
CONVERT(varchar(50),YEAR(@CurrentDate))
+'-'+
CONVERT(varchar(50),MONTH(@DOB))
+'-'+
CONVERT(varchar(50),DAY(@DOB)))
> @CurrentDate THEN 1 ELSE 0 END)
Return @YearsOld
END
