CREATE TABLE [PowerBI].[dss-pbi-outcomedim]
(
	[OutcomeID] [int] NOT NULL,
	[OutcomeShortName] [varchar](4) NOT NULL,
	[OutcomeFullName] [varchar](40) NOT NULL,
	[PayableItemFlag] [bit] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[OutcomeColour] [varchar](7) NOT NULL,
	CONSTRAINT [pk-dss-pbi-outcomedim] PRIMARY KEY CLUSTERED ([OutcomeID])
) 
GO