CREATE PROCEDURE [dbo].[insert-dss-prioritygroups-history] (@Json NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO [dss-prioritygroups-history]
		SELECT DATEADD(MINUTE, _ts/60, DATEADD(SECOND, _ts%60, '19700101')) as CosmosTimeStamp, A.id, B.PriorityGroup
			FROM OPENJSON(@Json) WITH (
				_ts BIGINT,
				id NVARCHAR(MAX) '$.id', 
				PriorityGroups NVARCHAR(MAX) AS JSON
				) A
			CROSS APPLY OPENJSON (A.PriorityGroups) WITH (PriorityGroup INT '$') B
END