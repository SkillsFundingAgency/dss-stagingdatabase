CREATE FUNCTION [dbo].[fnPriorityCustomer] (@PriorityCustomer int)
RETURNS char(1) AS 
BEGIN 
DECLARE @Result char(1)

SET @Result = 0

IF ISNULL(@PriorityCustomer, 0) > 6
BEGIN
  SET @Result = 1
END

Return @Result
END