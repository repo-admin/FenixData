CREATE TABLE [dbo].[CrmContractHistoryMappings] (
    [Id]                INT IDENTITY (1, 1) NOT NULL,
    [ContractId]        INT NOT NULL,
    [ContractHistoryId] INT NOT NULL,
    [IsRelevant]        BIT DEFAULT ((1)) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([ContractHistoryId]) REFERENCES [dbo].[CrmContractHistories] ([Id]),
    FOREIGN KEY ([ContractId]) REFERENCES [dbo].[CrmContracts] ([Id])
);

