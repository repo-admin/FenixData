CREATE TABLE [dbo].[CrmContractProductTypes] (
    [Id]       INT           IDENTITY (1, 1) NOT NULL,
    [f_typ_pr] NVARCHAR (20) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85)
);

