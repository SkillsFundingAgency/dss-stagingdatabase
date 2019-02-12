
IF OBJECT_ID('[dbo].[dcc-collections]') IS NOT NULL
BEGIN
	DROP FUNCTION [dbo].[dcc-collections]
END
GO

CREATE FUNCTION [dbo].[dcc-collections](@touchpointId varchar(max), @financialYear varchar(max))
	RETURNS TABLE
AS
RETURN 
(
	select 
	dssoutcomes.CustomerId as Outcomes_CustomerId, -- uniqueidentifier
	dsscustomers.DateofBirth as Customers_DateofBirth,  -- datetime2
	dssaddresses.PostCode as Addresses_PostCode,  -- varchar(max)
	dssactionplans.id as ActionsPlans_ActionPlanId,  -- uniqueidentifier
	dsssessions.DateandTimeOfSession as Sessions_DateandTimeOfSession,  -- datetime2
	'SubContractorId' as Outcomes_SubContractorId,  -- uniqueidentifier
	dssadviserdetails.AdviserName as AdviserDetails_AdviserName, -- nvarchar(max)
	dssoutcomes.id as Outcomes_OutcomeId, -- uniqueidentifier
	dssoutcomes.OutcomeType as Outcomes_OutcomeType, -- int
	convert(varchar, dssoutcomes.OutcomeEffectiveDate, 101)   as Outcomes_OutcomeEffectiveDate, -- nvarchar(10) mm/dd/yyyy
	dbo.fnPriorityCustomer(dssactionplans.PriorityCustomer) as ActionPlans_PriorityCustomer -- char(1)
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