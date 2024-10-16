CREATE PROCEDURE [PowerBI].[sp_dss_pbi_outcomeactualfact_PFY]
AS
BEGIN
    TRUNCATE TABLE [PowerBI].[pfy-dss-pbi-outcomeactualfact] ;
    INSERT INTO [PowerBI].[pfy-dss-pbi-outcomeactualfact] 
    SELECT [TouchpointID],
               [Outcome ID],
               [Group ID],
               OAC.[Date],
               [Outcome number],
               [YTD OutcomeNumber],
               [Outcome Finance],
               [YTD OutcomeFinance]
        FROM [PowerBI].[v-dss-pbi-outcomeactualfact-FY] AS OAC
        JOIN [PowerBI].[v-dss-pbi-date] AS PD ON PD.Date = OAC.Date
        WHERE PD.CurrentYear IS NULL and [TouchpointID] is not null

END;