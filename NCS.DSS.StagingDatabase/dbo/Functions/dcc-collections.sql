CREATE FUNCTION [dbo].[dcc-collections](@touchpointId varchar(10), @startDate DATE, @endDate DATE)
returns @Result table(CustomerID uniqueidentifier, DateOfBirth date, HomePostCode varchar(10), 
						ActionPlanId uniqueidentifier, SessionDate date, SubContractorId varchar(50), 
						AdviserName varchar(100), OutcomeId uniqueidentifier,
						OutcomeType int, OutcomeEffectiveDate date, OutcomePriorityCustomer int)
as
begin
  INSERT INTO @Result
  select 
	dssoutcomes.CustomerId as CustomerID, -- uniqueidentifier
	CONVERT(DATE, dsscustomers.DateofBirth) AS DateOfBirth,  -- date
	dssaddresses.PostCode AS HomePostCode,  -- varchar(10)
	dssactionplans.id AS ActionPlanID,  -- uniqueidentifier
	CONVERT(DATE, dsssessions.DateandTimeOfSession) AS SessionDate,  -- date
	dsscustomers.SubcontractorId AS SubContractorId,  -- varchar(50)
	dssadviserdetails.AdviserName AS AdviserName, -- nvarchar(100)
	dssoutcomes.id AS OutcomeID, -- uniqueidentifier
	dssoutcomes.OutcomeType AS OutcomeType, -- int
	CONVERT(DATE, dssoutcomes.OutcomeEffectiveDate) AS OutcomeEffectiveDate, -- date
	IIF (dssactionplans.PriorityCustomer > 6, 1, 0) AS OutcomePriorityCustomer	--int
	FROM [dss-outcomes] as dssoutcomes 
		INNER JOIN [dss-customers] AS dsscustomers ON dsscustomers.id = dssoutcomes.CustomerId
		INNER JOIN [dss-addresses] AS dssaddresses ON dssaddresses.CustomerId = dsscustomers.id
		INNER JOIN [dss-actionplans] AS dssactionplans ON dssactionplans.id = dssoutcomes.ActionPlanId		
		INNER JOIN [dss-sessions] AS dsssessions ON dsssessions.id = dssactionplans.SessionId
		INNER JOIN [dss-interactions] AS dssinteractions ON dssinteractions.id = dsssessions.InteractionId
		INNER JOIN [dss-adviserdetails] as dssadviserdetails on dssadviserdetails.id = dssinteractions.AdviserDetailsId
	where dsssessions.DateandTimeOfSession <= @endDate
	   AND dssoutcomes.OutcomeEffectiveDate >  @startDate
	   AND dssoutcomes.OutcomeEffectiveDate <= @endDate
	   AND dssoutcomes.OutcomeClaimedDate >= @startDate  
	   AND (dsssessions.DateandTimeOfSession >= @startDate
	   AND dsssessions.DateandTimeOfSession <= @endDate)
	   AND (dssoutcomes.OutcomeEffectiveDate >= @startDate
	   AND dssoutcomes.OutcomeEffectiveDate <= @endDate)	  	   
	   AND dssoutcomes.LastModifiedTouchpointId = @touchpointId
	   AND dssoutcomes.OutcomeClaimedDate IS NOT NULL	   
  return
end