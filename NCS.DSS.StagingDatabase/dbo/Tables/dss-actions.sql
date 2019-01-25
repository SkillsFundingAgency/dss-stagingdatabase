CREATE TABLE [dbo].[dss-actions] (
    [id]                            UNIQUEIDENTIFIER NULL,
    [CustomerId]                    UNIQUEIDENTIFIER NULL,
    [ActionPlanId]                  UNIQUEIDENTIFIER NULL,
    [DateActionAgreed]              DATETIME         NULL,
    [DateActionAimsToBeCompletedBy] DATETIME         NULL,
    [DateActionActuallyCompleted]   DATETIME         NULL,
    [ActionSummary]                 VARCHAR (max)     NULL,
    [SignpostedTo]                  VARCHAR (max)     NULL,
    [ActionType]                    INT              NULL,
    [ActionStatus]                  INT              NULL,
    [PersonResponsible]             INT              NULL,
    [LastModifiedDate]              VARCHAR (max)     NULL,
    [LastModifiedTouchpointId]      VARCHAR (max)     NULL
);

