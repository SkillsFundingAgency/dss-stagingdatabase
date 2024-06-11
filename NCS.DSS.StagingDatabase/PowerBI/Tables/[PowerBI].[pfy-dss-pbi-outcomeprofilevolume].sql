CREATE TABLE [PowerBI].[pfy-dss-pbi-outcomeprofilevolume](
[TouchpointID] varchar(4)
        ,[ProfileCategory] varchar(10)
        ,[PriorityOrNot] varchar(2)
        ,[PeriodMonth] int not null
		,[date] datetime2(7)
        ,[PeriodYear] varchar(9)
        ,[OutcomeNumber] decimal(10,2)
        ,[YTD_OutcomeNumber] decimal(10,2)
) ON [PRIMARY]
GO


