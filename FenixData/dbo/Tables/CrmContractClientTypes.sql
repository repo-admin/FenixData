CREATE TABLE [dbo].[CrmContractClientTypes] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [f_typ_klienta] NVARCHAR (30) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85)
);

