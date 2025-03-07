CREATE VIEW [PowerBI].[v-dss-outcomes-filtered]
AS
SELECT [id]
      ,[CustomerId]
      ,[ActionPlanId]
      ,[SessionId]
      ,[SubcontractorId]
      ,[OutcomeType]
      ,[OutcomeClaimedDate]
      ,[OutcomeEffectiveDate]
      ,[ClaimedPriorityGroup]
      ,[IsPriorityCustomer]
      ,[TouchpointId]
      ,[LastModifiedDate]
      ,[LastModifiedTouchpointId]
      ,[CreatedBy] FROM [dbo].[dss-outcomes]
    JOIN PowerBI.[dss-pbi-financialyear] AS FY ON (CAST(OutcomeEffectiveDate as Date) BETWEEN fy.StartDateTime AND fy.EndDateTime) AND (CAST(OutcomeClaimedDate as Date) BETWEEN fy.StartDateTime AND fy.EndDateTime)
    WHERE FY.CurrentYear = 1;

GO

CREATE NONCLUSTERED INDEX [nci_v-dss-outcomes-filtered_OutcomeType_OutcomeClaimedDate_OutcomeEffectiveDate]
ON [PowerBI].[v-dss-outcomes-filtered] ([OutcomeType],[OutcomeClaimedDate],[OutcomeEffectiveDate])
INCLUDE ([ActionPlanId], [id], [TouchpointID], [CustomerId], [IsPriorityCustomer], [ClaimedPriorityGroup], [LastModifiedDate])