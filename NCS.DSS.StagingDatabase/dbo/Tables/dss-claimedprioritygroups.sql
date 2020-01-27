CREATE TABLE [dbo].[dss-claimedprioritygroups] (
    [OutcomeId]                     UNIQUEIDENTIFIER NOT NULL,
    [PriorityCustomer]               INT              NOT NULL,
    PRIMARY KEY ([OutcomeId], [PriorityCustomer]) 
);