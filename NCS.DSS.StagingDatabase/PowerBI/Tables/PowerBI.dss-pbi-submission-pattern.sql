CREATE TABLE [PowerBI].[dss-pbi-submission-pattern]
(
    [SubmissionPatternId] INT NOT NULL IDENTITY(1,1) PRIMARY KEY, -- Primary Key column
    [WeekName] VARCHAR(32) NOT NULL,
    [TouchpointID] INT NOT NULL,
    [Percentage] DECIMAL(18,5) NOT NULL
    -- Specify more columns here
);
GO