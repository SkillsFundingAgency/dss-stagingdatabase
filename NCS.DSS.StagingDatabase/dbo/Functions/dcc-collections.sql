CREATE FUNCTION [dbo].[dcc-collections](@touchpointId VARCHAR(10), @startDate DATE, @endDate DATE)

RETURNS @Result TABLE(CustomerID UNIQUEIDENTIFIER, DateOfBirth DATE, HomePostCode VARCHAR(10), 
                                        ActionPlanId UNIQUEIDENTIFIER, SessionDate DATE, SubContractorId VARCHAR(50), 
                                        AdviserName VARCHAR(100), OutcomeId UNIQUEIDENTIFIER,
                                        OutcomeType INT, OutcomeEffectiveDate DATE, OutcomePriorityCustomer INT)

AS

BEGIN  
DECLARE @contractStartDate DATE
  SET @contractStartDate = '2018/10/01';
   
WITH outcomes AS
(
  select dsscustomers.id as CustomerID, --uniqueidentifier
        dsscustomers.DateofBirth as DateOfBirth, --date
        dssaddresses.PostCode as HomePostCode, --varchar
		dssaddresses.LastModifiedDate as AddressLastModified, --date
		dssaddresses.id as AddressId, --date
        dssactionplans.id as ActionPlanId, --uniqueidentifier
        CONVERT(DATE, dsssessions.DateandTimeOfSession) AS SessionDate,  -- date
        dssoutcomes.SubcontractorId AS SubContractorId,  -- varchar(50)
        dssadviserdetails.AdviserName AS AdviserName, -- nvarchar(100)
        dssoutcomes.id AS OutcomeID, -- uniqueidentifier
        CASE WHEN dssoutcomes.OutcomeType = 1 Then 1
            WHEN dssoutcomes.OutcomeType = 2 Then 2
            ELSE 3
        END AS LocalOutcomeType,
        dssoutcomes.OutcomeType as OutcomeType, -- int
        CONVERT(DATE, dssoutcomes.OutcomeEffectiveDate) AS OutcomeEffectiveDate, -- date
        IIF (dssoutcomes.ClaimedPriorityGroup < 99, 1, 0) AS OutcomePriorityCustomer,   --int
        dsssessions.id,
        dsssessions.DateandTimeOfSession,
        dssoutcomes.TouchpointId,
		dssoutcomes.LastModifiedDate
from [dss-customers] as dsscustomers
	 LEFT JOIN [dss-addresses] as dssaddresses on dssaddresses.CustomerId = dsscustomers.id 
											  and GetDate() between isnull( dssaddresses.EffectiveFrom, DATEADD( dd,-1,getDate() ) )  
										     			        and isnull( dssaddresses.EffectiveTo, DATEADD( dd,1,getDate() ) )
     INNER JOIN [dss-sessions] as dsssessions on dsssessions.CustomerId = dsscustomers.id
     INNER JOIN [dss-actionplans] as dssactionplans on dssactionplans.SessionId = dsssessions.id
     INNER JOIN [dss-outcomes] as dssoutcomes on dssoutcomes.ActionPlanId = dssactionplans.id
	 INNER JOIN [dss-interactions] as dssinteractions on dssinteractions.CustomerId = dsscustomers.id and dssinteractions.id = dssactionplans.InteractionId
	 LEFT JOIN [dss-adviserdetails] as dssadviserdetails on dssadviserdetails.id = dssinteractions.AdviserDetailsId

WHERE
dssoutcomes.OutcomeEffectiveDate BETWEEN @startDate AND @endDate
       AND ((dssoutcomes.OutcomeType = 3 AND dsssessions.DateandTimeOfSession >= DATEADD(mm, -13, dssoutcomes.OutcomeEffectiveDate)) OR
            (dssoutcomes.OutcomeType IN (1, 2, 4, 5) AND dsssessions.DateandTimeOfSession >= DATEADD(mm, -12, dssoutcomes.OutcomeEffectiveDate)))
       AND dssoutcomes.OutcomeClaimedDate IS NOT NULL
       AND dssoutcomes.touchpointId = @touchpointId
       AND dsssessions.DateandTimeOfSession BETWEEN @contractStartDate AND @endDate
)
,outcomerank AS
(
  select o.*,
    RANK () OVER ( PARTITION BY o.CustomerId, o.SessionDate, o.LocalOutcomeType ORDER BY o.OutcomeEffectiveDate ASC
																			            ,o.LastModifiedDate ASC
																						,o.AddressLastModified ASC
																						,o.AddressId) rk
   from outcomes o  
)	
   INSERT INTO @Result
   select CustomerID, DateOfBirth, HomePostCode, ActionPlanId, SessionDate, SubContractorId, AdviserName, OutcomeID, OutcomeType, OutcomeEffectiveDate, OutcomePriorityCustomer
    from outcomerank ora
  where rk = 1
  and not exists ( select 1 from [dss-sessions] priorsession
                              where priorsession.CustomerId = ora.CustomerID
                                    and DATEADD(YEAR, 1, priorsession.DateandTimeOfSession ) > ora.DateandTimeOfSession
                                    and priorsession.DateandTimeOfSession < ora.DateandTimeOfSession )

	return
END
