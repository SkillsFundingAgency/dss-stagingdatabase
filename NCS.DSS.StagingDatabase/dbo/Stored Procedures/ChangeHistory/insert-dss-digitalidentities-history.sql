CREATE PROCEDURE [dbo].[insert-dss-digitalidentities-history] (@Json NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO [dss-digitalidentities-history] 
		SELECT DATEADD(MINUTE, _ts/60, DATEADD(SECOND, _ts%60, '19700101')) as CosmosTimeStamp, id, CustomerId, IdentityStoreId,
			   LegacyIdentity, id_token, LastLoggedInDateTime, LastModifiedDate, LastModifiedTouchpointId, DateOfTermination, CreatedBy	
			FROM OPENJSON(@Json) WITH (
				_ts BIGINT
				,id UNIQUEIDENTIFIER
				,CustomerId UNIQUEIDENTIFIER
				,IdentityStoreId UNIQUEIDENTIFIER
				,LegacyIdentity VARCHAR(Max)
				,id_token VARCHAR(Max)
				,LastLoggedInDateTime DATETIME2
				,LastModifiedDate DATETIME2
				,LastModifiedTouchpointId VARCHAR(max)
				,DateOfTermination DATETIME2
				,CreatedBy VARCHAR(MAX)
				)
END