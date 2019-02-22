CREATE TABLE [dbo].[dss-actionplans] (
    [id]                             UNIQUEIDENTIFIER NULL,
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
    [LastModifiedTouchpointId]       VARCHAR (MAX)     NULL
);

