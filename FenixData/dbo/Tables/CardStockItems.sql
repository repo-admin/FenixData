CREATE TABLE [dbo].[CardStockItems] (
    [ID]                             INT             IDENTITY (1, 1) NOT NULL,
    [ItemVerKit]                     BIT             NOT NULL,
    [ItemOrKitID]                    INT             NOT NULL,
    [ItemOrKitUnitOfMeasureId]       INT             NOT NULL,
    [ItemOrKitQuantity]              AS              ((([ItemOrKitFree]+[ItemOrKitUnConsilliation])+[ItemOrKitReserved])+[ItemOrKitReleasedForExpedition]),
    [ItemOrKitQuality]               INT             NULL,
    [ItemOrKitFree]                  NUMERIC (18, 3) CONSTRAINT [DF_CardStockItems_ItemOrKitFree] DEFAULT ((0)) NOT NULL,
    [ItemOrKitUnConsilliation]       NUMERIC (18, 3) CONSTRAINT [DF_CardStockItems_ItemOrKitUnConsilliation] DEFAULT ((0)) NOT NULL,
    [ItemOrKitReserved]              NUMERIC (18, 3) CONSTRAINT [DF_CardStockItems_ItemOrKitBlockedQuantity] DEFAULT ((0)) NOT NULL,
    [ItemOrKitReleasedForExpedition] NUMERIC (18, 3) CONSTRAINT [DF_CardStockItems_ItemOrKitReleasedForExpedition] DEFAULT ((0)) NOT NULL,
    [ItemOrKitExpedited]             NUMERIC (18, 3) CONSTRAINT [DF_CardStockItems_ItemOrKitExpedited] DEFAULT ((0)) NULL,
    [StockId]                        INT             NOT NULL,
    [IsActive]                       BIT             CONSTRAINT [DF_CardStockItems_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]                     DATETIME        CONSTRAINT [DF_CardStockItems_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]                   INT             CONSTRAINT [DF_CardStockItems_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CardStockItems] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20140819-091703]
    ON [dbo].[CardStockItems]([ItemVerKit] ASC, [ItemOrKitID] ASC, [ItemOrKitQuality] ASC, [StockId] ASC, [IsActive] ASC) WITH (FILLFACTOR = 85);


GO

CREATE TRIGGER trCardStockItemsUpd
   ON  [dbo].[CardStockItems]
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2014-10-03
-- Description:	
-- =============================================

	SET NOCOUNT ON;
INSERT INTO [dbo].[A_CardStockItems]
           ([ID]
           ,[ItemVerKit]
           ,[ItemOrKitId]
           ,[ItemOrKitUnitOfMeasureId]
           ,[ItemOrKitQuantity]
           ,[ItemOrKitQuality]
           ,[ItemOrKitFree]
           ,[ItemOrKitUnConsilliation]
           ,[ItemOrKitReserved]
           ,[ItemOrKitReleasedForExpedition]
           ,[ItemOrKitExpedited]
           ,[StockId]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
           )
SELECT [ID]
           ,[ItemVerKit]
           ,[ItemOrKitId]
           ,[ItemOrKitUnitOfMeasureId]
           ,[ItemOrKitQuantity]
           ,[ItemOrKitQuality]
           ,[ItemOrKitFree]
           ,[ItemOrKitUnConsilliation]
           ,[ItemOrKitReserved]
           ,[ItemOrKitReleasedForExpedition]
           ,[ItemOrKitExpedited]
           ,[StockId]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
FROM DELETED

END

GO
GRANT SELECT
    ON OBJECT::[dbo].[CardStockItems] TO [VydejkySprRWD]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[CardStockItems] TO [mis]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0... Item,    1 ...Kit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CardStockItems', @level2type = N'COLUMN', @level2name = N'ItemVerKit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'buď ID z tabulky cdlItems nebo cdlKits', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CardStockItems', @level2type = N'COLUMN', @level2name = N'ItemOrKitID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID z tabulky cdlMeasures', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CardStockItems', @level2type = N'COLUMN', @level2name = N'ItemOrKitUnitOfMeasureId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'množství ma skladě (skladové kartě) - celkové - obsahuje volné + blokované + neschválené + expedované', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CardStockItems', @level2type = N'COLUMN', @level2name = N'ItemOrKitQuantity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Nový, repasovaný,...(někdy není detail => kvalita musí být uvedena i zde)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CardStockItems', @level2type = N'COLUMN', @level2name = N'ItemOrKitQuality';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'množství volné', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CardStockItems', @level2type = N'COLUMN', @level2name = N'ItemOrKitFree';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'množství neodsouhlasené', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CardStockItems', @level2type = N'COLUMN', @level2name = N'ItemOrKitUnConsilliation';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'blokované množství z celkového množství na skladě pro sestavení kitů', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CardStockItems', @level2type = N'COLUMN', @level2name = N'ItemOrKitReserved';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'množství, uvolněné k expedici', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CardStockItems', @level2type = N'COLUMN', @level2name = N'ItemOrKitReleasedForExpedition';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'sklad=uloziste - viz cdlStocks', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CardStockItems', @level2type = N'COLUMN', @level2name = N'StockId';

