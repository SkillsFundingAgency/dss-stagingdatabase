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
	SELECT 
		 a.group_name
		,a.group_value AS 'group_value'
		,a.touchpoint1 AS 'London'
		,a.touchpoint2 AS 'East of England and Buckinghamshire'	
		,a.touchpoint3 AS 'East Midlands and Northamptonshire'	
		,a.touchpoint4 AS 'Yorkshire and Humber'	
		,a.touchpoint5 AS 'West Midlands and Staffordshire'	
		,a.touchpoint6 AS 'South West and Oxfordshire'	
		,a.touchpoint7 AS 'South East'	
		,a.touchpoint8 AS 'North West'	
		,a.touchpoint9 AS 'North East & Cumbria'
		,a.touchpoint10 AS 'National Careers Helpline'
	FROM udf_DemographicsAgeReport() AS a	
	
	UNION ALL	
	SELECT
	 ''
	,''
	,'' AS 'London'
	,'' AS 'East of England and Buckinghamshire'	
	,'' AS 'East Midlands and Northamptonshire'	
	,'' AS 'Yorkshire and Humber'	
	,'' AS 'West Midlands and Staffordshire'	
	,'' AS 'South West and Oxfordshire'	
	,'' AS 'South East'	
	,'' AS 'North West'	
	,'' AS 'North East & Cumbria'
	,''  AS 'National Careers Helpline'

	UNION ALL
	SELECT 
	 es.group_name
	,es.group_value AS 'group_value'
	,es.touchpoint1 AS 'London'
	,es.touchpoint2 AS 'East of England and Buckinghamshire'	
	,es.touchpoint3 AS 'East Midlands and Northamptonshire'	
	,es.touchpoint4 AS 'Yorkshire and Humber'	
	,es.touchpoint5 AS 'West Midlands and Staffordshire'	
	,es.touchpoint6 AS 'South West and Oxfordshire'	
	,es.touchpoint7 AS 'South East'	
	,es.touchpoint8 AS 'North West'	
	,es.touchpoint9 AS 'North East & Cumbria'
	,es.touchpoint10 AS 'National Careers Helpline'
	FROM udf_DemographicsEmploymentReport() AS es

UNION ALL	
	SELECT
	 ''
	,''
	,'' AS 'London'
	,'' AS 'East of England and Buckinghamshire'	
	,'' AS 'East Midlands and Northamptonshire'	
	,'' AS 'Yorkshire and Humber'	
	,'' AS 'West Midlands and Staffordshire'	
	,'' AS 'South West and Oxfordshire'	
	,'' AS 'South East'	
	,'' AS 'North West'	
	,'' AS 'North East & Cumbria'
	,''  AS 'National Careers Helpline'
		
	UNION ALL
	SELECT
	 g.group_name
	,g.group_value AS 'group_value'
	,g.touchpoint1 AS 'London'
	,g.touchpoint2 AS 'East of England and Buckinghamshire'	
	,g.touchpoint3 AS 'East Midlands and Northamptonshire'	
	,g.touchpoint4 AS 'Yorkshire and Humber'	
	,g.touchpoint5 AS 'West Midlands and Staffordshire'	
	,g.touchpoint6 AS 'South West and Oxfordshire'	
	,g.touchpoint7 AS 'South East'	
	,g.touchpoint8 AS 'North West'	
	,g.touchpoint9 AS 'North East & Cumbria'
	,g.touchpoint10 AS 'National Careers Helpline'
	FROM
		udf_DemographicsGenderReport()  AS g

	UNION ALL	
	SELECT
	 ''
	,''
	,'' AS 'London'
	,'' AS 'East of England and Buckinghamshire'	
	,'' AS 'East Midlands and Northamptonshire'	
	,'' AS 'Yorkshire and Humber'	
	,'' AS 'West Midlands and Staffordshire'	
	,'' AS 'South West and Oxfordshire'	
	,'' AS 'South East'	
	,'' AS 'North West'	
	,'' AS 'North East & Cumbria'
	,''  AS 'National Careers Helpline'

	UNION ALL
	SELECT
	 nch.group_name
	,nch.group_value AS 'group_value'
	,nch.touchpoint1 AS 'London'
	,nch.touchpoint2 AS 'East of England and Buckinghamshire'	
	,nch.touchpoint3 AS 'East Midlands and Northamptonshire'	
	,nch.touchpoint4 AS 'Yorkshire and Humber'	
	,nch.touchpoint5 AS 'West Midlands and Staffordshire'	
	,nch.touchpoint6 AS 'South West and Oxfordshire'	
	,nch.touchpoint7 AS 'South East'	
	,nch.touchpoint8 AS 'North West'	
	,nch.touchpoint9 AS 'North East & Cumbria'
	,nch.touchpoint10 AS 'National Careers Helpline'
	FROM
		udf_DemographicsNCHReport()  AS nch
END;