IF OBJECT_ID('[dbo].[fnGetParameterValueAsDate]') IS NOT NULL
BEGIN
	DROP FUNCTION [dbo].[fnGetParameterValueAsDate]
END
GO

CREATE FUNCTION [dbo].[fnGetParameterValueAsDate] (@ParameterName nvarchar(50))
RETURNS datetime AS 
BEGIN 
DECLARE @Result datetime

SELECT TOP 1 @Result = ParameterValue FROM [dss-data-collections-params]
	WHERE ParameterName = @ParameterName

RETURN @Result
END

