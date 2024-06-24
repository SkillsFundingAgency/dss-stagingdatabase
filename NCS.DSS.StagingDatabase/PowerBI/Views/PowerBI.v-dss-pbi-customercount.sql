
CREATE VIEW [PowerBI].[v-dss-pbi-customercount] WITH SCHEMABINDING 
AS 
    WITH RelevantData AS (
        SELECT	
        RIGHT(AP.CreatedBy, 3) AS TouchpointID,
        AP.CustomerId AS CustomerID,
        AP.id AS ActionPlanId,
        P.PriorityGroup AS PriorityCustomer,
        AP.DateActionPlanCreated AS DateActionPlanCreated,
        CASE WHEN P.PriorityGroup IN (1, 2, 3, 4, 5, 6) OR (ep.EconomicShockStatus = 2 AND ep.EconomicShockCode LIKE 'Aspen%') THEN 'PG' ELSE 'NP' END AS PriorityOrNot,
        CASE WHEN MONTH(AP.DateActionPlanCreated) < 4 THEN MONTH(AP.DateActionPlanCreated) + 9 ELSE MONTH(AP.DateActionPlanCreated) - 3 END AS PeriodMonth,
        CASE WHEN MONTH(AP.DateActionPlanCreated) < 4 THEN CONCAT(YEAR(AP.DateActionPlanCreated) - 1, '-', YEAR(AP.DateActionPlanCreated)) ELSE CONCAT(YEAR(AP.DateActionPlanCreated), '-', YEAR(AP.DateActionPlanCreated) + 1) END AS PeriodYear,
        (CONVERT(INT, CONVERT(CHAR(8), AP.DateActionPlanCreated, 112)) - CONVERT(CHAR(8), C.DateofBirth, 112)) / 10000 AS Age,
        RANK() OVER (PARTITION BY AP.CustomerID, CASE WHEN MONTH(AP.DateActionPlanCreated) < 4 THEN CONCAT(YEAR(AP.DateActionPlanCreated) - 1, '-', YEAR(AP.DateActionPlanCreated)) ELSE CONCAT(YEAR(AP.DateActionPlanCreated), '-', YEAR(AP.DateActionPlanCreated) + 1) END ORDER BY AP.DateActionPlanCreated, AP.LastModifiedDate, P.PriorityGroup, RIGHT(AP.CreatedBy, 3)) AS RankID
    FROM [dbo].[dss-actionplans] AS AP 
        INNER JOIN [dbo].[dss-customers] AS C ON C.id = AP.CustomerId
	    LEFT JOIN [dbo].[dss-outcomes] AS DO ON DO.[ActionPlanId] = AP.[id]
        LEFT JOIN [dbo].[dss-prioritygroups] AS P ON P.CustomerId = AP.CustomerId
	    LEFT JOIN [dbo].[dss-employmentprogressions] ep on ep.CustomerId = C.id AND ep.DateProgressionRecorded BETWEEN DATEADD(MONTH, -12, DO.OutcomeEffectiveDate) AND DO.OutcomeEffectiveDate
	    INNER JOIN PowerBI.[dss-pbi-financialyear] AS DR ON AP.DateActionPlanCreated BETWEEN DR.StartDateTime AND DR.EndDateTime --AND DR.CurrentYear = 1
    WHERE (C.ReasonForTermination IS NULL OR C.ReasonForTermination <> 3)
    )
	    SELECT [TouchpointID]
          ,[PeriodYear]
          ,[PeriodMonth]
          ,[PriorityOrNot]
          ,[CustomerCount]
      FROM [PowerBI].[pfy-dss-pbi-customercount]
      union all
    SELECT	
        R.TouchpointID,
        R.PeriodYear,
        R.PeriodMonth,
        R.PriorityOrNot,
        COUNT(DISTINCT R.CustomerID) AS CustomerCount
    FROM RelevantData AS R
    WHERE (R.Age >= 19 OR (R.PriorityCustomer = 1 AND R.Age >= 18 AND R.Age <= 24))
       -- AND R.TouchpointID = 201
     --AND R.PriorityOrNot = 'PG'
        AND R.RankID = 1 
    GROUP BY R.TouchpointID, R.PeriodYear, R.PeriodMonth, R.PriorityOrNot;
;
GO