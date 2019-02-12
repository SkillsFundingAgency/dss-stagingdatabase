IF OBJECT_ID('[dbo].[dss-data-collections-parameters]') IS NOT NULL
BEGIN
	DROP TABLE [dbo].[dss-data-collections-parameters]
END
GO

CREATE TABLE [dbo].[dss-data-collections-parameters](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ParameterName] [nvarchar](50) NOT NULL,
	[ParameterValue] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

