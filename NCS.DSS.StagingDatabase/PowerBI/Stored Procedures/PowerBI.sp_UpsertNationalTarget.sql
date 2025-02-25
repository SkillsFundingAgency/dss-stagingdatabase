CREATE PROCEDURE [PowerBI].[sp_UpsertNationalTarget]
    @FinancialYear VARCHAR(9),
    @ContractYear VARCHAR(9),
    @PeriodMonth INT,
    @PriorityOrNot VARCHAR(2),
    @TargetCategory VARCHAR(10),
    @TargetCategoryValue DECIMAL(8,5),
    @Comments VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

	
    
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

	IF @ContractYear NOT LIKE '[2][0-9][0-9][0-9]-[2][0-9][0-9][0-9]'
    BEGIN
        RAISERROR ('Invalid FinancialYear format. It must be in YYYY-YYYY format (e.g. 2024-2025).', 16, 1);
        RETURN;
    END
	
	IF @PeriodMonth NOT BETWEEN 1 AND 12
    BEGIN
        RAISERROR ('Invalid MonthID. It must be between 1 and 12.', 16, 1);
        RETURN;
    END

	IF LOWER(@TargetCategory) NOT IN ('cmo', 'jo','lo', 'sf')
	BEGIN
     RAISERROR('Invalid TargetCategory. Allowed values: CMO,JO,LO,SF', 16, 1)
     RETURN;
	END
	
	IF LOWER(@TargetCategory) IN ('sf') and @PriorityOrNot!=''
	BEGIN
     RAISERROR('Invalid @PriorityOrNot. PriorityOrNot is empty for TargetCategory SF', 16, 1)
     RETURN;
	END

	IF LOWER(@TargetCategory) IN ('cmo','jo','lo') and LOWER(@PriorityOrNot) not in ('pg','np')
	BEGIN
     RAISERROR('Invalid @PriorityOrNot. PriorityOrNot should be either PG,NP for TargetCategory CMO,JO,LO', 16, 1)
     RETURN;
	END

    DECLARE @ActionType NVARCHAR(10);
	DECLARE @InputData NVARCHAR(MAX);

	SET @InputData = CONCAT(
		'{"FinancialYear": "', @FinancialYear, '", ',
		'"ContractYear": "', @ContractYear, '", ',
		'"PeriodMonth": "', @PeriodMonth, '", ',
		'"PriorityOrNot": "', @PriorityOrNot, '", ',
		'"TargetCategory": "', @TargetCategory, '", ',
		'"TargetCategoryValue": "', @TargetCategoryValue, '", ',
		'"Comments": "', @Comments, '"}'
	);
	
    MERGE INTO [PowerBI].[dss-pbi-nationaltarget] AS target
    USING (
        VALUES
            (@FinancialYear,
            @ContractYear,
            @PeriodMonth,
            @PriorityOrNot,
            @TargetCategory,
            @TargetCategoryValue,
            @Comments)
    ) AS source (FinancialYear, ContractYear, PeriodMonth, PriorityOrNot, TargetCategory, TargetCategoryValue, Comments)
    ON (target.FinancialYear = source.FinancialYear AND
        target.ContractYear = source.ContractYear AND
        target.PeriodMonth = source.PeriodMonth AND
        target.PriorityOrNot = source.PriorityOrNot AND
        target.TargetCategory = source.TargetCategory)
    WHEN MATCHED THEN
        UPDATE SET 
            target.TargetCategoryValue = source.TargetCategoryValue,
            target.Comments = source.Comments
    WHEN NOT MATCHED THEN
        INSERT ([FinancialYear], [ContractYear], [PeriodMonth], [PriorityOrNot], [TargetCategory], [TargetCategoryValue], [Comments])
        VALUES (source.FinancialYear, source.ContractYear, source.PeriodMonth, source.PriorityOrNot, source.TargetCategory, source.TargetCategoryValue, source.Comments)
    OUTPUT		 		 
		GETDATE() AS LoggedOn,
		'sp_UpsertNationalTarget' AS StoredProcedureName,
		@InputData AS InputParameters,
		$action AS ActionType
	INTO 
		[PowerBI].[dss-pbi-manualinputaudit];

    SET NOCOUNT OFF;
END
GO