CREATE TABLE [dbo].[dss-actions] (
    [id]                            UNIQUEIDENTIFIER NOT NULL,
    [CustomerId]                    UNIQUEIDENTIFIER NULL,	
    [ActionPlanId]                  UNIQUEIDENTIFIER NULL,
	[SubcontractorId]				VARCHAR(50) NULL,
    [DateActionAgreed]              datetime2         NULL,
    [DateActionAimsToBeCompletedBy] datetime2         NULL,
    [DateActionActuallyCompleted]   datetime2         NULL,
    [ActionSummary]                 VARCHAR (max)     NULL,
    [SignpostedTo]                  VARCHAR (max)     NULL,
    [SignpostedToCategory]          INT               NULL,
    [ActionType]                    INT              NULL,
    [ActionStatus]                  INT              NULL,
    [PersonResponsible]             INT              NULL,
    [LastModifiedDate]              VARCHAR (max)     NULL,
    [LastModifiedTouchpointId]      VARCHAR (max)     NULL, 
	[CreatedBy]					    VARCHAR (max)     NULL, 
    CONSTRAINT [PK_dss-actions] PRIMARY KEY ([id])
);

GO

CREATE NONCLUSTERED INDEX [nci_dss-actions_customerid] ON [dbo].[dss-actions] ([CustomerId]) WITH (ONLINE = ON)
GO

CREATE NONCLUSTERED INDEX [nci_dss_actions_ReportingCoverage]ON [dbo].[dss-actions] 
(
    DateActionAgreed,
    SignpostedToCategory
)
INCLUDE (
    id,
    CustomerId,
    CreatedBy
);

GO

