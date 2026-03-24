CREATE  VIEW [PowerBI].[v-dss-pbi-overall-perffact]
AS
SELECT 
    OA.OutcomeID,
    OA.[Date],
    ROUND((OA.OutcomeNumber / NULLIF(OP.ProfileTotal, 0)) * 100, 2) AS Performance,
    ROUND((OA.YTDOutcomeNumber / NULLIF(OP.ProfileYTD, 0)) * 100, 2) AS PerformanceYTD,
    ROUND((OA.YTDOutcomeNumber / NULLIF(sp.ProfileFullYear, 0)) * 100, 2) AS PerformanceFullYear,
    ROUND((OA.OutcomeFinance / NULLIF(OP.FinancialProfileTotal, 0)) * 100, 2) AS FinancialPerformance,
    ROUND((OA.YTDOutcomeFinance / NULLIF(OP.FinancialProfileYTD, 0)) * 100, 2) AS FinancialPerformanceYTD,
    ROUND((OA.YTDOutcomeFinance / NULLIF(sp.FinancialProfileFullYear, 0)) * 100, 2) AS FinancialPerformanceFullYear
FROM PowerBI.OutcomeActualAgg OA
JOIN PowerBI.OutcomeProfileAgg OP
    ON OP.OutcomeID = OA.OutcomeID
    AND OP.[Date] = OA.[Date]
JOIN [PowerBI].[ProfileSummaryAgg] sp
    ON sp.OutcomeID = OA.OutcomeID
    AND sp.[Date] = OA.[Date];
GO



