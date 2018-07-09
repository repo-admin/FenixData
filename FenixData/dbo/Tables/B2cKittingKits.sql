CREATE TABLE [dbo].[B2cKittingKits] (
    [Id]           INT IDENTITY (1, 1) NOT NULL,
    [B2cKittingId] INT NULL,
    [KitId]        INT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([B2cKittingId]) REFERENCES [dbo].[B2cKitting] ([Id]),
    FOREIGN KEY ([KitId]) REFERENCES [dbo].[cdlKits] ([ID])
);




GO
GRANT UPDATE
    ON OBJECT::[dbo].[B2cKittingKits] TO [FenixW]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[B2cKittingKits] TO [FenixW]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[B2cKittingKits] TO [CrmImport]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[B2cKittingKits] TO [FenixW]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[B2cKittingKits] TO [FenixW]
    AS [dbo];

