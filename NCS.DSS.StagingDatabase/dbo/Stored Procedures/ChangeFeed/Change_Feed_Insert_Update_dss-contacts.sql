CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-contacts] (@Json NVARCHAR(MAX))
AS
BEGIN
	MERGE INTO [dss-contacts] AS contacts
	USING (
		SELECT *
		FROM OPENJSON(@Json) WITH (
				id UNIQUEIDENTIFIER
				,CustomerId uniqueidentifier
				,PreferredContactMethod int
				,MobileNumber varchar(MAX)
				,HomeNumber varchar(MAX)
				,AlternativeNumber varchar (MAX)
				,EmailAddress varchar(MAX)
				,LastModifiedDate DATETIME2
				,LastModifiedTouchpointId VARCHAR(MAX)
				)
		) AS InputJSON
		ON (contacts.id = InputJSON.id)
	WHEN MATCHED
		THEN
			UPDATE
			SET contacts.id = InputJSON.id 
				,contacts.CustomerId = InputJSON.CustomerId
				,contacts.PreferredContactMethod = InputJSON.PreferredContactMethod
				,contacts.MobileNumber = InputJSON.MobileNumber
				,contacts.HomeNumber = InputJSON.HomeNumber
				,contacts.AlternativeNumber = InputJSON.AlternativeNumber
				,contacts.EmailAddress = InputJSON.EmailAddress
				,contacts.LastModifiedDate = InputJSON.LastModifiedDate
				,contacts.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId
	WHEN NOT MATCHED
		THEN
			INSERT (
				id
				,CustomerId
				,PreferredContactMethod
				,MobileNumber
				,HomeNumber
				,AlternativeNumber
				,EmailAddress
				,LastModifiedDate
				,LastModifiedTouchpointId
				)
			VALUES (
				InputJSON.id
				,InputJSON.CustomerId
				,InputJSON.PreferredContactMethod
				,InputJSON.MobileNumber
				,InputJSON.HomeNumber
				,InputJSON.AlternativeNumber
				,InputJSON.EmailAddress
				,InputJSON.LastModifiedDate
				,InputJSON.LastModifiedTouchpointId
				);

	exec [insert-dss-contacts-history] @Json
END