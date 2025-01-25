CREATE PROCEDURE [PowerBI].[SP_Upsert_5thWorkingDayProfile]
    @TouchPointId INT,
    @FinancialYear INT,
    @MonthID INT,
    @ProfileValue decimal(18, 5)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE [PowerBI].[SP_Upsert_5thWorkingDayProfile] AS Target
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
        VALUES (@TouchPointId, @FinancialYear, @MonthID, @ProfileValue);
END;
GO

