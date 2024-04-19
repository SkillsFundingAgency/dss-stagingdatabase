CREATE PROCEDURE [dbo].[GDPR_Anonymise_customer_information]
AS
BEGIN
    BEGIN TRANSACTION

    -- Drops the temporary table with the name #IdentifiedCustomers
    IF OBJECT_ID('tempDB..#IdentifiedCustomers', 'U') IS NOT NULL   
    DROP TABLE #IdentifiedCustomers

    -- Create temporary table for identified customers
    CREATE TABLE #IdentifiedCustomers (CustomerId UNIQUEIDENTIFIER PRIMARY KEY)

    -- Identify customers for redaction and store in the temporary table
    INSERT INTO #IdentifiedCustomers
    EXEC GDPR_Identify_customers_for_redaction

    UPDATE [dss-customers]
    SET Title = NULL,
        GivenName = NULL,
        FamilyName = NULL,
        IntroducedByAdditionalInfo = NULL,
        DateofBirth = DATEFROMPARTS(YEAR(DateOfBirth), 1, 1),
        DateOfRedaction = GETDATE()
    FROM [dss-customers] c
        JOIN #IdentifiedCustomers I
            ON c.id = I.CustomerId;

    UPDATE [dss-contacts]
    SET MobileNumber = NULL,
        AlternativeNumber = NULL,
        HomeNumber = NULL,
        EmailAddress = NULL
    FROM [dss-contacts] c
        JOIN #IdentifiedCustomers I
            ON c.CustomerId = I.CustomerId;

    UPDATE [dss-addresses]
    SET Address1 = NULL,
        Address2 = NULL,
        Address3 = NULL,
        Address4 = NULL,
        Address5 = NULL,
        Longitude = NULL,
        Latitude = NULL,
        PostCode = 
                    CASE 
                    WHEN LEN(PostCode) >= 3 
                    THEN LEFT(PostCode, LEN(PostCode) - 3) 
                    ELSE PostCode 
                    END,
        AlternativePostCode = 
                            CASE 
                            WHEN LEN(AlternativePostCode) >= 3 
                            THEN LEFT(AlternativePostCode, LEN(AlternativePostCode) - 3) 
                            ELSE AlternativePostCode 
                            END
    FROM [dss-addresses] a
        JOIN #IdentifiedCustomers I
            ON a.CustomerId = I.CustomerId;

    UPDATE [dss-employmentprogressions]
    SET EmployerName = NULL,
        EmployerAddress = NULL,
        EmployerPostcode = NULL
    FROM [dss-employmentprogressions] e
        JOIN #IdentifiedCustomers I
            ON e.CustomerId = I.CustomerId;

    UPDATE [dss-actions]
    SET ActionSummary = NULL,
        SignpostedTo = NULL
    FROM [dss-actions] a
        JOIN #IdentifiedCustomers I
            ON a.CustomerId = I.CustomerId;

    UPDATE [dss-goals]
    SET GoalSummary = NULL
    FROM [dss-goals] g
        JOIN #IdentifiedCustomers I
            ON g.CustomerId = I.CustomerId;

    UPDATE [dss-actionplans]
    SET CurrentSituation = NULL
    FROM [dss-actionplans] a
        JOIN #IdentifiedCustomers I
            ON a.CustomerId = I.CustomerId;

    UPDATE [dss-webchats]
    SET WebChatNarrative = NULL
    FROM [dss-webchats] w
        JOIN #IdentifiedCustomers I
            ON w.CustomerId = I.CustomerId;

    DELETE FROM [dss-customers-history]
    FROM [dss-customers-history] c
        JOIN #IdentifiedCustomers I
            ON c.id = I.CustomerId
    WHERE c.id = I.customerId

    DELETE FROM [dss-contacts-history]
    FROM [dss-contacts-history] c
        JOIN #IdentifiedCustomers I
            ON c.CustomerId = I.CustomerId
    WHERE c.CustomerId = I.customerId

    DELETE FROM [dss-addresses-history]
    FROM [dss-addresses-history] a
        JOIN #IdentifiedCustomers I
            ON a.CustomerId = I.CustomerId
    WHERE a.CustomerId = I.customerId

    DELETE FROM [dss-employmentprogressions-history]
    FROM [dss-employmentprogressions-history] e
        JOIN #IdentifiedCustomers I
            ON e.CustomerId = I.CustomerId
    WHERE e.CustomerId = I.customerId

    DELETE FROM [dss-actions-history]
    FROM [dss-actions-history] a
        JOIN #IdentifiedCustomers I
            ON a.CustomerId = I.CustomerId
    WHERE a.CustomerId = I.customerId

    DELETE FROM [dss-goals-history]
    FROM [dss-goals-history] g
        JOIN #IdentifiedCustomers I
            ON g.CustomerId = I.CustomerId
    WHERE g.CustomerId = I.customerId

    DELETE FROM [dss-actionplans-history]
    FROM [dss-actionplans-history] a
        JOIN #IdentifiedCustomers I
            ON a.CustomerId = I.CustomerId
    WHERE a.CustomerId = I.customerId

    DELETE FROM [dss-webchats-history]
    FROM [dss-webchats-history] w
        JOIN #IdentifiedCustomers I
            ON w.CustomerId = I.CustomerId
    WHERE w.CustomerId = I.customerId

    -- Drop the temporary table
    DROP TABLE #IdentifiedCustomers;

    COMMIT;
END