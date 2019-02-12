IF OBJECT_ID('[dbo].[fnGetParameterValueAsInteger]') IS NOT NULL
BEGIN
  DROP FUNCTION [dbo].[fnGetParameterValueAsInteger]
END
GO

CREATE FUNCTION [dbo].[fnGetParameterValueAsInteger] (@ParameterName nvarchar(50))
RETURNS int AS 
BEGIN 
DECLARE @Result int

SELECT TOP 1 @Result = ParameterValue FROM [dss-data-collections-params]
	WHERE ParameterName = @ParameterName

RETURN @Result
END
