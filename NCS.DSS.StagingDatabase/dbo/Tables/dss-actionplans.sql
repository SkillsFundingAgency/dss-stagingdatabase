CREATE TABLE [dbo].[dss-actionplans] (
    [id]                             UNIQUEIDENTIFIER NULL,
    [CustomerId]                     UNIQUEIDENTIFIER NULL,
    [InteractionId]                  UNIQUEIDENTIFIER NULL,
    [DateActionPlanCreated]          DATETIME         NULL,
    [CustomerCharterShownToCustomer] BIT              NULL,
    [DateAndTimeCharterShown]        DATETIME2 (7)    NULL,
    [DateActionPlanSentToCustomer]   DATETIME         NULL,
    [ActionPlanDeliveryMethod]       INT              NULL,
    [DateActionPlanAcknowledged]     DATETIME         NULL,
    [PriorityCustomer]               INT              NULL,
    [CurrentSituation]               VARCHAR (50)     NULL,
    [LastModifiedDate]               DATETIME         NULL,
    [LastModifiedTouchpointId]       VARCHAR (10)     NULL
);

