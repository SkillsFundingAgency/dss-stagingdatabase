CREATE PROCEDURE [dbo].[Change_Feed_Insert_Update_dss-addresses](@Json NVARCHAR(MAX))
AS BEGIN
MERGE INTO [dss-addresses] AS addresses
USING (
    SELECT *
    FROM  OPENJSON(@Json)
          WITH (Id uniqueidentifier, CustomerId uniqueidentifier, SubcontractorId Varchar(Max), Address1 Varchar(Max), Address2 varchar(max),
                Address3 Varchar(Max), Address4 Varchar(Max), Address5 Varchar(Max), PostCode Varchar(Max), AlternativePostCode Varchar(Max),
				Longitude float, Latitude float,  EffectiveFrom datetime2, EffectiveTo datetime2, LastModifiedDate datetime2, LastModifiedTouchpointId varchar(max))) as InputJSON
   ON (addresses.id = InputJSON.Id)
WHEN MATCHED THEN
    UPDATE SET addresses.CustomerId = InputJSON.CustomerId,
               addresses.SubcontractorId = InputJSON.SubcontractorId,
			   addresses.Address1 = InputJSON.Address1,
			   addresses.Address2 = InputJSON.Address2,
			   addresses.Address3 = InputJSON.Address3,
			   addresses.Address4 = InputJSON.Address4,
			   addresses.Address5 = InputJSON.Address5,
			   addresses.PostCode = InputJSON.PostCode,
			   addresses.AlternativePostCode = InputJSON.AlternativePostCode,
			   addresses.Longitude = InputJSON.Longitude,
			   addresses.Latitude = InputJSON.Latitude,
			   addresses.EffectiveFrom = InputJSON.EffectiveFrom,
			   addresses.EffectiveTo = InputJSON.EffectiveTo,
			   addresses.LastModifiedDate = InputJSON.LastModifiedDate,
			   addresses.LastModifiedTouchpointId = InputJSON.LastModifiedTouchpointId               
WHEN NOT MATCHED THEN
    INSERT (Id, CustomerId, SubcontractorId, Address1, Address2, Address3, Address4, Address5, PostCode, 
	AlternativePostCode, Longitude, Latitude, EffectiveFrom, EffectiveTo, LastModifiedDate, LastModifiedTouchpointId)
    VALUES (InputJSON.Id, InputJSON.CustomerId, InputJSON.SubcontractorId, InputJSON.Address1, InputJSON.Address2, InputJSON.Address3, 
	InputJSON.Address4, InputJSON.Address5, InputJSON.PostCode, InputJSON.AlternativePostCode, 
	InputJSON.Longitude, InputJSON.Latitude, InputJSON.EffectiveFrom, InputJSON.EffectiveTo, InputJSON.LastModifiedDate, InputJSON.LastModifiedTouchpointId);
END
