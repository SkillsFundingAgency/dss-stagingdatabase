CREATE TABLE [dbo].[dss-prioritygroups] (
    [CustomerId]                     UNIQUEIDENTIFIER NOT NULL,
    [PriorityGroup]                  INT              NOT NULL, 
    CONSTRAINT [PK_dss-prioritygroups] PRIMARY KEY ([PriorityGroup], [CustomerId])
);

GO