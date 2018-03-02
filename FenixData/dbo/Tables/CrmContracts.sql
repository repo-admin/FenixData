CREATE TABLE [dbo].[CrmContracts] (
    [Id]                  INT            IDENTITY (1, 1) NOT NULL,
    [zl_cislo_smlouvy]    INT            NOT NULL,
    [zl_jmeno_a_prijmeni] NVARCHAR (100) NOT NULL,
    [Created]             DATETIME       DEFAULT (getdate()) NOT NULL,
    [CreatedBy]           INT            NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85),
    UNIQUE NONCLUSTERED ([zl_cislo_smlouvy] ASC) WITH (FILLFACTOR = 85)
);

