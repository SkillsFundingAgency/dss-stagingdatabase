USE [dss-local-shared-stag-db]
GO
/****** Object:  StoredProcedure [dbo].[Change_Feed_Insert_Update_dss-prioritygroups]    Script Date: 17/02/2020 13:35:17 ******/
CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-prioritygroups] (@Json NVARCHAR(MAX))
AS
BEGIN

	--Delete current ones first as an update or create will contain all priority groups in the call
	DELETE FROM [dss-prioritygroups] 
	WHERE CustomerId IN
	(
	SELECT id
	FROM OPENJSON(@Json)
		WITH (
			id NVARCHAR(MAX) '$.id'
			) J
	)


	-- Insert everything that has come through the new call
	INSERT INTO [dss-prioritygroups]
	SELECT A.id, B.PriorityGroup
	FROM OPENJSON(@Json)
		WITH (
			id NVARCHAR(MAX) '$.id', 
			PriorityGroups NVARCHAR(MAX) AS JSON
			) A
			CROSS APPLY OPENJSON (A.PriorityGroups) WITH (PriorityGroup INT '$') B

END