CREATE FUNCTION [dbo].[fnDssDate] ()
RETURNS datetime2 AS 
BEGIN 
  RETURN GETDATE() + ISNULL([dbo].[fnGetParameterValueAsInteger]('TimeTravel'), 0)
END
GO
