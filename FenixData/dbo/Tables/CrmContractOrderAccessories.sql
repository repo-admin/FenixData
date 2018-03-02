CREATE TABLE [dbo].[CrmContractOrderAccessories] (
    [Id]                  INT            IDENTITY (1, 1) NOT NULL,
    [OrderId]             INT            NOT NULL,
    [nazev_prislusenstvi] NVARCHAR (255) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([OrderId]) REFERENCES [dbo].[CrmContractOrders] ([Id])
);

