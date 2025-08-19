CREATE VIEW [PowerBI].[v-dss-pbi-outcomeprofilefact] 
AS 
    SELECT 
        PO.[TouchpointID] AS 'TouchpointID'
        ,PD.[Outcome ID] AS 'Outcome ID'
        ,PG.[Group ID] AS 'Group ID'
        ,PT.[DATE] AS 'Date'
        ,Round(PO.[OutcomeNumber],0) AS [Profile total]
	    ,Round(PO.[YTD_OutcomeNumber],0) AS [Profile YTD]
        ,PO.[OutcomeFinance] AS [Financial Profile total]
        ,PO.[YTD_OutcomeFinance] AS [Financial Profile YTD] 
    FROM  [PowerBI].[v-dss-pbi-outcomeprofilefact-summary]  AS PO 
    INNER JOIN [PowerBI].[v-dss-pbi-groupdim] AS PG 
    ON PO.[PriorityOrNot] = PG.[Group abbreviation]
    INNER JOIN [PowerBI].[v-dss-pbi-outcomedim] AS PD 
    ON PO.[ProfileCategory] = PD.[Outcome abbreviation]
    INNER JOIN [PowerBI].[v-dss-pbi-date] AS PT 
    ON PO.[PeriodYear] = PT.[Fiscal Year] 
    AND PO.[PeriodMonth] = PT.[Fiscal Month Number] 
    WHERE DATEPART(DAY, PT.[DATE]) = 1 
    AND PT.[DATE] >= CONVERT(DATETIME, '01-10-2022', 103) 
;
GO
