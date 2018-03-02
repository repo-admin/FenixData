CREATE TABLE [dbo].[cdlItems] (
    [ID]             INT            NOT NULL,
    [GroupGoods]     NVARCHAR (3)   NOT NULL,
    [Code]           VARCHAR (50)   NOT NULL,
    [DescriptionCz]  NVARCHAR (100) NOT NULL,
    [DescriptionEng] NVARCHAR (100) NOT NULL,
    [MeasuresId]     INT            NOT NULL,
    [ItemTypesId]    INT            NOT NULL,
    [PackagingId]    INT            NULL,
    [GroupsId]       INT            NULL,
    [ItemType]       NCHAR (10)     NOT NULL,
    [PC]             NCHAR (10)     NOT NULL,
    [Packaging]      NCHAR (10)     NULL,
    [IsSent]         BIT            CONSTRAINT [DF_cdlItems_SentToND] DEFAULT ((0)) NOT NULL,
    [SentDate]       DATETIME       NULL,
    [ItemTypeDesc1]  NVARCHAR (35)  NOT NULL,
    [ItemTypeDesc2]  NVARCHAR (35)  NOT NULL,
    [IsActive]       BIT            CONSTRAINT [DF_cdlItems_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]     DATETIME       CONSTRAINT [DF_cdlItems_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]   INT            CONSTRAINT [DF_cdlItems_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Items] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20140910-141743]
    ON [dbo].[cdlItems]([GroupGoods] ASC, [Code] ASC) WITH (FILLFACTOR = 85);


GO
GRANT SELECT
    ON OBJECT::[dbo].[cdlItems] TO [VydejkySprRWD]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[cdlItems] TO [mis]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Skupina zboží - spolu s kodem zbozi je jednoznacny klic', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlItems', @level2type = N'COLUMN', @level2name = N'GroupGoods';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'kód stejný pro všechny jazyky, tento kód je stejný ve fenixu i v Heliosu; je to číselník zboží (zařízení)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlItems', @level2type = N'COLUMN', @level2name = N'Code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Popis česky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlItems', @level2type = N'COLUMN', @level2name = N'DescriptionCz';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Popis anglicky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlItems', @level2type = N'COLUMN', @level2name = N'DescriptionEng';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Odkaz na číselník měrných jednotek (ještě není)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlItems', @level2type = N'COLUMN', @level2name = N'MeasuresId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Odkaz na číselník cdlItemTypes', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlItems', @level2type = N'COLUMN', @level2name = N'ItemTypesId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'vazba na tabulku cdlPackages', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlItems', @level2type = N'COLUMN', @level2name = N'PackagingId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'pro incrementální aktualizaci naexterní firmě (např. ND) - 0...nebylo zasláno, 1... bylo zasláno', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlItems', @level2type = N'COLUMN', @level2name = N'IsSent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'datum, kdy byla provedena aktualizace číselníku na externí firmě (např. ND)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlItems', @level2type = N'COLUMN', @level2name = N'SentDate';

