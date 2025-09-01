CREATE PROCEDURE [dbo].[GDPR_Identify_customers_for_redaction]

AS 
BEGIN
    DECLARE @DAYS_TO_FINANCIAL_DATE AS INT = DATEDIFF(day, DATEFROMPARTS(YEAR(GETDATE()), 4, 5), GETDATE());
    DECLARE @FINANCIAL_YEAR_OFSET AS INT = IIF(@DAYS_TO_FINANCIAL_DATE>=0,6,7) -- Need to subtract 7 years if date before this calendar year's financial year start
    DECLARE @HISTORICAL_FINANCIAL_YEAR_START AS DATE = DATEFROMPARTS(YEAR(GETDATE())-@FINANCIAL_YEAR_OFSET, 4, 5)

    SELECT id
    FROM [dss-customers]
    WHERE id IN (
        SELECT I.CustomerId
        FROM (
            SELECT CustomerId, MAX(DateandTimeOfInteraction) AS LatestInteraction
            FROM [dss-interactions]
            GROUP BY CustomerId
        ) I
        WHERE I.LatestInteraction <=  @HISTORICAL_FINANCIAL_YEAR_START
    )
END