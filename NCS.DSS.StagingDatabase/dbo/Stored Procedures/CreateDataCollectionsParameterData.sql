CREATE PROCEDURE [dbo].[CreateDataCollectionsParameterData]
AS
BEGIN
	SET NOCOUNT ON

	INSERT INTO [dss-data-collections-params] (ParameterName, ParameterValue) VALUES ('MinAge', '18')
	INSERT INTO [dss-data-collections-params] (ParameterName, ParameterValue) VALUES ('MaxAge', '100')
	INSERT INTO [dss-data-collections-params] (ParameterName, ParameterValue) VALUES ('ContractStartDate', '2018/10/01')
	INSERT INTO [dss-data-collections-params] (ParameterName, ParameterValue) VALUES ('TimeTravel', '0');
	INSERT INTO [dss-data-collections-params] (ParameterName, ParameterValue) VALUES ('FeedStartDate', '2019/1/4');
END
