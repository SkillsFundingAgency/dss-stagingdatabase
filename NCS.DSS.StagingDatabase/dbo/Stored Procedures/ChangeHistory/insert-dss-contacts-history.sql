CREATE PROCEDURE [dbo].[insert-dss-contacts-history] (@Json NVARCHAR(MAX))
AS
BEGIN
	INSERT INTO [dss-contacts-history]
	SELECT DATEADD(MINUTE, _ts/60, DATEADD(SECOND, _ts%60, '19700101')) as CosmosTimeStamp, id, CustomerId, PreferredContactMethod, MobileNumber, HomeNumber, AlternativeNumber,
		   EmailAddress, LastModifiedDate, LastModifiedTouchpointId
		FROM OPENJSON(@Json)
		WITH (
		        _ts BIGINT
				,id UNIQUEIDENTIFIER
				,CustomerId uniqueidentifier
				,PreferredContactMethod int
				,MobileNumber varchar(MAX)
				,HomeNumber varchar(MAX)
				,AlternativeNumber varchar (MAX)
				,EmailAddress varchar(MAX)
				,LastModifiedDate DATETIME2
				,LastModifiedTouchpointId VARCHAR(MAX)
				)
END