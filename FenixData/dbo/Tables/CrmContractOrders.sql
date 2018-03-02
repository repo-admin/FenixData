CREATE TABLE [dbo].[CrmContractOrders] (
    [Id]                  INT            IDENTITY (1, 1) NOT NULL,
    [HistoryMappingId]    INT            NOT NULL,
    [zl_cislo_objednavky] NVARCHAR (20)  NOT NULL,
    [zl_zadano]           DATE           NOT NULL,
    [zl_cas_prislibu_od]  DATE           NOT NULL,
    [zl_cas_prislibu_do]  DATE           NOT NULL,
    [OrderTypeId]         INT            NOT NULL,
    [zl_cpe_back]         NVARCHAR (255) NULL,
    [zl_instrukce]        NVARCHAR (150) NULL,
    [ProductTypeId]       INT            NOT NULL,
    [f_pronajem]          NVARCHAR (255) NULL,
    [f_prodej]            NVARCHAR (255) NULL,
    [InetTypeId]          INT            NULL,
    [Created]             DATETIME       DEFAULT (getdate()) NOT NULL,
    [CreatedBy]           INT            NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([HistoryMappingId]) REFERENCES [dbo].[CrmContractHistoryMappings] ([Id]),
    FOREIGN KEY ([InetTypeId]) REFERENCES [dbo].[CrmContractInetTypes] ([Id]),
    FOREIGN KEY ([OrderTypeId]) REFERENCES [dbo].[CrmContractOrderTypes] ([Id]),
    FOREIGN KEY ([ProductTypeId]) REFERENCES [dbo].[CrmContractProductTypes] ([Id]),
    UNIQUE NONCLUSTERED ([zl_cislo_objednavky] ASC) WITH (FILLFACTOR = 85)
);

