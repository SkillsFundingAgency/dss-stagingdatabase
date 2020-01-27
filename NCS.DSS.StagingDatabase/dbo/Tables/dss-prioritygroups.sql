CREATE TABLE [dbo].[dss-prioritygroups] (
    [CustomerId]                     UNIQUEIDENTIFIER NOT NULL,
    [PriorityGroup]                 INT              NOT NULL,
    PRIMARY KEY ([CustomerId], [PriorityGroup]) 
);