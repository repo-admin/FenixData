CREATE TABLE [dbo].[B2cKittingKits] (
    [Id]           INT IDENTITY (1, 1) NOT NULL,
    [B2cKittingId] INT NULL,
    [KitId]        INT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([B2cKittingId]) REFERENCES [dbo].[B2cKitting] ([Id]),
    FOREIGN KEY ([KitId]) REFERENCES [dbo].[cdlKits] ([ID])
);

