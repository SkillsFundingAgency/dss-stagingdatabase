CREATE VIEW [PowerBI].[v-dss-pbi-overall-perffact]
AS
SELECT 
    OA.OutcomeID,
    OA.[Date],
    ROUND((OA.OutcomeNumber / NULLIF(PRF.ProfileTotal, 0)) * 100, 2) AS Performance,
    ROUND((OA.YTDOutcomeNumber / NULLIF(PRF.ProfileYTD, 0)) * 100, 2) AS PerformanceYTD,
    ROUND((OA.YTDOutcomeNumber / NULLIF(PSA.ProfileFullYear, 0)) * 100, 2) AS PerformanceFullYear,
    ROUND((OA.OutcomeFinance / NULLIF(PRF.FinancialProfileTotal, 0)) * 100, 2) AS FinancialPerformance,
    ROUND((OA.YTDOutcomeFinance / NULLIF(PRF.FinancialProfileYTD, 0)) * 100, 2) AS FinancialPerformanceYTD,
    ROUND((OA.YTDOutcomeFinance / NULLIF(PSA.FinancialProfileFullYear, 0)) * 100, 2) AS FinancialPerformanceFullYear
FROM [PowerBI].[OutcomeActualAgg] OA
JOIN [PowerBI].[OutcomeProfileAgg] PRF
    ON PRF.OutcomeID = OA.OutcomeID
    AND PRF.[Date] = OA.[Date]
JOIN [PowerBI].[ProfileSummaryAgg] PSA
    ON PSA.OutcomeID = OA.OutcomeID
    AND PSA.[Date] = OA.[Date];

