
-------------------------------------------------------------------------------
-- Authors:      Kevin Brandon
-- Created:      14/08/2019
-- Purpose:      Produce Demographics data for Ipsos Mori integration.
--  
-------------------------------------------------------------------------------
-- Modification History
-- Initial creation.
-- 
--            
-- Copyright © 2019, ESFA, All Rights Reserved
-------------------------------------------------------------------------------
CREATE PROCEDURE usp_GetSatisfactionDataForIpsosMoriIntegration
@startDate AS DATE,  @endDate AS DATE
AS							   
BEGIN
	SELECT 		c.id											AS 'Customer ID'
				, c.GivenName									AS 'Given Name'
				, c.FamilyName									AS 'Family Name'
				, 'Primary Phone Number' = 
					CASE COALESCE(con.PreferredContactMethod, 0)
						WHEN 3 THEN COALESCE(con.HomeNumber,'')
						ELSE COALESCE(con.MobileNumber, '')
					END
				, COALESCE(con.AlternativeNumber, '')			AS 'Alternative Phone Number'
				, COALESCE(a.PostCode, '')						AS 'Postcode'
				, COALESCE(con.EmailAddress, '')				AS 'Contact Email'
				, 'Contact Preference' = 
					CASE con.PreferredContactMethod
						WHEN 1 THEN 'Email'
						WHEN 2 THEN 'Mobile'
						WHEN 3 THEN 'Telephone'
						WHEN 4 THEN 'SMS'
						WHEN 5 THEN 'Post'
						ELSE 'Mobile'
					END
				, CAST(c.DateofBirth AS DATE)					AS 'Date of Birth'
				, 'Disability Type' = 
					CASE d.PrimaryLearningDifficultyOrDisability
						WHEN 4 THEN 'Visual impairment'
						WHEN 5 THEN	'Hearing impairment'
						WHEN 6 THEN	'Disability affecting mobility'
						WHEN 7 THEN	'Profound complex disabilities'
						WHEN 8 THEN	'Social and emotional difficulties'
						WHEN 9 THEN	'Mental health difficulty'
						WHEN 10 THEN 'Moderate learning difficulty'
						WHEN 11 THEN 'Severe learning difficulty'
						WHEN 12 THEN 'Dyslexia'
						WHEN 13 THEN 'Dyscalculia'
						WHEN 14 THEN 'Autism spectrum disorder'
						WHEN 15 THEN 'Aspergers syndrome'
						WHEN 16 THEN 'Temporary disability after illness (for example post viral) or accident'
						WHEN 17 THEN 'Speech, Language and Communication Needs'
						WHEN 93 THEN 'Other physical disability'
						WHEN 94 THEN 'Other specific learning difficulty (e.g. Dyspraxia)'
						WHEN 95 THEN 'Other medical condition (for example epilepsy, asthma, diabetes)'
						WHEN 96 THEN 'Other learning difficulty'
						WHEN 97 THEN 'Other disability'
						WHEN 98 THEN 'Prefer not to say'
						ELSE 'Not provided'
					END
				, 'Learning Difficulty' = 
					CASE d.SecondaryLearningDifficultyOrDisability
						WHEN 4 THEN 'Visual impairment'
						WHEN 5 THEN	'Hearing impairment'
						WHEN 6 THEN	'Disability affecting mobility'
						WHEN 7 THEN	'Profound complex disabilities'
						WHEN 8 THEN	'Social and emotional difficulties'
						WHEN 9 THEN	'Mental health difficulty'
						WHEN 10 THEN 'Moderate learning difficulty'
						WHEN 11 THEN 'Severe learning difficulty'
						WHEN 12 THEN 'Dyslexia'
						WHEN 13 THEN 'Dyscalculia'
						WHEN 14 THEN 'Autism spectrum disorder'
						WHEN 15 THEN 'Aspergers syndrome'
						WHEN 16 THEN 'Temporary disability after illness (for example post viral) or accident'
						WHEN 17 THEN 'Speech, Language and Communication Needs'
						WHEN 93 THEN 'Other physical disability'
						WHEN 94 THEN 'Other specific learning difficulty (e.g. Dyspraxia)'
						WHEN 95 THEN 'Other medical condition (for example epilepsy, asthma, diabetes)'
						WHEN 96 THEN 'Other learning difficulty'
						WHEN 97 THEN 'Other disability'
						WHEN 98 THEN 'Prefer not to say'
						ELSE 'Not provided'
					END
				, 'Ethnicity' = 
					CASE d.Ethnicity
						WHEN 31 THEN 'English / Welsh / Scottish / Northern Irish / British'
						WHEN 32 THEN 'Irish'
						WHEN 33 THEN 'Gypsy or Irish Traveller'
						WHEN 34 THEN 'Any Other White background'
						WHEN 35 THEN 'White and Black Caribbean'
						WHEN 36 THEN 'White and Black African'
						WHEN 37 THEN 'White and Asian'
						WHEN 38 THEN 'Any Other Mixed / multiple ethnic background'
						WHEN 39 THEN 'Indian'
						WHEN 40 THEN 'Pakistani'
						WHEN 41 THEN 'Bangladeshi'
						WHEN 42 THEN 'Chinese'
						WHEN 43 THEN 'Any other Asian background'
						WHEN 44 THEN 'African'
						WHEN 45 THEN 'Caribbean'
						WHEN 46 THEN 'Any other Black / African / Caribbean background'
						WHEN 47 THEN 'Arab'
						WHEN 98 THEN 'Any other ethnic group'
						ELSE 'Not provided'					
					END
				, 'Contracting Area' = 
					CASE COALESCE(ap.CreatedBy, ap.LastModifiedTouchpointId)
					WHEN '0000000101' THEN 'East of England and Bucks'
					WHEN '0000000102' THEN 'East Mids + Northants'
					WHEN '0000000103' THEN 'London'
					WHEN '0000000104' THEN 'West Midl'
					WHEN '0000000105' THEN 'North West'
					WHEN '0000000106' THEN 'North East and Cumbria'
					WHEN '0000000107' THEN 'South East'
					WHEN '0000000108' THEN 'South West'
					WHEN '0000000109' THEN 'Yorkshire and Humber'
					WHEN '0000000999' THEN 'National Careers Helpline'
				END		
				, COALESCE(ap.SubcontractorId, '')						AS 'Subcontractor Name'
				, ap.id													AS 'Action Plan ID'
				, 'Add employment status here'							AS 'Employment Status'
				, 'Add length of unemployment'							AS 'Length of unemployment'
				, 'Add Learning Status'									AS 'Learning Status'
				, 'Qualification leve;'									AS 'Qualification Level'
				, 'Referral' =
					CASE COALESCE(c.IntroducedBy, 0)
						WHEN 1 THEN 'Advanced Learning Loans'
						WHEN 2 THEN 'Apprenticeship Service'
						WHEN 3 THEN 'Careers Fair/Activity'
						WHEN 4 THEN 'Charity'
						WHEN 5 THEN 'Citizens Advice'
						WHEN 6 THEN 'College/6th Form'
						WHEN 7 THEN 'Community Centre/Library'
						WHEN 8 THEN 'Employer'
						WHEN 9 THEN 'Facebook'
						WHEN 10 THEN 'Job Centre Plus'
						WHEN 11 THEN 'LEP'
						WHEN 12 THEN 'National careers service website'
						WHEN 13 THEN 'Newspaper/magazine'
						WHEN 14 THEN 'Billboard or Public Transport Advert'
						WHEN 15 THEN 'Professional Body or Organisation'
						WHEN 16 THEN 'Radio'
						WHEN 17 THEN 'School'
						WHEN 18 THEN 'Training Provider'
						WHEN 19 THEN 'TV'
						WHEN 20 THEN 'Twitter'
						WHEN 21 THEN 'University/School/College/Training Provider'
						WHEN 22 THEN 'University'
						WHEN 23 THEN 'Word of Mouth'
						WHEN 24 THEN 'World Skills UK Live'
						WHEN 25 THEN 'National Retraining Scheme'
						WHEN 98 THEN 'Other'
						ELSE 'Not provided'
					END
				, 'Channel' = 
					CASE i.Channel
						WHEN 1 THEN 'Face to Face'
						WHEN 2 THEN 'Telephone'
						WHEN 3 THEN 'Webchat'
						WHEN 4 THEN 'Videochat'
						WHEN 5 THEN 'Email'
						WHEN 6 THEN 'Social Media'
						WHEN 7 THEN 'SMS'
						WHEN 8 THEN 'Other'
						WHEN 9 THEN 'Co-browse'
						WHEN 99 THEN 'Other'	
					END
				, CAST(s.DateandTimeOfSession AS DATE)				AS 'Session Date'
				, 'True'											AS 'Participate Research Evaluation'
				, 'Priority Group' = 
					CASE o.ClaimedPriorityGroup
						WHEN 1 THEN '18 to 24 not in education, employment or training'
						WHEN 2 THEN 'Low skilled adults without a level 2 qualification'
						WHEN 3 THEN 'Adults who have been unemployed for more than 12 months'
						WHEN 4 THEN 'Single parents with at least one dependant child living in the same household'
						WHEN 5 THEN 'Adults with special educational needs and/or disabilities'
						WHEN 6 THEN 'Adults aged 50 years or over who are unemployed or at demonstrable risk of unemployment'
						WHEN 99 THEN 'Not a priority customer'
					END
				, 'Termination of Service Reason' = 
					CASE c.ReasonForTermination
						WHEN 1 THEN 'Customer Choice'
						WHEN 2 THEN 'Deceased'
						WHEN 3 THEN 'Duplicate'
						WHEN 99 THEN 'Other'
						ELSE ''
					END
	FROM		[dss-customers] c
	LEFT JOIN	[dss-contacts] con ON con.CustomerId = c.id
	LEFT JOIN	[dss-addresses] a ON a.CustomerId = c.Id
	LEFT JOIN	[dss-diversitydetails] d ON d.CustomerId = c.Id
	INNER JOIN	[dss-actionplans] ap ON ap.CustomerId = c.id
	INNER JOIN	[dss-interactions] i ON i.id = ap.InteractionId
	INNER JOIN	[dss-sessions] s ON s.id = ap.SessionId
	INNER JOIN	[dss-outcomes] o ON o.ActionPlanId = ap.id
	WHERE		c.OptInMarketResearch = 1					-- true
	AND			COALESCE(c.ReasonForTermination, 0) NOT IN (1,2)
	AND			ap.DateActionPlanCreated BETWEEN @startDate AND @endDate
END