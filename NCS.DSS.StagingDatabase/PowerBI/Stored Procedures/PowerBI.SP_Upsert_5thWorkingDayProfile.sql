CREATE PROCEDURE [PowerBI].[sp_Upsert_5thWorkingDayProfile]
    @TouchPointId INT,
    @FinancialYear VARCHAR(9),
    @MonthID INT,
    @ProfileValue decimal(18, 5)
AS
BEGIN
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


	IF @MonthID NOT BETWEEN 1 AND 12
    BEGIN
        RAISERROR ('Invalid MonthID. It must be between 1 and 12.', 16, 1);
        RETURN;
    END

    DECLARE @ActionType NVARCHAR(10);
	DECLARE @InputData NVARCHAR(MAX);

	SET @InputData = CONCAT(
        '{"TouchpointID": "', @TouchPointId, '", ',
        '"FinancialYear": "', @FinancialYear, '", ',
        '"MonthID": "', @MonthID, '", ',
        '"ProfileValue": "', @ProfileValue, '"}'
    );

    MERGE [PowerBI].[dss-5thworkingDayProfile] AS Target
    USING (SELECT @TouchPointId AS TouchPointId, 
                  @FinancialYear AS FinancialYear, 
                  @MonthID AS MonthID) AS Source
    ON Target.TouchPointId = Source.TouchPointId
       AND Target.FinancialYear = Source.FinancialYear
       AND Target.MonthID = Source.MonthID
    WHEN MATCHED THEN
        UPDATE SET ProfileValue = @ProfileValue
    WHEN NOT MATCHED THEN
        INSERT (TouchPointId, FinancialYear, MonthID, ProfileValue)
        VALUES (@TouchPointId, @FinancialYear, @MonthID, @ProfileValue)
    OUTPUT		 		 
		GETDATE() AS LoggedOn,
		'sp_Upsert_5thWorkingDayProfile' AS StoredProcedureName,
		@InputData AS InputParameters,
		$action AS ActionType
	INTO 
        [PowerBI].[dss-pbi-manualinputaudit];


END;