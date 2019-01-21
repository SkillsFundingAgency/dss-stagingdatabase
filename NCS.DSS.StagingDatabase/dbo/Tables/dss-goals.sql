CREATE TABLE [dbo].[dss-goals] (
    [id]                          UNIQUEIDENTIFIER NULL,
    [CustomerId]                  UNIQUEIDENTIFIER NULL,
    [ActionPlanId]                UNIQUEIDENTIFIER NULL,
    [DateGoalCaptured]            DATETIME         NULL,
    [DateGoalShouldBeCompletedBy] DATETIME         NULL,
    [DateGoalAchieved]            DATETIME         NULL,
    [GoalSummary]                 VARCHAR (50)     NULL,
    [GoalType]                    INT              NULL,
    [GoalStatus]                  INT              NULL,
    [LastModifiedDate]            DATETIME         NULL,
    [LastModifiedTouchpointId]    VARCHAR (10)     NULL
);

