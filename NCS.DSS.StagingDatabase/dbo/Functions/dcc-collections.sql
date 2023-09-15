CREATE FUNCTION [dbo].[dcc-collections](@touchpointId VARCHAR(10), @startDate DATE, @endDate DATE)

RETURNS @Result TABLE(CustomerID UNIQUEIDENTIFIER, DateOfBirth DATE, HomePostCode VARCHAR(10), 
                                        ActionPlanId UNIQUEIDENTIFIER, SessionDate DATE, SubContractorId VARCHAR(50), 
                                        AdviserName VARCHAR(100), OutcomeId UNIQUEIDENTIFIER,
                                        OutcomeType INT, OutcomeEffectiveDate DATE, OutcomePriorityCustomer INT)

AS

BEGIN  

DECLARE @endDateTime DATETIME2		-- date and time the period ends.

-- used to get latest address
DECLARE	@today DATE;
SET		@today = GETDATE()

--This is to ensure that any outcomes claimed or effice on the last day of the period gets included.
SET		@endDateTime = DATEADD(MS, -1, DATEADD(D, 1, CONVERT(DATETIME2,@endDate)));  


	with TempData AS
	(
		SELECT				o.CustomerId															AS 'CustomerID'
							,o.SessionId																AS 'SessionID'
							,c.DateofBirth															AS 'DateOfBirth'
							,a.PostCode																AS 'HomePostCode'
							,ap.id																	AS 'ActionPlanId' 
							,CONVERT(DATE, s.DateandTimeOfSession)									AS 'SessionDate'
							,o.SubcontractorID														AS 'SubContractorId' 
							,adv.AdviserName														AS 'AdviserName'
							,o.id																	AS 'OutcomeID'
							,o.OutcomeType															AS 'OutcomeType'
							,o.OutcomeEffectiveDate													AS 'OutcomeEffectiveDate'
							,COALESCE(o.IsPriorityCustomer, IIF(o.ClaimedPriorityGroup < 99, 1, 0)) AS 'OutcomePriorityCustomer'
							,o.OutcomeClaimedDate													AS 'OutcomeClaimedDate'
							,SessionClosureDate = 
								CASE o.OutcomeType
									WHEN 3 THEN	DATEADD(mm, 13, s.DateandTimeOfSession) 
									ELSE DATEADD(mm, 12, s.DateandTimeOfSession) 
								END
							,DATEADD(mm, -12, CONVERT(DATE,s.DateandTimeOfSession)) AS 'PriorSessionDate'		
							,RANK() OVER(PARTITION BY s.CustomerID, IIF(s.DateandTimeOfSession < @startDate,100,0 ), o.OutcomeType
--							ORDER BY o.id, o.OutcomeEffectiveDate, o.LastModifiedDate) AS 'Rank'  -- Commented by Mridul Yadav to match the ranking order with Excel
							ORDER BY o.OutcomeEffectiveDate, o.LastModifiedDate, o.id) AS 'Rank'  -- we rank to remove duplicates

		FROM				[dss-sessions] s
		INNER JOIN			[dss-customers] c								ON c.id = s.CustomerId
		INNER JOIN			[dss-actionplans] ap							ON ap.SessionId = s.id
		INNER JOIN			[dss-interactions] i							ON i.id = ap.InteractionId
		INNER JOIN			[dss-outcomes] o								ON o.ActionPlanId = ap.id
		OUTER APPLY			(	SELECT TOP 1	PostCode
								FROM			[dss-addresses] a
								WHERE			a.CustomerId = s.CustomerId											-- Get the latest address for the customer record
								AND				@today BETWEEN ISNULL(a.EffectiveFrom, DATEADD(dd,-1,@today)) AND ISNULL(a.EffectiveTo, DATEADD(dd,1,@today))
							) AS a
		LEFT JOIN			[dss-adviserdetails] adv ON adv.id = i.AdviserDetailsId									-- join to get adviser details
		WHERE				o.OutcomeEffectiveDate	BETWEEN @startDate AND @endDateTime								-- effective between period start and end date and time
		AND					o.OutcomeClaimedDate	BETWEEN @startDate AND @endDateTime								-- claimed between period start and end date and time
		AND					o.TouchpointID = @touchpointId															-- for the touchpoint requesting the collection
	), dupesRemoved AS (
		SELECT *
		FROM TempData
		WHERE TempData.Rank = 1	
	), lagged AS(
		SELECT *
		,LAG(OutcomeType) OVER (PARTITION BY CustomerID
		ORDER BY OutcomeEffectiveDate, OutcomeType) AS 'PrevOutcomeType'
		FROM dupesRemoved
		WHERE OutcomeType = 3 OR OutcomeType = 5
	), laggedRulesApplied AS(
		SELECT *
		FROM lagged
		WHERE OutcomeType = 3 AND PrevOutcomeType IS  NULL
		OR OutcomeType = 3 AND PrevOutcomeType <> 5
		OR OutcomeType = 5 AND PrevOutcomeType IS  NULL
		OR OutcomeType = 5  AND PrevOutcomeType <> 3
	), oneTwoFourTypes AS(
		SELECT *
		FROM dupesRemoved
		WHERE OutcomeType IN (1,2,4)
	)

	INSERT INTO @Result
	SELECT			
		 CustomerID
		,DateOfBirth
		,HomePostCode
		,ActionPlanId
		,SessionDate
		,SubContractorId
		,AdviserName
		,OutcomeID
		,OutcomeType
		,OutcomeEffectiveDate
		,OutcomePriorityCustomer
	FROM laggedRulesApplied
	UNION
	SELECT			
		 CustomerID
		,DateOfBirth
		,HomePostCode
		,ActionPlanId
		,SessionDate
		,SubContractorId
		,AdviserName
		,OutcomeID
		,OutcomeType
		,OutcomeEffectiveDate
		,OutcomePriorityCustomer
	FROM oneTwoFourTypes AS o
	WHERE 						
	CONVERT(DATE,o.OutcomeEffectiveDate) <= o.SessionClosureDate								-- within 12 or 13 months of the session date date
	AND						NOT EXISTS (
									SELECT			priorO.id
									FROM			[dss-sessions]  priorS
									INNER JOIN		[dss-outcomes] priorO ON priorS.id = priorO.SessionId
									WHERE			priorO.id <> o.OutcomeID
									AND				priorO.OutcomeEffectiveDate < o.OutcomeEffectiveDate
									AND				priorO.OutcomeClaimedDate IS NOT NULL		-- and claimed
									AND				priorO.CustomerId = o.CustomerId			-- and they belong to the same customer
									AND				priorO.TouchpointId <> '0000000999'			-- and touchpoint is not helpline
									AND				CONVERT(DATE,priorS.DateandTimeOfSession) > o.PriorSessionDate	-- and the prior session date is more then 12 months before current session date
									AND				(											-- check validity of the previous outcomes we are considering
														( 
															OutcomeType = 3							-- the previous outcome should have been claimed within 13 months of the previous session date for Outcome Type 3
															AND
															DATEADD(mm, 13, Convert(DATE,priorS.DateandTimeOfSession))  >= CONVERT(DATE,priorO.OutcomeEffectiveDate)
														)
														OR											-- the previous outcome should have been claimed within 12 months of the previous session date for Outcome Types 1,2,4,5
														(
															OutcomeType IN ( 1,2,4,5)			
															AND
															DATEADD(mm, 12, Convert(DATE,priorS.DateandTimeOfSession))  >= CONVERT(DATE,priorO.OutcomeEffectiveDate)
														)														
													)
									AND				(
														(							-- Check there are no Outcomes of the same type (CSO and CMO)
															o.OutcomeType IN (1,2)
															AND	
															o.OutcomeType = priorO.OutcomeType
														)
														OR
														(							-- check there are no outcomes of the same type (JLO)
															o.OutcomeType IN (3,5)
															AND
															priorO.OutcomeType IN (3,5)
														)
													)
								)
  RETURN 
  
  END