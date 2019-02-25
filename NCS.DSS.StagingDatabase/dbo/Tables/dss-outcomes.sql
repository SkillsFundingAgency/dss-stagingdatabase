CREATE TABLE [dbo].[dss-outcomes] (
    [id]                       UNIQUEIDENTIFIER NOT NULL,
    [CustomerId]               UNIQUEIDENTIFIER NULL,
    [ActionPlanId]             UNIQUEIDENTIFIER NULL,
	[SubcontractorId]		   VARCHAR(50)		 NULL,
    [OutcomeType]              INT               NULL,
    [OutcomeClaimedDate]       datetime2         NULL,
    [OutcomeEffectiveDate]     datetime2         NULL,
	[ClaimedPriorityGroup]     INT               NULL,
    [TouchpointId]             VARCHAR (max)     NULL,
    [LastModifiedDate]         datetime2         NULL,
    [LastModifiedTouchpointId] VARCHAR (max)     NULL, 
    CONSTRAINT [PK_dss-outcomes] PRIMARY KEY ([id])
);

