CREATE PROCEDURE [dbo].[CreateDataCollectionsParameterData]
AS
BEGIN
	SET NOCOUNT ON

	INSERT INTO [dss-data-collections-parameters] (ParameterName, ParameterValue) VALUES ('MinAge', '18')
	INSERT INTO [dss-data-collections-parameters] (ParameterName, ParameterValue) VALUES ('MaxAge', '100')
	INSERT INTO [dss-data-collections-parameters] (ParameterName, ParameterValue) VALUES ('ContractStartDate', '2018/10/01')	
END
