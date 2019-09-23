-------------------------------------------------------------------------------
-- Authors:      Kevin Brandon
-- Created:      05/09/2019
-- Purpose:      Provide a single point to call to get reference data value.
--  
-------------------------------------------------------------------------------
-- Modification History
-- Added null check, returning default value
-- Initial creation.
-- 
--            
-- Copyright © 2019, ESFA, All Rights Reserved
-------------------------------------------------------------------------------
CREATE FUNCTION [dbo].[udf_GetReferenceDataValue]( @resource VARCHAR(50), @name VARCHAR(50), @criteria INT, @default VARCHAR(50) )
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @ret varchar(50);

	if (COALESCE(@criteria, 0) = 0 )
		SET @ret = @default;
	ELSE
	BEGIN
		SELECT @ret = description 
				FROM [DBO].[dss-reference-data]  
				WHERE 
				[DBO].[dss-reference-data].[Resource] = @resource AND 
				[DBO].[dss-reference-data].[name] = @name AND 
				[DBO].[dss-reference-data].[value] = @criteria

		IF (@ret IS NULL) 
			SET @ret = @default;
	END;

	RETURN @ret;
END;