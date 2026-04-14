CREATE TABLE PowerBI.OutcomeActualAgg (
    OutcomeID int NOT NULL,
    [Date] date NOT NULL,
    OutcomeNumber decimal(18,2),
    YTDOutcomeNumber decimal(18,2),
    OutcomeFinance decimal(18,2),
    YTDOutcomeFinance decimal(18,2),
    CONSTRAINT PK_OutcomeActualAgg PRIMARY KEY (OutcomeID, [Date])
);