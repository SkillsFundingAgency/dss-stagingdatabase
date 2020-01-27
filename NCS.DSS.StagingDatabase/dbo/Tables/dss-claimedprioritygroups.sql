CREATE TABLE [dbo].[dss-claimedprioritygroups] (
    [CustomerId]                     UNIQUEIDENTIFIER NOT NULL,
    [PriorityCustomer]               INT              NOT NULL,
    PRIMARY KEY ([CustomerId], [PriorityCustomer]) 
);