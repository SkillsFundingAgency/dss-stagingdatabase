CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-digitalidentities] (@Json NVARCHAR(MAX))
AS
BEGIN
	MERGE INTO [dss-digitalidentities] AS digitalidentities
	USING (
		SELECT *
		FROM OPENJSON(@Json) WITH (
				id UNIQUEIDENTIFIER
				,CustomerId UNIQUEIDENTIFIER
				,IdentityStoreId UNIQUEIDENTIFIER
				,LegacyIdentity VARCHAR(Max)
				,id_token VARCHAR(Max)
				,LastLoggedInDateTime DATETIME2
				,LastModifiedDate DATETIME2
				,LastModifiedTouchpointId VARCHAR(max)
				,DateOfClosure DATETIME2
				,CreatedBy VARCHAR(MAX)
				)
		) AS InputJSON
		ON (digitalidentities.id = InputJSON.id)
	WHEN MATCHED
		THEN
			UPDATE
			SET digitalidentities.id = InputJSON.id
				,digitalidentities.CustomerId = InputJSON.CustomerId
				,digitalidentities.IdentityStoreId = InputJSON.IdentityStoreId
				,digitalidentities.LegacyIdentity  = InputJSON.LegacyIdentity
				,digitalidentities.id_token  = InputJSON.id_token
				,digitalidentities.LastLoggedInDateTime  = InputJSON.LastLoggedInDateTime
				,digitalidentities.LastModifiedDate  = InputJSON.LastModifiedDate
				,digitalidentities.LastModifiedTouchpointId  = InputJSON.LastModifiedTouchpointId
				,digitalidentities.DateOfClosure  = InputJSON.DateOfClosure
				,digitalidentities.CreatedBy = InputJSON.CreatedBy
	WHEN NOT MATCHED
		THEN
			INSERT (
				id
				,CustomerId
				,IdentityStoreId
				,LegacyIdentity
				,id_token
				,LastLoggedInDateTime
				,LastModifiedDate
				,LastModifiedTouchpointId
				,DateOfClosure
				,CreatedBy
				)
			VALUES (
				InputJSON.id
				,InputJSON.CustomerId
				,InputJSON.IdentityStoreId
				,InputJSON.LegacyIdentity
				,InputJSON.id_token
				,InputJSON.LastLoggedInDateTime
				,InputJSON.LastModifiedDate
				,InputJSON.LastModifiedTouchpointId
				,InputJSON.DateOfClosure
				,InputJSON.CreatedBy
				);

	exec [insert-dss-digitalidentities-history] @Json
END