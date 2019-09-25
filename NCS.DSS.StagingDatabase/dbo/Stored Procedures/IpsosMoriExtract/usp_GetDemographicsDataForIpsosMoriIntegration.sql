
-------------------------------------------------------------------------------
-- Authors:      Kevin Brandon
-- Created:      14/08/2019
-- Purpose:      Produce demographics data for Ipsos-Mori integration.
--  
-------------------------------------------------------------------------------
-- Modification History
-- Initial creation.
-- 
--            
-- Copyright © 2019, ESFA, All Rights Reserved
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_GetDemographicsDataForIpsosMoriIntegration]
AS							   
BEGIN		
	DECLARE @startDate DATE;
	DECLARE @endDate DATE;
	DECLARE @age_group_name  varchar(100);
	DECLARE @employment_group_name varchar(100);
	DECLARE @gender_group_name varchar(100);

	SET @startDate = DATEADD(MONTH,datediff(MONTH,0,GETDATE())-1,0)
	SET @endDate = DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1)
	SET @age_group_name = 'Age';
	SET @employment_group_name = 'Employment Status adult - By employment category';
	SET @gender_group_name = 'Gender - By gender category';

	with DemographicData AS
	(
		SELECT 
			DATEDIFF(hour,DateOfBirth,GETDATE())/8766 AS Age
			, c.LastModifiedTouchpointId AS touchpointId
			, c.Gender, ep.CurrentEmploymentStatus AS EpStatus
		FROM [dbo].[dss-customers] c, [dbo].[dss-diversitydetails] dd, [dbo].[dss-employmentprogressions] ep, [dbo].[dss-actionplans] ap
		WHERE c.id = dd.CustomerId and  c.id = ep.CustomerId and c.DateOfBirth is not null
		AND c.id = ap.CustomerId AND ap.DateActionPlanCreated BETWEEN @startDate AND @endDate
	)
	, age_group_base AS
	(
		select @age_group_name AS group_name, '18-19' as group_value
		UNION
		select @age_group_name AS group_name, '20-24' as group_value
		UNION
		select @age_group_name AS group_name, '25-49' as group_value
		UNION
		select @age_group_name AS group_name, '50+' as group_value
	)
	, age_grouping AS
		(	
			SELECT 
				@age_group_name AS group_name,
				CASE 
					WHEN age between 18 and 19 THEN '18-19'
					WHEN age between 20 and 24 THEN '20-24'
					WHEN age between 25 and 49 THEN '25-49'
					WHEN age >= 50 THEN '50+'
					WHEN age < 18 THEN '<18'
					ELSE 'other'
				END AS group_value,
				age,
				touchpointId
			FROM DemographicData
		)
	, age_groups AS
		(
			SELECT group_name, group_value, touchpointId, count(1) AS count
			FROM age_grouping
			group BY group_name, group_value, touchpointId
		)

	, age_report AS
	(
		select a.group_name,
			   a.group_value,
			   ROW_NUMBER() OVER(ORDER BY a.group_name ASC) AS RowNum,
			   IsNull(cast(g1.count as varchar(10)),'0') as '0000000101',
			   IsNull(cast(g2.count as varchar(10)),'0')  as '0000000102',
			   IsNull(cast(g3.count as varchar(10)),'0') as '0000000103',
			   IsNull(cast(g4.count as varchar(10)),'0') as '0000000104',
			   IsNull(cast(g5.count as varchar(10)),'0') as '0000000105',
			   IsNull(cast(g6.count as varchar(10)),'0') as '0000000106',
			   IsNull(cast(g7.count as varchar(10)),'0') as '0000000107',
			   IsNull(cast(g8.count as varchar(10)),'0') as '0000000108',
			   IsNull(cast(g9.count as varchar(10)),'0') as '0000000109'
		from age_group_base a  
			left join age_groups g1 on a.group_value = g1.group_value and g1.touchpointId = '0000000101'
			left join age_groups g2 on a.group_value = g2.group_value and g2.touchpointId = '0000000102'
			left join age_groups g3 on a.group_value = g3.group_value and g3.touchpointId = '0000000103'
			left join age_groups g4 on a.group_value = g4.group_value and g4.touchpointId = '0000000104'
			left join age_groups g5 on a.group_value = g5.group_value and g5.touchpointId = '0000000105'
			left join age_groups g6 on a.group_value = g6.group_value and g6.touchpointId = '0000000106'
			left join age_groups g7 on a.group_value = g7.group_value and g7.touchpointId = '0000000107'
			left join age_groups g8 on a.group_value = g8.group_value and g8.touchpointId = '0000000108'
			left join age_groups g9 on a.group_value = g9.group_value and g9.touchpointId = '0000000109'
		)

	, gender_group_base AS
	(
		select @gender_group_name AS group_name, 'Female' as group_value
		UNION
		select @gender_group_name AS group_name, 'Male' as group_value
		UNION
		select @gender_group_name AS group_name, 'Not applicable' as group_value
		UNION
		select @gender_group_name AS group_name, 'Not provided' as group_value
	)
	, gender_gouping AS
		( 
			SELECT 
				@gender_group_name AS group_name,
				CASE 
					WHEN gender = 1 THEN 'Female'	   
					WHEN gender = 2 THEN 'Male'
					WHEN gender = 3 THEN 'Not applicable'
					WHEN gender = 99 THEN 'Not provided'
					ELSE 'other'
				END AS group_value
				, touchpointId
			FROM DemographicData
		)
	, gender_groups AS
		(
			SELECT group_name, group_value, touchpointId, count(1) AS count
			FROM gender_gouping
			group BY group_name, group_value, touchpointId
		)

	, gender_report AS
	(
	select a.group_name,
			   a.group_value,
			   ROW_NUMBER() OVER(ORDER BY a.group_name ASC) AS RowNum,
			   IsNull(cast(g1.count as varchar(10)),'0') as '0000000101',
			   IsNull(cast(g2.count as varchar(10)),'0')  as '0000000102',
			   IsNull(cast(g3.count as varchar(10)),'0') as '0000000103',
			   IsNull(cast(g4.count as varchar(10)),'0') as '0000000104',
			   IsNull(cast(g5.count as varchar(10)),'0') as '0000000105',
			   IsNull(cast(g6.count as varchar(10)),'0') as '0000000106',
			   IsNull(cast(g7.count as varchar(10)),'0') as '0000000107',
			   IsNull(cast(g8.count as varchar(10)),'0') as '0000000108',
			   IsNull(cast(g9.count as varchar(10)),'0') as '0000000109'
		from gender_group_base a  
			left join gender_groups g1 on a.group_value = g1.group_value and g1.touchpointId = '0000000101'
			left join gender_groups g2 on a.group_value = g2.group_value and g2.touchpointId = '0000000102'
			left join gender_groups g3 on a.group_value = g3.group_value and g3.touchpointId = '0000000103'
			left join gender_groups g4 on a.group_value = g4.group_value and g4.touchpointId = '0000000104'
			left join gender_groups g5 on a.group_value = g5.group_value and g5.touchpointId = '0000000105'
			left join gender_groups g6 on a.group_value = g6.group_value and g6.touchpointId = '0000000106'
			left join gender_groups g7 on a.group_value = g7.group_value and g7.touchpointId = '0000000107'
			left join gender_groups g8 on a.group_value = g8.group_value and g8.touchpointId = '0000000108'
			left join gender_groups g9 on a.group_value = g9.group_value and g9.touchpointId = '0000000109'
	 )
	, employment_group_base AS
	(
		select @employment_group_name AS group_name, 'Economically inactive (Inc with voluntary work)' as group_value
		UNION
		select @employment_group_name AS group_name, 'Employed (inc with voluntary work)' as group_value
		UNION
		select @employment_group_name AS group_name, 'Not known / not provided' as group_value
		UNION
		select @employment_group_name AS group_name, 'Retired (Inc with voluntary work)' as group_value
		UNION
		select @employment_group_name AS group_name, 'Self Employed (Inc with voluntary work)' as group_value
		UNION
		select @employment_group_name AS group_name, 'Unemployed (Inc with voluntary work)' as group_value

	)
	, employment_grouping AS
		(	
			SELECT 
				@employment_group_name AS group_name,
				CASE 
					WHEN EpStatus between 2 and 3 THEN 'Economically inactive (Inc with voluntary work)'
					WHEN EpStatus between 4 and 5 THEN 'Employed (inc with voluntary work)'
					WHEN EpStatus between 98 and 99 THEN 'Not known / not provided'
					WHEN EpStatus between 7 and 8 THEN 'Retired (Inc with voluntary work)'
					WHEN EpStatus between 9 and 10 THEN	'Self Employed (Inc with voluntary work)'
					WHEN EpStatus between 11 and 12 THEN 'Unemployed (Inc with voluntary work)'
					ELSE 'other'
				END AS group_value,
				EpStatus,
				touchpointId
			FROM DemographicData
		)
		, employment_groups AS
		(
			SELECT group_name, group_value, touchpointId, count(1) AS count
			FROM employment_grouping
			group BY group_name, group_value, touchpointId
		)
		, employment_report AS
		(
		select a.group_name,
			   a.group_value,
			   ROW_NUMBER() OVER(ORDER BY a.group_name ASC) AS RowNum,
			   IsNull(cast(g1.count as varchar(10)),'0') as '0000000101',
			   IsNull(cast(g2.count as varchar(10)),'0')  as '0000000102',
			   IsNull(cast(g3.count as varchar(10)),'0') as '0000000103',
			   IsNull(cast(g4.count as varchar(10)),'0') as '0000000104',
			   IsNull(cast(g5.count as varchar(10)),'0') as '0000000105',
			   IsNull(cast(g6.count as varchar(10)),'0') as '0000000106',
			   IsNull(cast(g7.count as varchar(10)),'0') as '0000000107',
			   IsNull(cast(g8.count as varchar(10)),'0') as '0000000108',
			   IsNull(cast(g9.count as varchar(10)),'0') as '0000000109'
		from employment_group_base a  
			left join employment_groups g1 on a.group_value = g1.group_value and g1.touchpointId = '0000000101'
			left join employment_groups g2 on a.group_value = g2.group_value and g2.touchpointId = '0000000102'
			left join employment_groups g3 on a.group_value = g3.group_value and g3.touchpointId = '0000000103'
			left join employment_groups g4 on a.group_value = g4.group_value and g4.touchpointId = '0000000104'
			left join employment_groups g5 on a.group_value = g5.group_value and g5.touchpointId = '0000000105'
			left join employment_groups g6 on a.group_value = g6.group_value and g6.touchpointId = '0000000106'
			left join employment_groups g7 on a.group_value = g7.group_value and g7.touchpointId = '0000000107'
			left join employment_groups g8 on a.group_value = g8.group_value and g8.touchpointId = '0000000108'
			left join employment_groups g9 on a.group_value = g9.group_value and g9.touchpointId = '0000000109'
		)
		, blank_row as
		(

			select '' as group_name, '' as group_value, 0 as RowNum,
				'' as '0000000101',
			   '' as '0000000102',
			   '' as '0000000103',
			   '' as '0000000104',
			   '' as '0000000105',
			   '' as '0000000106',
			   '' as '0000000107',
			   '' as '0000000108',
			   '' as '0000000109'

		)
		-- bring the 3 reports together

		select 
		case RowNum
		  when  1 then q.group_name
		  else ''
		end  as ' ',
		--q.group_name as ' ' ,
			  q.group_value as '[ReportingMontth] '  ,
		--	   q.RowNum,
			   q.[0000000101]  as 'London',
			   q.[0000000102] as 'East of England and Buckinghamshire' ,
			   q.[0000000103]  as 'East Midlands and Northamptonshire',
			   q.[0000000104]  as 'Yorkshire and Humber',
			   q.[0000000105]  as 'West Midlands and Staffordshire',
			   q.[0000000106]  as 'South West and Oxfordshire',
			   q.[0000000107]  as 'South East',
			   q.[0000000108]  as 'North West',
			   q.[0000000109]  as 'North East & Cumbria'

		from
		(
			select * from blank_row
			UNION ALL
			SELECT * FROM age_report
			UNION ALL
			select * from blank_row
			UNION ALL
			SELECT * FROM employment_report
			UNION ALL
			select * from blank_row
			UNION ALL
			SELECT * FROM gender_report
		) q;
END;