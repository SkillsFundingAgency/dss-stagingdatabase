-------------------------------------------------------------------------------
-- Authors:      Kevin Brandon
-- Created:      25/09/2019
-- Purpose:      Ipsos-Mori Demographics Gender report.
--  
-------------------------------------------------------------------------------
-- Modification History
-- Initial creation.
-- 
--            
-- Copyright © 2019, ESFA, All Rights Reserved
-------------------------------------------------------------------------------
CREATE FUNCTION [dbo].[udf_DemographicsGenderReport]()
RETURNS @demographics_gender TABLE 
( 
		group_name VARCHAR(50), 
		group_value VARCHAR(50),	
		touchpoint1 VARCHAR(50),
		touchpoint2 VARCHAR(50),
		touchpoint3 VARCHAR(50),
		touchpoint4 VARCHAR(50),
		touchpoint5 VARCHAR(50),
		touchpoint6 VARCHAR(50),
		touchpoint7 VARCHAR(50),
		touchpoint8 VARCHAR(50),
		touchpoint9 VARCHAR(50),
		touchpoint10 VARCHAR(50) 
)
AS		
BEGIN	
	DECLARE @startDate DATE;
	DECLARE @endDate DATE;
	DECLARE @gender_group_name  varchar(100);
	SET @startDate = DATEADD(MONTH,datediff(MONTH,0,GETDATE())-1,0);
	SET @endDate = DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1);
	SET @gender_group_name = 'Gender';

	with DemographicData AS
	(
		SELECT 
			c.Gender AS Gender
			, COALESCE(ap.CreatedBy, ap.LastModifiedTouchpointId, i.LastModifiedTouchPointId) AS touchpointId
			, ap.id as ap_id
			, (select count(1) from [dss-interactions] i2 where i2.CustomerId = i.CustomerId and i2.DateAndTimeOfInteraction < @startDate )  as prev_interactions
			, (select count(1) from [dss-actionplans] ap2 where ap2.CustomerId = i.CustomerId and ap2.DateActionPlanCreated < @startDate  ) as prev_actionplans
			,rank () over ( partition by c.id order by iif(ap.id is null,2,1), i.DateandTimeOfInteraction, i.LastModifiedDate, i.id ) ro   
			,ROW_NUMBER() OVER (PARTITION BY c.id ORDER BY (c.id)) AS DupeRowCount
			FROM [dbo].[dss-customers] c
			left join [dss-interactions] i on c.id = i.CustomerId
			left join  [dbo].[dss-actionplans] ap on  c.id = ap.CustomerId
			WHERE 
			(
				cast(ap.DateActionPlanCreated AS DATE) BETWEEN @startDate AND @endDate-- AND ap.CreatedBy <> '0000000999'
				OR CAST(i.DateandTimeOfInteraction AS DATE) BETWEEN @startDate AND @endDate AND i.TouchpointId = '0000000999'
			)
			AND  (CASE WHEN dateadd(year, datediff (year, DateOfBirth, getdate()), DateOfBirth) > getdate()
            THEN datediff(year, DateOfBirth, getdate()) - 1
            ELSE datediff(year, DateOfBirth, getdate())
			END) > 17

	)
	,
	gender_group_base AS
	(
		select @gender_group_name AS group_name, 'Female' as group_value
		UNION
		select @gender_group_name AS group_name, 'Male' as group_value
		UNION
		select @gender_group_name AS group_name, 'Not applicable' as group_value
		UNION
		select @gender_group_name AS group_name, 'Not provided' as group_value
	)
	, 
	gender_gouping AS
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
				, gender
				, touchpointId
			FROM DemographicData
			WHERE ro = 1 -- exclude duplicate rows within the reporting period
					and (
								-- if an action plan is present check no actions plans exist from before the reporting period
							( ap_id is not null  AND prev_actionplans = 0 )
							OR
								-- if an action plan does not exists check no interactions exist from before the reporting period
							( ap_id is null AND prev_interactions = 0 )
						)
					and DupeRowCount = 1						
	)
	, 
	gender_groups AS
	(
			SELECT group_name, group_value, touchpointId, count(1) AS count
			FROM gender_gouping
			group BY group_name, group_value, touchpointId
	)

	INSERT @demographics_gender
	select a.group_name,
			   a.group_value,
			IsNull(cast(g1.count as varchar(10)),'0') as 'touchpoint1',
			IsNull(cast(g2.count as varchar(10)),'0') as 'touchpoint2',
			IsNull(cast(g3.count as varchar(10)),'0') as 'touchpoint3',
			IsNull(cast(g4.count as varchar(10)),'0') as 'touchpoint4',
			IsNull(cast(g5.count as varchar(10)),'0') as 'touchpoint5',
			IsNull(cast(g6.count as varchar(10)),'0') as 'touchpoint6',
			IsNull(cast(g7.count as varchar(10)),'0') as 'touchpoint7',
			IsNull(cast(g8.count as varchar(10)),'0') as 'touchpoint8',
			IsNull(cast(g9.count as varchar(10)),'0') as 'touchpoint9',
			IsNull(cast(g10.count as varchar(10)),'0') as 'touchpoint10'

		FROM gender_group_base a  
			left join gender_groups g1 on a.group_value = g1.group_value and g1.touchpointId = '0000000101'
			left join gender_groups g2 on a.group_value = g2.group_value and g2.touchpointId = '0000000102'
			left join gender_groups g3 on a.group_value = g3.group_value and g3.touchpointId = '0000000103'
			left join gender_groups g4 on a.group_value = g4.group_value and g4.touchpointId = '0000000104'
			left join gender_groups g5 on a.group_value = g5.group_value and g5.touchpointId = '0000000105'
			left join gender_groups g6 on a.group_value = g6.group_value and g6.touchpointId = '0000000106'
			left join gender_groups g7 on a.group_value = g7.group_value and g7.touchpointId = '0000000107'
			left join gender_groups g8 on a.group_value = g8.group_value and g8.touchpointId = '0000000108'
			left join gender_groups g9 on a.group_value = g9.group_value and g9.touchpointId = '0000000109'
			left join gender_groups g10 on a.group_value = g10.group_value and g10.touchpointId = '0000000999'

		RETURN
END;
GO