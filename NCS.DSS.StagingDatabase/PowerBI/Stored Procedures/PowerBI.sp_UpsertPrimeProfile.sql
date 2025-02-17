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
AS BEGIN
    SET NOCOUNT ON;

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
	
	IF LOWER(@ProfileCategory) NOT IN ('cmr', 'cmo','cmd','jo','lo', 'lr','jr','sf')
	BEGIN
     RAISERROR('Invalid ProfileCategory. Allowed values: CMO,CMR,CMD,JO,LO,LR,JR,SF', 16, 1)
     RETURN;
	END
	
	IF LOWER(@PriorityOrNot) IN ('sf') and @PriorityOrNot!=''
	BEGIN
     RAISERROR('Invalid @PriorityOrNot. PriorityOrNot is empty for TargetCategory SF', 16, 1)
     RETURN;
	END

	IF LOWER(@ProfileCategory) IN ('cmo','cmo','cmd','jo','lo','lr','jr') and LOWER(@PriorityOrNot) not in ('pg','np')
	BEGIN
     RAISERROR('Invalid @PriorityOrNot. PriorityOrNot should be either PG,NP for TargetCategory CMO,CMR,CMD,JO,LO,LR,JR', 16, 1)
     RETURN;
	END

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
