CREATE TABLE [dbo].[InternalDocuments] (
    [ID]                                   INT             IDENTITY (1, 1) NOT NULL,
    [ItemVerKit]                           BIT             NOT NULL,
    [ItemOrKitID]                          INT             NOT NULL,
    [ItemOrKitUnitOfMeasureId]             INT             NOT NULL,
    [ItemOrKitQualityId]                   INT             NULL,
    [ItemOrKitQuantityBefore]              AS              ((([ItemOrKitFreeBefore]+[ItemOrKitUnConsilliationBefore])+[ItemOrKitReservedBefore])+[ItemOrKitReleasedForExpeditionBefore]),
    [ItemOrKitQuantityAfter]               AS              ((([ItemOrKitFreeAfter]+[ItemOrKitUnConsilliationAfter])+[ItemOrKitReservedAfter])+[ItemOrKitReleasedForExpeditionAfter]),
    [ItemOrKitFreeBefore]                  NUMERIC (18, 3) CONSTRAINT [DF_InternalDocuments_ItemOrKitFreeBefore] DEFAULT ((0)) NOT NULL,
    [ItemOrKitFreeAfter]                   NUMERIC (18, 3) CONSTRAINT [DF_InternalDocuments_ItemOrKitAfter] DEFAULT ((0)) NOT NULL,
    [ItemOrKitUnConsilliationBefore]       NUMERIC (18, 3) CONSTRAINT [DF_InternalDocuments_ItemOrKitUnConsilliationBefore] DEFAULT ((0)) NOT NULL,
    [ItemOrKitUnConsilliationAfter]        NUMERIC (18, 3) CONSTRAINT [DF_InternalDocuments_ItemOrKitUnConsilliationAfter] DEFAULT ((0)) NOT NULL,
    [ItemOrKitReservedBefore]              NUMERIC (18, 3) CONSTRAINT [DF_InternalDocuments_ItemOrKitBlockedQuantity] DEFAULT ((0)) NOT NULL,
    [ItemOrKitReservedAfter]               NUMERIC (18, 3) CONSTRAINT [DF_InternalDocuments_ItemOrKitBlockedAfter] DEFAULT ((0)) NOT NULL,
    [ItemOrKitReleasedForExpeditionBefore] NUMERIC (18, 3) CONSTRAINT [DF_InternalDocuments_ItemOrKitReleasedForExpeditionBefore] DEFAULT ((0)) NOT NULL,
    [ItemOrKitReleasedForExpeditionAfter]  NUMERIC (18, 3) CONSTRAINT [DF_InternalDocuments_ItemOrKitReleasedForExpeditionAfter] DEFAULT ((0)) NOT NULL,
    [ItemOrKitExpeditedBefore]             NUMERIC (18, 3) CONSTRAINT [DF_InternalDocuments_ItemOrKitExpeditedBefore] DEFAULT ((0)) NULL,
    [ItemOrKitExpeditedAfter]              NUMERIC (18, 3) CONSTRAINT [DF_InternalDocuments_ItemOrKitExpeditedAfter] DEFAULT ((0)) NULL,
    [StockId]                              INT             NOT NULL,
    [InternalDocumentsSourceId]            INT             NOT NULL,
    [IsActive]                             BIT             CONSTRAINT [DF_InternalDocuments_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]                           DATETIME        CONSTRAINT [DF_InternalDocuments_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]                         INT             CONSTRAINT [DF_InternalDocuments_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_InternalDocuments] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0... Item,    1 ...Kit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalDocuments', @level2type = N'COLUMN', @level2name = N'ItemVerKit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'buď ID z tabulky cdlItems nebo cdlKits', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalDocuments', @level2type = N'COLUMN', @level2name = N'ItemOrKitID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID z tabulky cdlMeasures', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalDocuments', @level2type = N'COLUMN', @level2name = N'ItemOrKitUnitOfMeasureId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nový, repasovaný,...(někdy není detail => kvalita musí být uvedena i zde)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalDocuments', @level2type = N'COLUMN', @level2name = N'ItemOrKitQualityId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'množství ma skladě (skladové kartě) - celkové - obsahuje volné + blokované + neschválené + expedované  PŘED', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalDocuments', @level2type = N'COLUMN', @level2name = N'ItemOrKitQuantityBefore';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'množství ma skladě (skladové kartě) - celkové - obsahuje volné + blokované + neschválené + expedované  PO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalDocuments', @level2type = N'COLUMN', @level2name = N'ItemOrKitQuantityAfter';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'množství volné  PŘED', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalDocuments', @level2type = N'COLUMN', @level2name = N'ItemOrKitFreeBefore';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'množství volné  PO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalDocuments', @level2type = N'COLUMN', @level2name = N'ItemOrKitFreeAfter';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'množství neodsouhlasené  PŘED', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalDocuments', @level2type = N'COLUMN', @level2name = N'ItemOrKitUnConsilliationBefore';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'množství neodsouhlasené  PO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalDocuments', @level2type = N'COLUMN', @level2name = N'ItemOrKitUnConsilliationAfter';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'blokované množství z celkového množství na skladě pro sestavení kitů  PŘED', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalDocuments', @level2type = N'COLUMN', @level2name = N'ItemOrKitReservedBefore';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'blokované množství z celkového množství na skladě pro sestavení kitů  PO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalDocuments', @level2type = N'COLUMN', @level2name = N'ItemOrKitReservedAfter';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'množství, uvolněné k expedici  PŘED', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalDocuments', @level2type = N'COLUMN', @level2name = N'ItemOrKitReleasedForExpeditionBefore';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'množství, uvolněné k expedici  PO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalDocuments', @level2type = N'COLUMN', @level2name = N'ItemOrKitReleasedForExpeditionAfter';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'množství expedované  PŘED', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalDocuments', @level2type = N'COLUMN', @level2name = N'ItemOrKitExpeditedBefore';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'množství expedované  PO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalDocuments', @level2type = N'COLUMN', @level2name = N'ItemOrKitExpeditedAfter';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'sklad=uloziste - viz cdlStocks', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalDocuments', @level2type = N'COLUMN', @level2name = N'StockId';

