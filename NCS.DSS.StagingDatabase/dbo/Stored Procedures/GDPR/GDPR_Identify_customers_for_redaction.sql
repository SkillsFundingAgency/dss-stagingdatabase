CREATE PROCEDURE [dbo].[GDPR_Identify_customers_for_redaction]

    @TargetYear INT = NULL

AS 
BEGIN
    DECLARE @HISTORICAL_FINANCIAL_YEAR_START AS DATE = DATEFROMPARTS(@TargetYear - 7, 4, 6);
    DECLARE @HISTORICAL_FINANCIAL_YEAR_END AS DATE = DATEFROMPARTS(@TargetYear - 6, 4, 6);

    SELECT id
    FROM [dss-customers]
    WHERE id IN (
        SELECT I.CustomerId
        FROM (
            SELECT CustomerId, MAX(DateandTimeOfInteraction) AS LatestInteraction
            FROM [dss-interactions]
            GROUP BY CustomerId
        ) I
        WHERE I.LatestInteraction >=  @HISTORICAL_FINANCIAL_YEAR_START and I.LatestInteraction < @HISTORICAL_FINANCIAL_YEAR_END
    )
END