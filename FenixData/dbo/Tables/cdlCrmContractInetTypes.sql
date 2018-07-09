CREATE TABLE [dbo].[cdlCrmContractInetTypes] (
    [Id]                  INT            IDENTITY (1, 1) NOT NULL,
    [f_inet_core_number]  INT            NOT NULL,
    [f_inet_core_product] NVARCHAR (255) NOT NULL,
    [IsActive]            BIT            DEFAULT ((1)) NOT NULL,
    [ModifyDate]          DATETIME       DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]        INT            DEFAULT ((0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85)
);

