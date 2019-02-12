CREATE PROCEDURE [dbo].[CreateDataCollectionsParameterData]
AS
BEGIN
	SET NOCOUNT ON


	IF OBJECT_ID('dss-data-collections-params', 'U') IS NOT NULL 
		BEGIN
			TRUNCATE TABLE [dss-data-collections-parameters]
		END
	ELSE
		BEGIN
			CREATE TABLE [dbo].[dss-data-collections-parameters]
			(
				[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
				[ParameterName] NVARCHAR(50) NOT NULL, 
				[ParameterValue] NVARCHAR(50) NOT NULL
			)								
		END	

	INSERT INTO [dss-data-collections-parameters] (ParameterName, ParameterValue) VALUES ('MinAge', '18')
	INSERT INTO [dss-data-collections-parameters] (ParameterName, ParameterValue) VALUES ('MaxAge', '100')
	INSERT INTO [dss-data-collections-parameters] (ParameterName, ParameterValue) VALUES ('ContractStartDate', '2018/10/01')	
END
