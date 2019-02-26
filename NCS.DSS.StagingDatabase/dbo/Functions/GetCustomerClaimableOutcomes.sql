CREATE FUNCTION GetCustomerClaimableOutcomes (@startDate DATE, @endDate DATE, @touchpointId varchar(10), @customerId uniqueidentifier)
 RETURNS @Result table (OutcomeId uniqueidentifier)
AS
BEGIN

DECLARE @CustomerSatisfactionId uniqueidentifier
DECLARE @CareerManagementId uniqueidentifier
DECLARE @SustainableEmploymentId uniqueidentifier
DECLARE @AccreditedLearningId uniqueidentifier
DECLARE @CareerProgressionId uniqueidentifier

select top 1 @CustomerSatisfactionId = dssoutcomes.Id from [dbo].[dss-outcomes] as dssoutcomes
	INNER JOIN [dbo].[dss-actionplans] as dssactionsplans on dssactionsplans.id = dssoutcomes.ActionPlanId
	INNER JOIN [dbo].[dss-sessions] as dsssessions on dsssessions.id = dssactionsplans.SessionId
	WHERE dssoutcomes.OutcomeType = 1
	AND dssoutcomes.OutcomeClaimedDate IS NOT NULL
	AND dssoutcomes.OutcomeEffectiveDate IS NOT NULL
	AND dssoutcomes.ClaimedPriorityGroup IS NOT NULL
	AND dsssessions.DateandTimeOfSession BETWEEN @startDate AND @endDate
	AND dssoutcomes.TouchpointId = @touchpointId
	AND dssoutcomes.CustomerId = @customerId
	order by dsssessions.DateandTimeOfSession asc

select top 1 @CareerManagementId = dssoutcomes.Id from [dbo].[dss-outcomes] as dssoutcomes
	INNER JOIN [dbo].[dss-actionplans] as dssactionsplans on dssactionsplans.id = dssoutcomes.ActionPlanId
	INNER JOIN [dbo].[dss-sessions] as dsssessions on dsssessions.id = dssactionsplans.SessionId
	WHERE dssoutcomes.OutcomeType = 2
	AND dssoutcomes.OutcomeClaimedDate IS NOT NULL
	AND dssoutcomes.OutcomeEffectiveDate IS NOT NULL
	AND dssoutcomes.ClaimedPriorityGroup IS NOT NULL
	AND dsssessions.DateandTimeOfSession BETWEEN @startDate AND @endDate
	AND dssoutcomes.TouchpointId = @touchpointId
	AND dssoutcomes.CustomerId = @customerId
	order by dsssessions.DateandTimeOfSession asc

select top 1 @SustainableEmploymentId = dssoutcomes.Id from [dbo].[dss-outcomes] as dssoutcomes
	INNER JOIN [dbo].[dss-actionplans] as dssactionsplans on dssactionsplans.id = dssoutcomes.ActionPlanId
	INNER JOIN [dbo].[dss-sessions] as dsssessions on dsssessions.id = dssactionsplans.SessionId
	WHERE dssoutcomes.OutcomeType = 3
	AND dssoutcomes.OutcomeClaimedDate IS NOT NULL
	AND dssoutcomes.OutcomeEffectiveDate IS NOT NULL
	AND dssoutcomes.ClaimedPriorityGroup IS NOT NULL
	AND dsssessions.DateandTimeOfSession BETWEEN @startDate AND @endDate
	AND dssoutcomes.TouchpointId = @touchpointId
	AND dssoutcomes.CustomerId = @customerId
	order by dsssessions.DateandTimeOfSession asc	

select top 1 @AccreditedLearningId = dssoutcomes.Id from [dbo].[dss-outcomes] as dssoutcomes
	INNER JOIN [dbo].[dss-actionplans] as dssactionsplans on dssactionsplans.id = dssoutcomes.ActionPlanId
	INNER JOIN [dbo].[dss-sessions] as dsssessions on dsssessions.id = dssactionsplans.SessionId
	WHERE dssoutcomes.OutcomeType = 4
	AND dssoutcomes.OutcomeClaimedDate IS NOT NULL
	AND dssoutcomes.OutcomeEffectiveDate IS NOT NULL
	AND dssoutcomes.ClaimedPriorityGroup IS NOT NULL
	AND dsssessions.DateandTimeOfSession BETWEEN @startDate AND @endDate
	AND dssoutcomes.TouchpointId = @touchpointId
	AND dssoutcomes.CustomerId = @customerId
	order by dsssessions.DateandTimeOfSession asc	

select top 1 @CareerProgressionId = dssoutcomes.Id from [dbo].[dss-outcomes] as dssoutcomes
	INNER JOIN [dbo].[dss-actionplans] as dssactionsplans on dssactionsplans.id = dssoutcomes.ActionPlanId
	INNER JOIN [dbo].[dss-sessions] as dsssessions on dsssessions.id = dssactionsplans.SessionId
	WHERE dssoutcomes.OutcomeType = 5
	AND dssoutcomes.OutcomeClaimedDate IS NOT NULL
	AND dssoutcomes.OutcomeEffectiveDate IS NOT NULL
	AND dssoutcomes.ClaimedPriorityGroup IS NOT NULL
	AND dsssessions.DateandTimeOfSession BETWEEN @startDate AND @endDate
	AND dssoutcomes.TouchpointId = @touchpointId
	AND dssoutcomes.CustomerId = @customerId
	order by dsssessions.DateandTimeOfSession asc

IF (@CustomerSatisfactionId IS NOT NULL AND @CareerManagementId IS NOT NULL)
BEGIN
	INSERT INTO @Result (OutcomeId) VALUES (@CustomerSatisfactionId)
	INSERT INTO @Result (OutcomeId) VALUES (@CareerManagementId)	
END
ELSE
BEGIN
	IF (@SustainableEmploymentId IS NOT NULL)
	BEGIN
		INSERT INTO @Result (OutcomeId) VALUES (@SustainableEmploymentId)
	END
	ELSE IF (@AccreditedLearningId IS NOT NULL)
	BEGIN
		INSERT INTO @Result (OutcomeId) VALUES (@AccreditedLearningId)
	END	
	ELSE IF (@CareerProgressionId IS NOT NULL)
	BEGIN
		INSERT INTO @Result (OutcomeId) VALUES (@CareerProgressionId)
	END	
END

RETURN
END

