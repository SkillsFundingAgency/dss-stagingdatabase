CREATE TABLE [dbo].[dss-prioritygroups-history] (
	[HistoryId] [int] IDENTITY(1,1) NOT NULL,
	[CosmosTimeStamp] [datetime2](7) NOT NULL,
    [CustomerId]                     UNIQUEIDENTIFIER NOT NULL,
    [PriorityGroup]                  INT              NOT NULL, 
	CONSTRAINT [PK_dss-prioritygroups-history] PRIMARY KEY CLUSTERED ([HistoryId] ,[CosmosTimeStamp])
)
GO

CREATE NONCLUSTERED INDEX [nci_dss-prioritygroups-history_customerid] ON [dbo].[dss-prioritygroups-history] ([CustomerId]) WITH (ONLINE = ON)

GO