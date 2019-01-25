CREATE TABLE [dbo].[dss-goals] (
    [id]                          UNIQUEIDENTIFIER NULL,
    [CustomerId]                  UNIQUEIDENTIFIER NULL,
    [ActionPlanId]                UNIQUEIDENTIFIER NULL,
    [DateGoalCaptured]            datetime2         NULL,
    [DateGoalShouldBeCompletedBy] datetime2         NULL,
    [DateGoalAchieved]            datetime2         NULL,
    [GoalSummary]                 VARCHAR (max)     NULL,
    [GoalType]                    INT              NULL,
    [GoalStatus]                  INT              NULL,
    [LastModifiedDate]            datetime2         NULL,
    [LastModifiedTouchpointId]    VARCHAR (max)     NULL
);

