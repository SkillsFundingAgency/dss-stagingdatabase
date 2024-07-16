CREATE PROCEDURE [PowerBI].[sp_UpsertNationalTarget]
    @FinancialYear VARCHAR(9),
    @ContractYear VARCHAR(9),
    @PeriodMonth INT,
    @PriorityOrNot VARCHAR(2),
    @TargetCategory VARCHAR(10),
    @TargetCategoryValue DECIMAL(5,2),
    @Comments VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

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
        VALUES (source.FinancialYear, source.ContractYear, source.PeriodMonth, source.PriorityOrNot, source.TargetCategory, source.TargetCategoryValue, source.Comments);

    SET NOCOUNT OFF;
END
GO
