CREATE PROCEDURE [PowerBI].[sp_UpdateCustomerCount_PFY]
AS
BEGIN
    -- Truncate the target table
    TRUNCATE TABLE [PowerBI].[pfy-dss-pbi-customercount];

    -- Insert new data into the table
    INSERT INTO [PowerBI].[pfy-dss-pbi-customercount]
    SELECT [TouchpointID],
           [PeriodYear],
           [PeriodMonth],
           [PriorityOrNot],
           [CustomerCount]
    FROM [PowerBI].[v-dss-pbi-customercount-FY] A
    INNER JOIN [PowerBI].[dss-pbi-financialyear] PF ON A.PeriodYear = PF.FinancialYear
    WHERE PF.CurrentYear IS NULL 
      AND [TouchpointID] IS NOT NULL;
END;