CREATE TABLE [dbo].[dss-prioritygroups] (
    [CustomerId]                     UNIQUEIDENTIFIER NOT NULL,
    [PriorityGroup]                  INT              NOT NULL, 
    CONSTRAINT [PK_dss-prioritygroups] PRIMARY KEY ([PriorityGroup], [CustomerId])
);

GO

CREATE NONCLUSTERED INDEX [dss-prioritygroups_customerid] ON [dbo].[dss-prioritygroups] ([CustomerId]) WITH (ONLINE = ON)

GO