CREATE PROCEDURE [dbo].[GDPR_Identify_customers_for_redaction]

AS 
BEGIN
    DECLARE @DAYS_TO_FINANCIAL_DATE AS INT = DATEDIFF(day, DATEFROMPARTS(YEAR(GETDATE()), 4, 5), GETDATE());

	SELECT id
    FROM [dss-customers]
    WHERE id IN (
        SELECT I.CustomerId
        FROM (
            SELECT CustomerId, MAX(DateandTimeOfInteraction) AS LatestInteraction
            FROM [dss-interactions]
            GROUP BY CustomerId
        ) I
        WHERE I.LatestInteraction <= DATEADD(DAY, -365.25*6 -@DAYS_TO_FINANCIAL_DATE, GETDATE())
    )
    AND DateOfRedaction IS NULL;
END