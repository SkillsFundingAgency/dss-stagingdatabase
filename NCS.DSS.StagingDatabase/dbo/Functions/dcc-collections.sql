﻿CREATE FUNCTION [dbo].[dcc-collections](@touchpointId varchar(max), @financialYear varchar(max))
	RETURNS TABLE
AS
RETURN 
(
	select 
	dssoutcomes.CustomerId as CustomerID, -- uniqueidentifier
	CONVERT(DATE, CONVERT(VARCHAR, dsscustomers.DateofBirth, 101)) AS DateOfBirth,  -- date
	dssaddresses.PostCode AS HomePostCode,  -- varchar(max)
	dssactionplans.id AS ActionPlanID,  -- uniqueidentifier
	CONVERT(DATE, CONVERT(VARCHAR, dsssessions.DateandTimeOfSession, 101)) AS SessionDate,  -- date
	'SubContractorId' AS SubContractorId,  -- uniqueidentifier
	dssadviserdetails.AdviserName AS AdviserName, -- nvarchar(max)
	dssoutcomes.id AS OutcomeID, -- uniqueidentifier
	dssoutcomes.OutcomeType AS OutcomeType, -- int
	CONVERT(DATE, CONVERT(VARCHAR, dssoutcomes.OutcomeEffectiveDate, 101)) AS OutcomeEffectiveDate, -- date
	dbo.fnPriorityCustomer(dssactionplans.PriorityCustomer) AS OutcomePriorityCustomer -- char(1)
	from [dss-outcomes] as dssoutcomes 
		JOIN [dss-customers] as dsscustomers on dsscustomers.id = dssoutcomes.CustomerId
		JOIN [dss-addresses] as dssaddresses on dssaddresses.CustomerId = dsscustomers.id
		JOIN [dss-actionplans] as dssactionplans on dssactionplans.id = dssoutcomes.ActionPlanId
		JOIN [dss-interactions] as dssinteractions on dssinteractions.id = dssactionplans.InteractionId
		JOIN [dss-sessions] as dsssessions on dsssessions.InteractionId = dssinteractions.id
		JOIN [dss-adviserdetails] as dssadviserdetails on dssadviserdetails.id = dssinteractions.AdviserDetailsId
	where (dsssessions.DateandTimeOfSession >= dbo.fnGetParameterValueAsDate('ContractStartDate') AND
       dsssessions.DateandTimeOfSession <= GETDATE())
	   AND dssoutcomes.OutcomeEffectiveDate >  dbo.fnGetParameterValueAsDate('FeedStartDate')
	   AND dssoutcomes.OutcomeEffectiveDate <= EOMONTH(GETDATE())
	   AND dssoutcomes.OutcomeClaimedDate != NULL
	   AND dbo.fnGetFiscalYearForDate(dssoutcomes.OutcomeClaimedDate) = dbo.fnGetFiscalYearForDate(GETDATE())
	   AND dbo.fnYearsOld(dsscustomers.DateofBirth, GETDATE()) >= dbo.fnGetParameterValueAsInteger('MinAge')
	   AND dbo.fnYearsOld(dsscustomers.DateofBirth, GETDATE()) <= dbo.fnGetParameterValueAsInteger('MaxAge')
	   AND dsscustomers.DateofBirth != NULL
	   AND dsssessions.DateandTimeOfSession >= dbo.fnGetParameterValueAsDate('ContractStartDate')
	   AND dsssessions.DateandTimeOfSession <= GETDATE()
	   AND dssoutcomes.OutcomeEffectiveDate >= dbo.fnGetParameterValueAsDate('FeedStartDate')
	   AND dssoutcomes.OutcomeEffectiveDate <= EOMONTH(GETDATE())
	   AND dbo.fnGetFiscalYearForDate(GETDATE()) = dbo.fnGetFiscalYearForDate(dssoutcomes.OutcomeClaimedDate)
	   AND dssoutcomes.OutcomeEffectiveDate != NULL
	   AND dssoutcomes.LastModifiedTouchpointId = @touchpointId
)