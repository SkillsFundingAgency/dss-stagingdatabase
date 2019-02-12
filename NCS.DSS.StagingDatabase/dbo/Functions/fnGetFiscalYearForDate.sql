IF OBJECT_ID('[dbo].[fnGetFiscalYearForDate]') IS NOT NULL
BEGIN
  DROP FUNCTION [dbo].[fnGetFiscalYearForDate]
END

GO

CREATE FUNCTION [dbo].[fnGetFiscalYearForDate]
(   
@date       datetime
)
RETURNS char(4)
AS
BEGIN   


RETURN '1819'

END