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

    DECLARE @ActionType NVARCHAR(10);
	DECLARE @InputData NVARCHAR(MAX);
	DECLARE @StoredProcedureName NVARCHAR(40) = 'sp_UpsertActualPaymentsMade'

	SET @InputData = CONCAT(
		'{"TouchpointID": "', @TouchPointId, '", ',
		'"FinancialYear": "', @FinancialYear, '", ',
		'"MonthID": "', @MonthID, '", ',
		'"CategoryName": "', @CategoryName, '", ',
		'"PaymentMade": "', @PaymentMade, '"}'
	);
	

    MERGE [PowerBI].[dss-pbi-actualpaymentsmade] AS Target
	USING (
		SELECT 
			@TouchpointID AS TouchpointID,
			@FinancialYear AS FinancialYear,
			@MonthID AS MonthID,
			@CategoryName AS CategoryName,
			@PaymentMade AS PaymentMade
	) AS Source
	ON Target.TouchpointID = Source.TouchpointID
	   AND Target.FinancialYear = Source.FinancialYear
	   AND Target.MonthID = Source.MonthID
	   AND Target.CategoryName = Source.CategoryName
	WHEN MATCHED THEN
		UPDATE SET 
			PaymentMade = Source.PaymentMade
	WHEN NOT MATCHED THEN
		INSERT (
			TouchpointID, 
			FinancialYear, 
			MonthID, 
			CategoryName, 
			PaymentMade
		)
		VALUES (
			Source.TouchpointID,
			Source.FinancialYear,
			Source.MonthID,
			Source.CategoryName,
			Source.PaymentMade
		)
	OUTPUT		 		 
		GETDATE() AS LoggedOn,
		@StoredProcedureName AS StoredProcedureName,
		@InputData AS InputParameters,
		$action AS ActionType
	INTO 
		[PowerBI].[dss-pbi-manualinputaudit];


	-- Remove records from audit table that are older than 13 months
    DELETE FROM [PowerBI].[dss-pbi-manualinputaudit]
    WHERE StoredProcedureName = @StoredProcedureName
        AND LoggedOn < DATEADD(MONTH,-13, GETDATE());

END