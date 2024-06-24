
CREATE VIEW [PowerBI].[v-dss-pbi-customersatisfactioncount] WITH SCHEMABINDING 
AS 
    WITH RelevantData AS (
             SELECT 
                RIGHT(ap.CreatedBy, 3) AS TouchpointID,
                ap.CustomerId AS CustomerID,
                ap.id AS ActionPlanId,
                p.PriorityGroup AS PriorityCustomer,
                ap.DateActionPlanCreated AS DateActionPlanCreated,
                CustomerSatisfaction,
                CASE 
                    WHEN (IIF(p.PriorityGroup IN (1,2,3,4,5,6), 1, 0)) = 1 THEN 'PG'
                    ELSE 'NP'
                END AS PriorityOrNot,
                  CASE WHEN MONTH(AP.DateActionPlanCreated) < 4 THEN MONTH(AP.DateActionPlanCreated) + 9 ELSE MONTH(AP.DateActionPlanCreated) - 3 END AS PeriodMonth,
        CASE WHEN MONTH(AP.DateActionPlanCreated) < 4 THEN CONCAT(YEAR(AP.DateActionPlanCreated) - 1, '-', YEAR(AP.DateActionPlanCreated)) ELSE CONCAT(YEAR(AP.DateActionPlanCreated), '-', YEAR(AP.DateActionPlanCreated) + 1) END AS PeriodYear,
       
                (CONVERT(int, CONVERT(char(8), ap.DateActionPlanCreated, 112)) - CONVERT(char(8), c.DateofBirth, 112)) / 10000 AS Age,
                RANK() OVER (PARTITION BY ap.CustomerID ORDER BY ap.DateActionPlanCreated, ap.LastModifiedDate, p.PriorityGroup, RIGHT(ap.CreatedBy, 3)) AS Rank
            FROM dbo.[dss-actionplans] ap
            INNER JOIN dbo.[dss-customers] c ON c.id = ap.CustomerId
            LEFT JOIN dbo.[dss-prioritygroups] p ON p.CustomerId = ap.CustomerId
		     --Inner JOIN PowerBI.[dss-pbi-financialyear] AS FY ON CAST(ap.DateActionPlanCreated as Date) BETWEEN FY.StartDateTime AND FY.EndDateTime
				WHERE				(CAST(ap.DateActionPlanCreated as Date)	BETWEEN '2023-04-01' AND '2024-03-31'	)


)

 SELECT 
            R.TouchpointID,
            R.PeriodYear,
            R.PeriodMonth,


            COUNT(CASE WHEN CustomerSatisfaction = '1' THEN '1' END) AS Satisfied_Number,
            COUNT(CASE WHEN CustomerSatisfaction <> '1' THEN '1' END) AS Not_satisfied_Number,
            COUNT(*) AS Total,
            CAST((CAST(COUNT(CASE WHEN CustomerSatisfaction = '1' THEN '1' END) AS DECIMAL(10,2))) / CAST(COUNT(*) AS DECIMAL(10,2)) * 100 AS decimal(18, 2)) AS Satisfied_percentage
        FROM RelevantData AS R
			WHERE TouchpointID NOT IN (999, 000, 001, 101, 102, 103, 104, 105, 106, 107, 108, 109)        AND [Rank] = 1 

        GROUP BY TouchpointID, YEAR(DateActionPlanCreated), MONTH(DateActionPlanCreated), R.PeriodYear,R.PeriodMonth



;
GO


