CREATE TABLE [dbo].[CrmContractHistories] (
    [Id]                     INT            IDENTITY (1, 1) NOT NULL,
    [zl_ulice]               NVARCHAR (100) NOT NULL,
    [zl_cislo_pop_or]        NVARCHAR (20)  NOT NULL,
    [zl_patro_prip_bod]      NVARCHAR (50)  NOT NULL,
    [zl_obec]                NVARCHAR (100) NOT NULL,
    [zl_telefon_domu_zamest] NVARCHAR (50)  NULL,
    [zl_mobil]               NVARCHAR (20)  NULL,
    [zl_email_info1]         NVARCHAR (80)  NULL,
    [zl_email_info2]         NVARCHAR (50)  NULL,
    [zl_email]               NVARCHAR (100) NULL,
    [zl_heslo]               NVARCHAR (20)  NULL,
    [ClientTypeId]           INT            NOT NULL,
    [zl_line1]               NVARCHAR (15)  NULL,
    [zl_line2]               NVARCHAR (15)  NULL,
    [Created]                DATETIME       DEFAULT (getdate()) NOT NULL,
    [CreatedBy]              INT            NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([ClientTypeId]) REFERENCES [dbo].[CrmContractClientTypes] ([Id])
);

