IF OBJECT_ID('[fnDssDate]') IS NOT NULL 
		BEGIN
			DROP FUNCTION [fnDssDate]
		END

IF OBJECT_ID('[fnGetFiscalYearForDate]') IS NOT NULL 
		BEGIN
			DROP FUNCTION [fnGetFiscalYearForDate]
		END

IF OBJECT_ID('[fnGetParameterValueAsDate]') IS NOT NULL 
		BEGIN
			DROP FUNCTION [fnGetParameterValueAsDate]
		END

IF OBJECT_ID('[fnGetParameterValueAsInteger]') IS NOT NULL 
		BEGIN
			DROP FUNCTION [fnGetParameterValueAsInteger]
		END

IF OBJECT_ID('[fnPriorityCustomer]') IS NOT NULL 
		BEGIN
			DROP FUNCTION [fnPriorityCustomer]
		END

IF OBJECT_ID('[fnYearsOld]') IS NOT NULL 
		BEGIN
			DROP FUNCTION [fnYearsOld]
		END

IF OBJECT_ID('[GetCustomerSatisfactionOutcomes]') IS NOT NULL 
		BEGIN
			DROP FUNCTION [GetCustomerSatisfactionOutcomes]
		END

IF OBJECT_ID('[GetCustomerClaimableOutcomes]') IS NOT NULL 
		BEGIN
			DROP FUNCTION [GetCustomerClaimableOutcomes]
		END

IF OBJECT_ID('[Change_Feed_Upsert_actions]') IS NOT NULL 
		BEGIN
			DROP PROCEDURE [Change_Feed_Upsert_actions]
		END

IF OBJECT_ID('[Change_Feed_Upsert_Customer]') IS NOT NULL 
		BEGIN
			DROP PROCEDURE [Change_Feed_Upsert_Customer]
		END

IF OBJECT_ID('[Change_Feed_Upsert_Outcome]') IS NOT NULL 
		BEGIN
			DROP PROCEDURE [Change_Feed_Upsert_Outcome]
		END

IF OBJECT_ID('[Change_Feed_Upsert_Session]') IS NOT NULL 
		BEGIN
			DROP PROCEDURE [Change_Feed_Upsert_Session]
		END

IF OBJECT_ID('[CreateDataCollectionsParameterData]') IS NOT NULL 
		BEGIN
			DROP PROCEDURE [CreateDataCollectionsParameterData]
		END