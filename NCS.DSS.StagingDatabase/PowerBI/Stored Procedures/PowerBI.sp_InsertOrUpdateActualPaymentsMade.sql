Create PROCEDURE [PowerBI].[sp_InsertOrUpdateActualPaymentsMade]
    @TouchpointID INT,
    @FinancialYear VARCHAR(9),
    @MonthID INT,
    @CategoryName VARCHAR(32),
    @PaymentMade INT
AS
BEGIN

    BEGIN TRANSACTION;

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
    COMMIT TRANSACTION;
END
