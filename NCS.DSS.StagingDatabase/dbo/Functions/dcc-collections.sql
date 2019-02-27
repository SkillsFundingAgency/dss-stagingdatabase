CREATE FUNCTION [dbo].[dcc-collections](@touchpointId varchar(10), @startDate DATE, @endDate DATE)
returns @Result table(CustomerID uniqueidentifier, DateOfBirth date, HomePostCode varchar(10), 
						ActionPlanId uniqueidentifier, SessionDate date, SubContractorId varchar(50), 
						AdviserName varchar(100), OutcomeId uniqueidentifier,
						OutcomeType int, OutcomeEffectiveDate date, OutcomePriorityCustomer int)
as
begin  
  WITH outcomes AS
(
    select dsscustomers.id as CustomerID,
       dsscustomers.DateofBirth as DateOfBirth,
	   --dsscustomers.PostCode as HomePostCode, 
	   '' as HomePostCode,
	   dssactionplans.id as ActionPlanId,
	   CONVERT(DATE, dsssessions.DateandTimeOfSession) AS SessionDate,  -- date	   
	   dsscustomers.SubcontractorId AS SubContractorId,  -- varchar(50)
	   --dssadviserdetails.AdviserName AS AdviserName, -- nvarchar(100)
	   '' as AdviserName,
	   dssoutcomes.id AS OutcomeID, -- uniqueidentifier
	   CASE WHEN dssoutcomes.OutcomeType = 1 Then 1
              WHEN dssoutcomes.OutcomeType = 2 Then 2
              ELSE 3
		END AS LocalOutcomeType,
	   dssoutcomes.OutcomeType as OutcomeType, -- int		  
	   CONVERT(DATE, dssoutcomes.OutcomeEffectiveDate) AS OutcomeEffectiveDate, -- date
	   IIF (dssactionplans.PriorityCustomer > 6, 1, 0) AS OutcomePriorityCustomer,	--int
	   dsssessions.id,
	   dsssessions.DateandTimeOfSession
from [dss-customers] as dsscustomers
	--INNER JOIN [dss-addresses] as dssaddresses on dssaddresses.CustomerId = dsscustomers.id
	INNER JOIN [dss-interactions] as dssinteractions on dssinteractions.CustomerId = dsscustomers.id
	--INNER JOIN [dss-adviserdetails] as dssadviserdetails on dssadviserdetails.id = dssinteractions.AdviserDetailsId
	INNER JOIN [dss-sessions] as dsssessions on dsssessions.interactionid = dssinteractions.id
	INNER JOIN [dss-actionplans] as dssactionplans on dssactionplans.SessionId = dsssessions.id                                                   			
	INNER JOIN [dss-outcomes] as dssoutcomes on dssoutcomes.ActionPlanId = dssactionplans.id
WHERE dssoutcomes.OutcomeEffectiveDate BETWEEN @startDate AND @endDate
	  AND dsssessions.DateandTimeOfSession BETWEEN @startDate AND @endDate
	  AND dssoutcomes.OutcomeClaimedDate >= @startDate
	  AND dssoutcomes.OutcomeClaimedDate IS NOT NULL
	  AND dssoutcomes.touchpointId = @touchpointId
 )
 ,sessionrank AS
 (
	select o.*,
	  RANK () OVER (PARTITION BY o.id ORDER BY DateandTimeOfSession, id desc) sr
	  from outcomes o
 )
 ,outcomerank AS
 (
    select o.*,
      RANK () OVER   ( PARTITION BY o.CustomerId, o.SessionDate, o.LocalOutcomeType ORDER BY OutcomeEffectiveDate desc ) rk
     from sessionrank o
 )
	INSERT INTO @Result
	select CustomerID, DateOfBirth, HomePostCode, ActionPlanId, SessionDate, SubContractorId, AdviserName, OutcomeID, OutcomeType, OutcomeEffectiveDate, OutcomePriorityCustomer from outcomerank
	where rk = 1 
	order by CustomerId;

  return
end