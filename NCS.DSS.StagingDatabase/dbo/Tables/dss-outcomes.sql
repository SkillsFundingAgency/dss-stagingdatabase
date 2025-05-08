CREATE TABLE [dbo].[dss-outcomes] (
    [id]                       UNIQUEIDENTIFIER NOT NULL,
    [CustomerId]               UNIQUEIDENTIFIER NULL,
    [ActionPlanId]             UNIQUEIDENTIFIER NULL,
	[SessionId]                UNIQUEIDENTIFIER  NULL,
	[SubcontractorId]		   VARCHAR(50)		 NULL,	
    [OutcomeType]              INT               NULL,
    [OutcomeClaimedDate]       datetime2         NULL,
    [OutcomeEffectiveDate]     datetime2         NULL,
    [ClaimedPriorityGroup]     INT               NULL,
    [IsPriorityCustomer]       BIT               NULL,
    [TouchpointId]             VARCHAR (max)     NULL,
    [LastModifiedDate]         datetime2         NULL,
    [LastModifiedTouchpointId] VARCHAR (max)     NULL, 
	[CreatedBy]				   VARCHAR (MAX)     NULL, 
    CONSTRAINT [PK_dss-outcomes] PRIMARY KEY ([id])
);

GO

CREATE NONCLUSTERED INDEX [nci_dss-outcomes_customerid] 
ON [dbo].[dss-outcomes] ([CustomerId]) 
WITH (ONLINE = ON)

GO

CREATE NONCLUSTERED INDEX [nci_dss-outcomes_ActionPlanId] 
ON [dbo].[dss-outcomes]([ActionPlanId]) 
INCLUDE ([OutcomeEffectiveDate]) 
WITH (ONLINE = ON)

GO

CREATE PARTITION FUNCTION financialYearsPF (datetime2)
AS RANGE RIGHT FOR VALUES ('2022-04-01', '2023-04-01','2024-04-01','2025-04-01', '2026-04-01')

GO

CREATE PARTITION SCHEME financialYearsScheme 
AS PARTITION financialYearsPF ALL TO ([PRIMARY])

GO

CREATE NONCLUSTERED INDEX [nci_dss-outcomes_OutcomeType_OutcomeClaimedDate_OutcomeEffectiveDate]
ON [dbo].[dss-outcomes] ([OutcomeType],[OutcomeClaimedDate],[OutcomeEffectiveDate])
INCLUDE ([ActionPlanId], [id], [TouchpointID], [CustomerId], [IsPriorityCustomer], [ClaimedPriorityGroup], [LastModifiedDate])
WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON financialYearsScheme([OutcomeClaimedDate])

GO

