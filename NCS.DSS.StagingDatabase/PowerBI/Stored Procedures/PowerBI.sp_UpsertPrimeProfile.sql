CREATE PROCEDURE [PowerBI].[sp_UpsertPrimeProfile]
    @TouchpointID VARCHAR(4),
    @FinancialYear VARCHAR(9),
    @ProfileCategory VARCHAR(10),
    @PriorityOrNot VARCHAR(2),
    @FinancialsOrNot BIT,
    @ProfileCategoryValue DECIMAL(9, 2),
    @StartDateTime DATETIME,
    @EndDateTime DATETIME,
    @Comments VARCHAR(MAX),
    @ProfileCategoryValueQ1 DECIMAL(9, 2),
    @ProfileCategoryValueQ2 DECIMAL(9, 2),
    @ProfileCategoryValueQ3 DECIMAL(9, 2)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO [PowerBI].[dss-pbi-primeprofile] AS target
    USING (SELECT 
               @TouchpointID AS TouchpointID, 
               @FinancialYear AS FinancialYear, 
               @ProfileCategory AS ProfileCategory, 
               @PriorityOrNot AS PriorityOrNot, 
               @FinancialsOrNot AS FinancialsOrNot, 
               @ProfileCategoryValue AS ProfileCategoryValue, 
               @StartDateTime AS StartDateTime, 
               @EndDateTime AS EndDateTime, 
               @Comments AS Comments, 
               @ProfileCategoryValueQ1 AS ProfileCategoryValueQ1, 
               @ProfileCategoryValueQ2 AS ProfileCategoryValueQ2, 
               @ProfileCategoryValueQ3 AS ProfileCategoryValueQ3) AS source
    ON (target.TouchpointID = source.TouchpointID AND target.FinancialYear = source.FinancialYear AND target.FinancialsOrNot = source.FinancialsOrNot AND target.PriorityOrNot = source.PriorityOrNot  AND target.ProfileCategory = source.ProfileCategory  )
    WHEN MATCHED THEN
        UPDATE SET 
            ProfileCategoryValue = source.ProfileCategoryValue,
            StartDateTime = source.StartDateTime,
            EndDateTime = source.EndDateTime,
            Comments = source.Comments,
            ProfileCategoryValueQ1 = source.ProfileCategoryValueQ1,
            ProfileCategoryValueQ2 = source.ProfileCategoryValueQ2,
            ProfileCategoryValueQ3 = source.ProfileCategoryValueQ3
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (
            TouchpointID,
            FinancialYear,
            ProfileCategory,
            PriorityOrNot,
            FinancialsOrNot,
            ProfileCategoryValue,
            StartDateTime,
            EndDateTime,
            Comments,
            ProfileCategoryValueQ1,
            ProfileCategoryValueQ2,
            ProfileCategoryValueQ3
        )
        VALUES (
            source.TouchpointID,
            source.FinancialYear,
            source.ProfileCategory,
            source.PriorityOrNot,
            source.FinancialsOrNot,
            source.ProfileCategoryValue,
            source.StartDateTime,
            source.EndDateTime,
            source.Comments,
            source.ProfileCategoryValueQ1,
            source.ProfileCategoryValueQ2,
            source.ProfileCategoryValueQ3
        );

END;
GO


