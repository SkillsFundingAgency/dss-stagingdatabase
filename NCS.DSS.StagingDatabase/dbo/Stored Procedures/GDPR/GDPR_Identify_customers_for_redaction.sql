CREATE PROCEDURE [dbo].[GDPR_Identify_customers_for_redaction]

AS 
BEGIN
	SELECT id
    FROM [dss-customers]
    WHERE id IN (
        SELECT I.CustomerId
        FROM (
            SELECT CustomerId, MAX(DateandTimeOfInteraction) AS LatestInteraction
            FROM [dss-interactions]
            GROUP BY CustomerId
        ) I
        WHERE I.LatestInteraction <= DATEADD(year, -6, GETDATE())
    )
    AND DateOfRedaction IS NULL;
END