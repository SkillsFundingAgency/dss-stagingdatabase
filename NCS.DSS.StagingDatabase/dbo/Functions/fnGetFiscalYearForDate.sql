﻿CREATE FUNCTION [dbo].[fnGetFiscalYearForDate]
(   
	@date       datetime
)
RETURNS char(4)
AS
BEGIN   

RETURN
	CASE WHEN MONTH(@date) <= 4 THEN
	SUBSTRING(CAST (YEAR(@date)-1 AS VARCHAR(4)), 3, 2) + SUBSTRING(CAST(YEAR(@date) AS VARCHAR(4)), 3, 2)
	ELSE
	SUBSTRING(CAST (YEAR(@date) AS VARCHAR(4)), 3, 2) + SUBSTRING(CAST(YEAR(@date) + 1 AS VARCHAR(4)), 3, 2)
	END

END