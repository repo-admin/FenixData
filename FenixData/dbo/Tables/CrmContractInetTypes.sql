CREATE TABLE [dbo].[CrmContractInetTypes] (
    [Id]                  INT            IDENTITY (1, 1) NOT NULL,
    [f_inet_core_number]  INT            NOT NULL,
    [f_inet_core_product] NVARCHAR (255) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85)
);

