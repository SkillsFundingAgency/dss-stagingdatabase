CREATE TABLE [dbo].[dss-actionplans] (
    [id]                             UNIQUEIDENTIFIER NOT NULL,
    [CustomerId]                     UNIQUEIDENTIFIER NULL,
    [InteractionId]                  UNIQUEIDENTIFIER NULL,
	[SessionId]						 UNIQUEIDENTIFIER NULL,
	[SubcontractorId]				 VARCHAR(50) NULL,
    [DateActionPlanCreated]          datetime2         NULL,
    [CustomerCharterShownToCustomer] BIT              NULL,
    [DateAndTimeCharterShown]        DATETIME2 (7)    NULL,
    [DateActionPlanSentToCustomer]   datetime2         NULL,
    [ActionPlanDeliveryMethod]       INT              NULL,
    [DateActionPlanAcknowledged]     datetime2         NULL,
    [PriorityCustomer]               INT              NULL,
    [CurrentSituation]               VARCHAR (MAX)     NULL,
    [LastModifiedDate]               datetime2         NULL,
    [LastModifiedTouchpointId]       VARCHAR (MAX)     NULL, 
	[CreatedBy]					     VARCHAR (MAX)     NULL, 
    [CustomerSatisfaction]           INT               NULL, 
    CONSTRAINT [PK_dss-actionplans] PRIMARY KEY ([id]) 
);


GO

CREATE NONCLUSTERED INDEX [nci_dss-actionplans_customerid] ON [dbo].[dss-actionplans] ([CustomerId]) WITH (ONLINE = ON)

GO
