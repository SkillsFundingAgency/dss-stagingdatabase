CREATE TABLE PowerBI.OutcomeProfileAgg (
    OutcomeID int NOT NULL,
    [Date] date NOT NULL,
    ProfileTotal decimal(18,2),
    ProfileYTD decimal(18,2),
    FinancialProfileTotal decimal(18,2),
    FinancialProfileYTD decimal(18,2),
    CONSTRAINT PK_OutcomeProfileAgg PRIMARY KEY (OutcomeID, [Date])
);