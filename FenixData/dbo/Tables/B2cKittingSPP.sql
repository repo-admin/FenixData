CREATE TABLE [dbo].[B2cKittingSPP] (
    [Id]           INT IDENTITY (1, 1) NOT NULL,
    [B2cKittingId] INT NULL,
    [SppId]        INT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([B2cKittingId]) REFERENCES [dbo].[B2cKitting] ([Id])
);




GO
GRANT UPDATE
    ON OBJECT::[dbo].[B2cKittingSPP] TO [FenixW]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[B2cKittingSPP] TO [FenixW]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[B2cKittingSPP] TO [CrmImport]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[B2cKittingSPP] TO [FenixW]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[B2cKittingSPP] TO [FenixW]
    AS [dbo];

