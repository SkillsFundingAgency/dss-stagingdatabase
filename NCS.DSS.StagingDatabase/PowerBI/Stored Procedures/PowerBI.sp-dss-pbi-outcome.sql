CREATE PROCEDURE [PowerBI].[sp-dss-pbi-outcome]
(
	@ReturnValue INT
)
AS
BEGIN
	IF OBJECT_ID('tempdb..#MY', 'TABLE') IS NOT NULL 
		DROP TABLE #MY;

	SELECT	
		RIGHT(DO.[TouchpointID], 3) AS 'TouchpointID'
		,DO.[CustomerId] AS 'CustomerID'
		,CASE 
			WHEN COALESCE(DO.[IsPriorityCustomer], IIF(DO.[ClaimedPriorityGroup] <= 6, 1, 0)) = 1 THEN 'PG' --Groups 1 to 6
			WHEN COALESCE(DO.[IsPriorityCustomer], IIF(DO.[ClaimedPriorityGroup] <= 6, 1, 0)) = 0 THEN 'NP' --inc 98(unknown) and 99
			ELSE 'UNKNOWN' --should be none in this group
		END	AS 'PriorityOrNot'
		,DS.[id] AS 'SessionID'						
		,CONVERT(DATE, DS.[DateandTimeOfSession])	AS 'SessionDate'
		,DO.[id] AS 'OutcomeID'
		,DO.[OutcomeEffectiveDate] AS 'OutcomeEffectiveDate'
		,DR.[description] AS 'OutcomeType' --Excel only
		,DO.[OutcomeType] AS 'OutcomeTypeValue'						
		,CASE 
			WHEN DO.[OutcomeType] = 1 THEN 'CSO'
			WHEN DO.[OutcomeType] = 2 THEN 'CMO'
			WHEN DO.[OutcomeType] = 4 THEN 'LO'		
			ELSE 'JO'							-- Type 3 or 5
		END AS 'OutcomeTypeGroup' 						
		,DO.[OutcomeClaimedDate] AS 'OutcomeClaimedDate'
		,CASE DO.[OutcomeType] 
			WHEN 3 THEN	DATEADD(mm, 13, DS.[DateandTimeOfSession]) 
			ELSE DATEADD(mm, 12, DS.[DateandTimeOfSession]) 
		END AS 'SessionClosureDate'	--date limit for Effective Outcomes
		,DATEADD(mm, -12, CONVERT(DATE, DS.[DateandTimeOfSession])) AS 'PriorSessionDate'	--12 months before current session (latest possible previous session)
		,RANK() OVER(PARTITION BY DS.[CustomerID], IIF(DS.[DateandTimeOfSession] < CONVERT(DATETIME, '01-10-2022', 103), 100, 0), DO.OutcomeType
				ORDER BY DO.[OutcomeEffectiveDate], DO.[LastModifiedDate], DO.[id]) AS 'SessionRank'  -- we rank to remove duplicates
		-- ##### FUNDING RULES #####		-- JLOs have been split into JOs and LOs since 1/Oct/2020
		,PeriodMonth = CASE 
			WHEN MONTH(DO.[OutcomeEffectiveDate]) < 4 THEN MONTH(DO.[OutcomeEffectiveDate]) + 9
			ELSE MONTH(DO.[OutcomeEffectiveDate]) - 3
		END 
		,CASE
			WHEN MONTH(DO.[OutcomeEffectiveDate]) < 4 
				THEN CONCAT(CAST(YEAR(DO.[OutcomeEffectiveDate]) - 1 AS VARCHAR), '-', CAST(YEAR(DO.[OutcomeEffectiveDate]) AS VARCHAR))  
			ELSE CONCAT(CAST(YEAR(DO.[OutcomeEffectiveDate]) AS VARCHAR), '-', CAST(YEAR(DO.[OutcomeEffectiveDate]) + 1 AS VARCHAR)) 
		END																	AS 'PeriodYear'
	INTO #MY 
	FROM [dbo].[dss-sessions] AS DS
	INNER JOIN [dbo].[dss-customers] AS DC 
	ON DC.[id] = DS.[CustomerId]
	INNER JOIN [dbo].[dss-actionplans] AS DA 
	ON DA.[SessionId] = DS.[id]
	INNER JOIN [dbo].[dss-interactions] AS DI 
	ON DI.[id] = DA.[InteractionId] 
	INNER JOIN [dbo].[dss-outcomes] AS DO 
	ON DO.[ActionPlanId] = DA.[id]
	INNER JOIN [dbo].[dss-reference-data] AS DR 
	ON DR.[value] = DO.[OutcomeType] 
	AND DR.[name] = 'OutcomeType'
	WHERE CAST(DO.[OutcomeEffectiveDate] AS DATE) >= CONVERT(DATETIME, '01-10-2022', 103)		-- effective between period start and end date and time
	AND	CAST(DO.[OutcomeClaimedDate] AS DATE) >= CONVERT(DATETIME, '01-10-2022', 103)		-- claimed between period start and end date and time	               
	;

	IF OBJECT_ID('tempdb..#MY1', 'TABLE') IS NOT NULL 
		DROP TABLE #MY1;

	SELECT 
		MY.[TouchpointID]
		,MY.[CustomerID]
		,MY.[PriorityOrNot]
		,MY.[SessionID]						
		,MY.[SessionDate]
		,MY.[OutcomeID]
		,MY.[OutcomeEffectiveDate]
		,MY.[OutcomeTypeValue]						
		,MY.[OutcomeTypeGroup] 						
		,MY.[OutcomeClaimedDate]
		,MY.[SessionClosureDate]
		,MY.[PriorSessionDate]
		,MY.[SessionRank]
		,MY.[PeriodMonth]
		,MY.[PeriodYear]
		,LAG(MY.[OutcomeTypeValue]) OVER (PARTITION BY MY.[CustomerID] ORDER BY MY.[OutcomeEffectiveDate], MY.[OutcomeTypeValue]) AS [PrevOutcomeType]
	INTO #MY1 
	FROM #MY AS MY
	WHERE MY.[SessionRank] = 1
	;

	TRUNCATE TABLE [PowerBI].[dss-pbi-outcome]
	;

	INSERT INTO [PowerBI].[dss-pbi-outcome] 
	SELECT 
		MY2.[TouchpointID]
		,MY2.[PriorityOrNot]
		,MY2.[OutcomeTypeValue]
		,MY2.[OutcomeTypeGroup]
		,MY2.[PeriodMonth]
		,MY2.[PeriodYear]
		,COUNT(*) AS [OutcomeNumber] 
	FROM 
	(
		SELECT 
			MY1.[TouchpointID]
			,MY1.[CustomerID]
			,MY1.[PriorityOrNot]
			,MY1.[SessionID]						
			,MY1.[SessionDate]
			,MY1.[OutcomeID]
			,MY1.[OutcomeEffectiveDate]
			,MY1.[OutcomeTypeValue]						
			,MY1.[OutcomeTypeGroup] 						
			,MY1.[OutcomeClaimedDate]
			,MY1.[SessionClosureDate]
			,MY1.[PriorSessionDate]
			,MY1.[SessionRank]
			,MY1.[PeriodMonth]
			,MY1.[PrevOutcomeType]
			,MY1.[PeriodYear]
		FROM #MY1 AS MY1 
		WHERE 
		(
			(MY1.[OutcomeTypeValue] IN (1, 2, 4) 
			AND CONVERT(DATE, MY1.OutcomeEffectiveDate) <= MY1.SessionClosureDate								-- within 12 or 13 months of the session date date
			AND MY1.TouchpointID <> '999' --exclude NCH (helpline)
			AND	NOT EXISTS 
				(
					SELECT priorO.id
					FROM [dbo].[dss-sessions] AS priorS
					INNER JOIN [dbo].[dss-outcomes] AS priorO 
					ON priorS.id = priorO.SessionId
					WHERE priorO.[id] <> MY1.[OutcomeID]
					AND	priorO.[OutcomeEffectiveDate] < MY1.[OutcomeEffectiveDate]
					AND	priorO.[OutcomeClaimedDate] IS NOT NULL		-- and claimed
					AND	priorO.[CustomerId] = MY1.[CustomerId]			-- and they belong to the same customer
					AND	RIGHT(priorO.[TouchpointId], 3) <> '999'		-- and previous touchpoint was not helpline
					AND	CONVERT(DATE, priorS.[DateandTimeOfSession]) > MY1.[PriorSessionDate]	-- and the prior session date is more then 12 months before current session date
					AND	
					(	-- check validity of the previous outcomes we are considering
						(	-- the previous outcome should have been claimed within 13 months of the previous session date for Outcome Type 3 
							MY1.[OutcomeTypeValue] = 3							
							AND DATEADD(mm, 13, CONVERT(DATE, priorS.[DateandTimeOfSession])) >= CONVERT(DATE, priorO.[OutcomeEffectiveDate])
						)
						OR	-- the previous outcome should have been claimed within 12 months of the previous session date for Outcome Types 1,2,4,5
						(
							MY1.[OutcomeTypeValue] IN (1, 2, 4, 5)			
							AND DATEADD(mm, 12, CONVERT(DATE, priorS.[DateandTimeOfSession])) >= CONVERT(DATE, priorO.[OutcomeEffectiveDate])
						)														
					)
					AND	
					(
						(	-- check there are no Outcomes of the same type (CSO and CMO)
							MY1.[OutcomeTypeValue] IN (1, 2)
							AND	MY1.[OutcomeTypeValue] = priorO.[OutcomeType]
						)
					OR
						(	-- check there are no outcomes of the same type (JLO)
							MY1.[OutcomeTypeValue] IN (3, 5)
							AND priorO.[OutcomeType] IN (3, 5)
						)
					)
				)
			)
			OR (MY1.[OutcomeTypeValue] = 3 AND MY1.[PrevOutcomeType] IS  NULL)
			OR (MY1.[OutcomeTypeValue] = 3 AND MY1.[PrevOutcomeType] <> 5)
			OR (MY1.[OutcomeTypeValue] = 5 AND MY1.[PrevOutcomeType] IS  NULL)
			OR (MY1.[OutcomeTypeValue] = 5 AND MY1.[PrevOutcomeType] <> 3)
		)
	) AS MY2 
	GROUP BY 
		MY2.[TouchpointID]
		,MY2.[PriorityOrNot]
		,MY2.[OutcomeTypeValue]
		,MY2.[OutcomeTypeGroup]
		,MY2.[PeriodMonth]
		,MY2.[PeriodYear]
	ORDER BY 
		MY2.[TouchpointID]
		,MY2.[PeriodYear]
		,MY2.[PeriodMonth]
		,MY2.[PriorityOrNot]
		,MY2.[OutcomeTypeGroup]
		,MY2.[OutcomeTypeValue]
	;

	IF OBJECT_ID('tempdb..#MY', 'TABLE') IS NOT NULL 
		DROP TABLE #MY;

	IF OBJECT_ID('tempdb..#MY1', 'TABLE') IS NOT NULL 
		DROP TABLE #MY1;

END
;
GO
