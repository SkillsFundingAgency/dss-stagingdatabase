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
		,a.touchpoint1 AS 'East of England and Buckinghamshire'
		,a.touchpoint2 AS 'East Midlands and Northamptonshire'	
		,a.touchpoint3 AS 'London'	
		,a.touchpoint4 AS 'West Midlands and Staffordshire'	
		,a.touchpoint5 AS 'North West'	
		,a.touchpoint6 AS 'North East and Cumbria'	
		,a.touchpoint7 AS 'South East'	
		,a.touchpoint8 AS 'South West'	
		,a.touchpoint9 AS 'Yorkshire and Humber'
		,a.touchpoint10 AS 'National Careers Helpline'
	FROM udf_DemographicsAgeReport() AS a	
	
	UNION ALL	
	SELECT
	 ''
	,''
	,'' AS 'East of England and Buckinghamshire'
	,'' AS 'East Midlands and Northamptonshire'	
	,'' AS 'London'	
	,'' AS 'West Midlands and Staffordshire'	
	,'' AS 'North West'	
	,'' AS 'North East and Cumbria'	
	,'' AS 'South East'	
	,'' AS 'South West'	
	,'' AS 'Yorkshire and Humber'
	,''  AS 'National Careers Helpline'

	UNION ALL
	SELECT 
	 es.group_name
	,es.group_value AS 'group_value'
	,es.touchpoint1 AS 'East of England and Buckinghamshire'
	,es.touchpoint2 AS 'East Midlands and Northamptonshire'	
	,es.touchpoint3 AS 'London'	
	,es.touchpoint4 AS 'West Midlands and Staffordshire'	
	,es.touchpoint5 AS 'North West'	
	,es.touchpoint6 AS 'North East and Cumbria'	
	,es.touchpoint7 AS 'South East'	
	,es.touchpoint8 AS 'South West'	
	,es.touchpoint9 AS 'Yorkshire and Humber'
	,es.touchpoint10 AS 'National Careers Helpline'
	FROM udf_DemographicsEmploymentReport() AS es

UNION ALL	
	SELECT
	 ''
	,''
	,'' AS 'East of England and Buckinghamshire'
	,'' AS 'East Midlands and Northamptonshire'	
	,'' AS 'London'	
	,'' AS 'West Midlands and Staffordshire'	
	,'' AS 'North West'	
	,'' AS 'North East and Cumbria'	
	,'' AS 'South East'	
	,'' AS 'South West'	
	,'' AS 'Yorkshire and Humber'
	,''  AS 'National Careers Helpline'
		
	UNION ALL
	SELECT
	 g.group_name
	,g.group_value AS 'group_value'
	,g.touchpoint1 AS 'East of England and Buckinghamshire'
	,g.touchpoint2 AS 'East Midlands and Northamptonshire'	
	,g.touchpoint3 AS 'London'	
	,g.touchpoint4 AS 'West Midlands and Staffordshire'	
	,g.touchpoint5 AS 'North West'	
	,g.touchpoint6 AS 'North East and Cumbria'	
	,g.touchpoint7 AS 'South East'	
	,g.touchpoint8 AS 'South West'	
	,g.touchpoint9 AS 'Yorkshire and Humber'
	,g.touchpoint10 AS 'National Careers Helpline'
	FROM
		udf_DemographicsGenderReport()  AS g

	UNION ALL	
	SELECT
	 ''
	,''
	,'' AS 'East of England and Buckinghamshire'
	,'' AS 'East Midlands and Northamptonshire'	
	,'' AS 'London'	
	,'' AS 'West Midlands and Staffordshire'	
	,'' AS 'North West'	
	,'' AS 'North East and Cumbria'	
	,'' AS 'South East'	
	,'' AS 'South West'	
	,'' AS 'Yorkshire and Humber'
	,''  AS 'National Careers Helpline'

	UNION ALL
	SELECT
	 nch.group_name
	,nch.group_value AS 'group_value'
	,nch.touchpoint1 AS 'East of England and Buckinghamshire' -- East of England and Buckinghamshire
	,nch.touchpoint2 AS 'East Midlands and Northamptonshire'-- East Midlands and Northamptonshire
	,nch.touchpoint3 AS 'London' -- London
	,nch.touchpoint4 AS 'West Midlands and Staffordshire' -- West Midlands
	,nch.touchpoint5 AS 'North West' -- North West
	,nch.touchpoint6 AS 'North East and Cumbria'	-- North East and Cumbria
	,nch.touchpoint7 AS 'South East' -- South East
	,nch.touchpoint8 AS 'South West' -- South West	
	,nch.touchpoint9 AS 'Yorkshire and Humber' -- Yorkshire and Humber
	,nch.touchpoint10 AS 'National Careers Helpline'
	FROM
		udf_DemographicsNCHReport()  AS nch
END;