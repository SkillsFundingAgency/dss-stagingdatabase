
-------------------------------------------------------------------------------
-- Authors:      Kevin Brandon
-- Created:      14/08/2019
-- Purpose:      Produce Satisfaction data for Ipsos-Mori integration.
--  
-------------------------------------------------------------------------------
-- Modification History
-- Initial creation.
-- 
--            
-- Copyright © 2019, ESFA, All Rights Reserved
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_GetSatisfactionDataForIpsosMoriIntegration]
AS							   
BEGIN
								DECLARE @startDate DATE
	DECLARE @endDate DATE
	SET @startDate = DATEADD(MONTH,datediff(MONTH,0,GETDATE())-1,0)
	SET @endDate = DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)

	-- used to get latest address
	DECLARE @today DATE;
	SET     @today = GETDATE();
	
	SELECT   rk.id                                         AS 'Customer ID'
		, rk.GivenName                                  AS 'Given Name'
		, rk.FamilyName                                 AS 'Family Name'
		, 'Primary Phone Number' = 
			CASE COALESCE(rk.PreferredContactMethod, 0)
				WHEN 3 THEN COALESCE(rk.HomeNumber,'')
				ELSE COALESCE(rk.MobileNumber, '')
			END
		, COALESCE(rk.AlternativeNumber, '')            AS 'Alternative Phone Number'
		, COALESCE(rk.PostCode, '')                     AS 'Postcode'
		, COALESCE(rk.EmailAddress, '')             AS 'Contact Email'              
		, CONVERT(VARCHAR(10), rk.DateofBirth, 23)                  AS 'Date of Birth'
		, 'Disability Type' = dbo.udf_GetReferenceDataValue('DiversityDetails','PrimaryLearningDifficultyOrDisability',rk.PrimaryLearningDifficultyOrDisability,'Not provided')
		, 'Learning Difficulty' =  dbo.udf_GetReferenceDataValue('DiversityDetails','SecondaryLearningDifficultyOrDisability',rk.SecondaryLearningDifficultyOrDisability,'Not provided')
		, 'Ethnicity' =  dbo.udf_GetReferenceDataValue('DiversityDetails','Ethnicity',rk.Ethnicity,'Not provided')                  
		, 'Gender' = dbo.udf_GetReferenceDataValue('Customers','Gender',rk.Gender,'')
		, 'Contracting Area' = dbo.udf_GetReferenceDataValue('Touchpoints','Touchpoint', CAST(COALESCE(rk.CreatedBy, rk.LastModifiedTouchpointId) AS BIGINT),'') 
		, COALESCE(rk.SubcontractorId, '')                      AS 'Subcontractor Name'
		, iif(rk.ActionPlanId is not null,'Yes','No')               AS 'Action Plan'    
		, 'Current Employment Status' = dbo.udf_GetReferenceDataValue('EmploymentProgressions','CurrentEmploymentStatus',rk.CurrentEmploymentStatus,'')
		, 'Length Of Unemployment' = dbo.udf_GetReferenceDataValue('EmploymentProgressions','LengthOfUnemployment',rk.LengthOfUnemployment,'')
		, 'Current Learning Status' = dbo.udf_GetReferenceDataValue('LearningProgressions','CurrentLearningStatus',rk.CurrentLearningStatus,'')
		, 'Current Qualification Level' = dbo.udf_GetReferenceDataValue('LearningProgressions','QualificationLevel',rk.CurrentQualificationLevel,'')                
		, 'Channel' = dbo.udf_GetReferenceDataValue('Interactions','Channel',rk.Channel,'')
		, CONVERT(VARCHAR(10), rk.DateandTimeOfSession, 23)             AS 'Session Date'
		, 'Yes'                                         AS 'Participate Research Evaluation'
		, 'Priority Group' = dbo.udf_GetReferenceDataValue('ActionPlans','PriorityCustomer', rk.PriorityCustomer, '')
		 from 
		(
			SELECT
				  c.id
				, c.GivenName                                   
				, c.FamilyName                                  
				,con.PreferredContactMethod
				,con.HomeNumber
				,con.MobileNumber
				,con.AlternativeNumber
				,a.PostCode
				,con.EmailAddress
				,c.DateofBirth
				,d.PrimaryLearningDifficultyOrDisability
				,d.SecondaryLearningDifficultyOrDisability
				,d.Ethnicity
				,c.Gender
				,ap.id as ActionPlanId
				,ap.CreatedBy
				,ap.LastModifiedTouchpointId
				,ap.SubcontractorId
				,ep.CurrentEmploymentStatus
				,ep.LengthOfUnemployment
				,lp.CurrentLearningStatus
				,lp.CurrentQualificationLevel
				,i.Channel
				,s.DateandTimeOfSession
				,ap.PriorityCustomer
				, (select count(1) from [dss-interactions] i2 where i2.CustomerId = i.CustomerId and i2.DateAndTimeOfInteraction < @startDate )  as prev_interactions
				, (select count(1) from [dss-actionplans] ap2 where ap2.CustomerId = i.CustomerId and ap2.DateActionPlanCreated < @startDate  ) as prev_actionplans
				, rank () over (partition by c.id order by iif(ap.id is not null, 1,2 ), i.DateandTimeOfInteraction, i.LastModifiedDate, i.id ) ro  --make sure action plans are considered first and duplcates are excluded
			FROM        [dss-customers] c
			LEFT JOIN   [dss-contacts] con ON con.CustomerId = c.id
			LEFT JOIN   [dss-addresses] a ON a.CustomerId = c.Id
			LEFT JOIN   [dss-diversitydetails] d ON d.CustomerId = c.Id
			LEFT JOIN   [dss-employmentprogressions] ep on ep.CustomerId = c.id
			LEFT JOIN   [dss-learningprogressions] lp on lp.CustomerId = c.id
			INNER JOIN  [dss-interactions] i ON i.CustomerId = c.id
			INNER JOIN  [dss-sessions] s ON s.InteractionId = i.id
			LEFT JOIN   [dss-actionplans] ap ON ap.interactionId = i.id
			WHERE       c.OptInMarketResearch = 1 -- true
			AND         COALESCE(c.ReasonForTermination, 0) NOT IN (1,2)
			AND         cast ( isnull(ap.DateActionPlanCreated,i.DateandTimeOfInteraction) as DATE ) BETWEEN @startDate AND @endDate
			AND         ( ap.id is not null OR i.TouchpointId = '0000000999' )
	) rk
	where
		rk.ro = 1 -- exclude duplicate rows within the reporting period
		AND 
		(
				( rk.ActionPlanId is not null  AND prev_actionplans = 0 ) -- if an action plan is detected check no actions plans exist from before the reporting period
			OR
				( rk.ActionPlanId is null AND prev_interactions = 0 ) -- if an action plan does not exists check no interactions exist from before the reporting period
		)
END;