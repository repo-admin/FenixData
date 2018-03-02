CREATE TABLE [dbo].[CrmContractOrderTypes] (
    [Id]                INT           IDENTITY (1, 1) NOT NULL,
    [zl_typ_objednavky] NVARCHAR (40) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85)
);

