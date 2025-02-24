Create PROCEDURE [PowerBI].[sp_UpsertActualPaymentsMade]
    @TouchpointID INT,
    @FinancialYear VARCHAR(9),
    @MonthID INT,
    @CategoryName VARCHAR(32),
    @PaymentMade DECIMAL(18,5)
AS
BEGIN

IF @TouchPointId NOT BETWEEN 201 AND 209
    BEGIN
        RAISERROR ('Invalid TouchPointId. It must be between 201 and 209.', 16, 1);
        RETURN;
    END
    
    IF @FinancialYear NOT LIKE '[2][0-9][0-9][0-9]-[2][0-9][0-9][0-9]'
    BEGIN
        RAISERROR ('Invalid FinancialYear format. It must be in YYYY-YYYY format (e.g. 2024-2025).', 16, 1);
        RETURN;
    END

     IF CAST(RIGHT(@FinancialYear, 4) AS INT) <> CAST(LEFT(@FinancialYear, 4) AS INT) + 1
    BEGIN
		RAISERROR ('Invalid FinancialYear range. The second year must be exactly one year apart.', 16, 1);
		RETURN;
	END
	
	IF @MonthID NOT BETWEEN 1 AND 12
    BEGIN
        RAISERROR ('Invalid MonthID. It must be between 1 and 12.', 16, 1);
        RETURN;
    END

	IF LOWER(@CategoryName) NOT IN ('service fee', 'outcome based', 'outcome based manual adjustments')
	BEGIN
     RAISERROR('Invalid CategoryName. Allowed values: Service Fee, Outcome Based, Outcome Based Manual Adjustments', 16, 1)
     RETURN;
	END
	

    UPDATE [PowerBI].[dss-pbi-actualpaymentsmade]
    SET [PaymentMade] = @PaymentMade
    WHERE [TouchpointID] = @TouchpointID
      AND [FinancialYear] = @FinancialYear
      AND [MonthID] = @MonthID
      AND [CategoryName] = @CategoryName;

    IF @@ROWCOUNT = 0
    BEGIN
        INSERT INTO [PowerBI].[dss-pbi-actualpaymentsmade]
            ([TouchpointID], [FinancialYear], [MonthID], [CategoryName], [PaymentMade])
        VALUES
            (@TouchpointID, @FinancialYear, @MonthID, @CategoryName, @PaymentMade);
    END
END