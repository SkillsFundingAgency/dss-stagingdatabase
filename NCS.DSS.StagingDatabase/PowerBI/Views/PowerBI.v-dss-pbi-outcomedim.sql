CREATE VIEW [PowerBI].[v-dss-pbi-outcomedim] 
AS 
    SELECT 	
        [OutcomeID] AS 'Outcome ID'
        ,[OutcomeShortName] AS 'Outcome abbreviation'
        ,[OutcomeFullName] AS 'Outcome full name'
        ,[PayableItemFlag] AS 'Payable Item Flag'
        ,[SortOrder] AS 'SortOrder'
        ,[OutcomeColour] AS 'OutcomeColour' 
    FROM [PowerBI].[dss-pbi-outcomedim] 
;
GO