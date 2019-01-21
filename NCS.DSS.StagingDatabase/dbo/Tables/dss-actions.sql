CREATE TABLE [dbo].[dss-actions] (
    [id]                            UNIQUEIDENTIFIER NULL,
    [CustomerId]                    UNIQUEIDENTIFIER NULL,
    [ActionPlanId]                  UNIQUEIDENTIFIER NULL,
    [DateActionAgreed]              DATETIME         NULL,
    [DateActionAimsToBeCompletedBy] DATETIME         NULL,
    [DateActionActuallyCompleted]   DATETIME         NULL,
    [ActionSummary]                 VARCHAR (50)     NULL,
    [SignpostedTo]                  VARCHAR (50)     NULL,
    [ActionType]                    INT              NULL,
    [ActionStatus]                  INT              NULL,
    [PersonResponsible]             INT              NULL,
    [LastModifiedDate]              VARCHAR (50)     NULL,
    [LastModifiedTouchpointId]      VARCHAR (10)     NULL
);

