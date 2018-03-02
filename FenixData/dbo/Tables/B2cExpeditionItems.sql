CREATE TABLE [dbo].[B2cExpeditionItems] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [ExpeditionId] INT           NULL,
    [ShipReal]     NVARCHAR (50) NULL,
    [ParcelNr]     NVARCHAR (50) NULL,
    [ParcelWeight] NVARCHAR (50) NULL,
    [SN1]          NVARCHAR (50) NULL,
    [SN2]          NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([ExpeditionId]) REFERENCES [dbo].[B2cExpedition] ([Id])
);

