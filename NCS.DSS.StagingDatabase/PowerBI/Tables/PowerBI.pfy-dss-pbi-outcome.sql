CREATE TABLE [PowerBI].[pfy-dss-pbi-outcome](
	[TouchpointID] [varchar](4) NOT NULL,
	[PriorityOrNot] [varchar](2) NOT NULL,
	[OutcomeTypeValue] [int] NOT NULL,
	[OutcomeTypeGroup] [varchar](4) NOT NULL,
	[PeriodMonth] [int] NOT NULL,
	[PeriodYear] [varchar](9) NOT NULL,
	[OutcomeNumber] [decimal](11, 2) NULL,
 CONSTRAINT [pk-pfy-dss-pbi-outcome] PRIMARY KEY CLUSTERED 
(
	[TouchpointID] ASC,
	[PeriodYear] ASC,
	[PeriodMonth] ASC,
	[PriorityOrNot] ASC,
	[OutcomeTypeGroup] ASC,
	[OutcomeTypeValue] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
