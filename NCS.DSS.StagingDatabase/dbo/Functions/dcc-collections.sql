CREATE FUNCTION [dbo].[dcc-collections](@touchpointId varchar(max), @financialYear varchar(max))
returns @Result table(CustomerID uniqueidentifier, DateOfBirth date, HomePostCode nvarchar(10), ActionPlanId uniqueidentifier, 
				 SessionDate date, SubContractorId uniqueidentifier, AdviserName nvarchar(100), OutcomeId uniqueidentifier,
				 OutcomeType int, OutcomeEffectiveDate date, OutcomePriorityCustomer int)
as
begin
  declare @contractStartDate datetime
  declare @feedStartDate datetime
  declare @minAge datetime
  declare @maxAge datetime
  declare @dssDate datetime
  SET @contractStartDate = dbo.fnGetParameterValueAsDate('ContractStartDate')
  SET @feedStartDate = dbo.fnGetParameterValueAsDate('FeedStartDate')
  SET @minAge = dbo.fnGetParameterValueAsInteger('MinAge')
  SET @maxAge = dbo.fnGetParameterValueAsInteger('MaxAge')
  SET @dssDate = dbo.fnDssDate()

  INSERT INTO @Result
  select 
	dssoutcomes.CustomerId as CustomerID, -- uniqueidentifier
	CONVERT(DATE, dsscustomers.DateofBirth) AS DateOfBirth,  -- date
	dssaddresses.PostCode AS HomePostCode,  -- varchar(10)
	dssactionplans.id AS ActionPlanID,  -- uniqueidentifier
	CONVERT(DATE, dsssessions.DateandTimeOfSession) AS SessionDate,  -- date
	'51A26C5E-B9F1-482A-A24C-AC01029339C3' AS SubContractorId,  -- uniqueidentifier
	dssadviserdetails.AdviserName AS AdviserName, -- nvarchar(100)
	dssoutcomes.id AS OutcomeID, -- uniqueidentifier
	dssoutcomes.OutcomeType AS OutcomeType, -- int
	CONVERT(DATE, dssoutcomes.OutcomeEffectiveDate) AS OutcomeEffectiveDate, -- date
	IIF (dssactionplans.PriorityCustomer > 6, 1, 0) AS OutcomePriorityCustomer	--int
	FROM [dss-outcomes] as dssoutcomes 
		INNER JOIN [dss-customers] AS dsscustomers ON dsscustomers.id = dssoutcomes.CustomerId
		INNER JOIN [dss-addresses] AS dssaddresses ON dssaddresses.CustomerId = dsscustomers.id
		INNER JOIN [dss-actionplans] AS dssactionplans ON dssactionplans.id = dssoutcomes.ActionPlanId
		INNER JOIN [dss-interactions] AS dssinteractions ON dssinteractions.id = dssactionplans.InteractionId
		INNER JOIN [dss-sessions] AS dsssessions ON dsssessions.InteractionId = dssinteractions.id
		INNER JOIN [dss-adviserdetails] as dssadviserdetails on dssadviserdetails.id = dssinteractions.AdviserDetailsId
	where (dsssessions.DateandTimeOfSession >= @contractStartDate AND
           dsssessions.DateandTimeOfSession <= @dssDate)
	   AND dssoutcomes.OutcomeEffectiveDate >  @feedStartDate
	   AND dssoutcomes.OutcomeEffectiveDate <= EOMONTH(@dssDate)
	   AND dssoutcomes.OutcomeClaimedDate IS NOT NULL
	   AND dbo.fnGetFiscalYearForDate(dssoutcomes.OutcomeClaimedDate) = @financialYear
	   AND dbo.fnYearsOld(dsscustomers.DateofBirth, dbo.fnDssDate()) >= @minAge
	   AND dbo.fnYearsOld(dsscustomers.DateofBirth, dbo.fnDssDate()) <= @maxAge
	   AND dsscustomers.DateofBirth IS NOT NULL
	   AND dsssessions.DateandTimeOfSession >= @contractStartDate
	   AND dsssessions.DateandTimeOfSession <= @dssDate
	   AND dssoutcomes.OutcomeEffectiveDate >= @feedStartDate
	   AND dssoutcomes.OutcomeEffectiveDate <= EOMONTH(@dssDate)	  	   
	   AND dssoutcomes.LastModifiedTouchpointId = @touchpointId

  return
end