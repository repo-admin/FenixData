CREATE TABLE [dbo].[cdlKitsItems] (
    [ID]                INT             IDENTITY (1, 1) NOT NULL,
    [cdlKitsId]         INT             NOT NULL,
    [ItemVerKit]        BIT             CONSTRAINT [DF_cdlKitsItems_ItemVerKit] DEFAULT ((0)) NOT NULL,
    [ItemOrKitId]       INT             NOT NULL,
    [ItemGroupGoods]    NVARCHAR (3)    NULL,
    [ItemCode]          NVARCHAR (50)   NULL,
    [ItemOrKitQuantity] NUMERIC (18, 3) NOT NULL,
    [PackageType]       NCHAR (50)      NULL,
    [IsActive]          BIT             CONSTRAINT [DF_cdlKitsItems_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]        DATETIME        CONSTRAINT [DF_cdlKitsItems_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]      INT             CONSTRAINT [DF_cdlKitsItems_ModifyUserId] DEFAULT ((0)) NOT NULL,
    [IsSent]            BIT             CONSTRAINT [DF_cdlKitsItems_IsSent] DEFAULT ((0)) NOT NULL,
    [SentDate]          DATETIME        NULL,
    CONSTRAINT [PK_cdlKitsItems] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'číslo ID z tabulky cdlKits', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlKitsItems', @level2type = N'COLUMN', @level2name = N'cdlKitsId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0...Item, 1...Kit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlKitsItems', @level2type = N'COLUMN', @level2name = N'ItemVerKit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'kit se může skládat z kitů nebo itemů nebo kombinace obou', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlKitsItems', @level2type = N'COLUMN', @level2name = N'ItemOrKitId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'v případš Item  je tady jeho kód, v případě kitu je null', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlKitsItems', @level2type = N'COLUMN', @level2name = N'ItemCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'množství', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlKitsItems', @level2type = N'COLUMN', @level2name = N'ItemOrKitQuantity';

