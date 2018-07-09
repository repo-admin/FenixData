CREATE TABLE [dbo].[B2cKitting] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [f_typ_klienta] NVARCHAR (50) NULL,
    [f_inet_typ_pr] NVARCHAR (50) NULL,
    [f_inet_prodej] NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85)
);




GO
GRANT UPDATE
    ON OBJECT::[dbo].[B2cKitting] TO [FenixW]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[B2cKitting] TO [FenixW]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[B2cKitting] TO [CrmImport]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[B2cKitting] TO [FenixW]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[B2cKitting] TO [FenixW]
    AS [dbo];

