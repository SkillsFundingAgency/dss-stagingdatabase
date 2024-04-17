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

CREATE NONCLUSTERED INDEX [nci_dss-outcomes_customerid] ON [dbo].[dss-outcomes] ([CustomerId]) WITH (ONLINE = ON)

GO
