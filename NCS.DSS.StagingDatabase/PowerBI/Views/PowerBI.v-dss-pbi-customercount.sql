
CREATE VIEW [PowerBI].[v-dss-pbi-customercount] WITH SCHEMABINDING 
AS 
    SELECT	
        MY.TouchpointID 
        ,MY.PeriodYear 
        ,MY.PeriodMonth 
        ,MY.PriorityOrNot 
        ,COUNT(DISTINCT MY.CustomerID) AS 'CustomerCount'
    FROM
    (
        SELECT 
            O.CustomerID
            ,O.ActionPlanId
            ,O.PriorityCustomer
            ,CAST(O.DateActionPlanCreated AS Date) AS 'CSO_Date'
            ,O.TouchpointID
            ,O.PriorityOrNot
            ,O.PeriodMonth
            ,O.PeriodYear
            ,O.Age
        FROM
        (
            SELECT	
                RIGHT(AP.CreatedBy, 3)												AS 'TouchpointID'
                ,AP.CustomerId														AS 'CustomerID'
                ,AP.id																AS 'ActionPlanId' 
                ,P.PriorityGroup													AS 'PriorityCustomer'
                ,AP.DateActionPlanCreated											AS 'DateActionPlanCreated'
                ,CASE WHEN IIF(p.PriorityGroup IN (1, 2, 3, 4, 5, 6), 1, 0) = 1
                    THEN 'PG' --Groups 1 to 6
                    ELSE 'NP' --should be none in this group
                END	 																AS 'PriorityOrNot'
                ,CASE WHEN MONTH(DateActionPlanCreated) < 4 
                    THEN MONTH(DateActionPlanCreated) + 9
                    ELSE MONTH(DateActionPlanCreated) - 3
                END																	AS 'PeriodMonth'
                ,CASE WHEN MONTH(DateActionPlanCreated) < 4 
                    THEN CONCAT(CAST(YEAR(DateActionPlanCreated) - 1 AS VARCHAR), '-', CAST(YEAR(DateActionPlanCreated) AS VARCHAR))  
                    ELSE CONCAT(CAST(YEAR(DateActionPlanCreated) AS VARCHAR), '-', CAST(YEAR(DateActionPlanCreated) + 1 AS VARCHAR)) 
                END																	AS 'PeriodYear'
                ,(CONVERT(INT, CONVERT(CHAR(8), AP.DateActionPlanCreated, 112)) 
                    - CONVERT(CHAR(8), C.DateofBirth, 112)) / 10000 AS 'Age'
                ,RANK() OVER(PARTITION BY AP.CustomerID
                    ORDER BY AP.DateActionPlanCreated, AP.LastModifiedDate, P.PriorityGroup, RIGHT(AP.CreatedBy, 3)) AS 'RankID'
            FROM [dbo].[dss-actionplans] AS AP 
            INNER JOIN [dbo].[dss-customers] AS C 
            ON C.id = AP.CustomerId
            LEFT JOIN [dbo].[dss-prioritygroups] AS P 
            ON P.CustomerId = AP.CustomerId
            WHERE AP.DateActionPlanCreated >= CONVERT(DATETIME, '01-10-2022', 103) -- effective between period start and end date and time
        ) AS O
        WHERE O.TouchpointID NOT IN (999, 000, 101, 102, 103, 104, 105, 106, 107, 108, 109) --exclude NCH (helpline) and test touchpoint
        AND ((O.Age >= 19) OR (O.PriorityCustomer = 1 AND O.Age >= 18 AND O.Age <= 24))
        AND O.[RankID] = 1
    ) AS MY 
    GROUP BY   
        MY.TouchpointID 
        ,MY.PeriodYear 
        ,MY.PeriodMonth 
        ,MY.PriorityOrNot 
;
GO