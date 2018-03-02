



CREATE VIEW [dbo].[vwKitsItemCardStokItems]
AS
-- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-08-06
--                2014-11-10
-- Description  : 
-- ===============================================================================================

/* ===============================================================================================
   Používá se pro objednávky kompletace KITů


=============================================================================================== */
SELECT Kit.[ID]
      ,Kit.[cdlKitsId]
      ,Kit.[ItemVerKit]
      ,Kit.[ItemOrKitId]
      ,Kit.[ItemGroupGoods]
      ,Kit.[ItemCode]
      ,Kit.[ItemOrKitQuantity]
      ,Kit.[PackageType]
      ,Kit.[IsActive]
      ,Kit.[ModifyDate]
      ,Kit.[ModifyUserId]
      ,Kit.[IsSent]
      ,Kit.[SentDate]
      ,It.Code
      ,It.DescriptionCz
      ,CSI.StockId
      ,ISNULL(CSI.ItemOrKitFree,0)                     ItemOrKitFree
      ,ISNULL(CSI.ItemOrKitReserved,0)                 ItemOrKitReserved
      ,ISNULL(CSI.ItemOrKitUnConsilliation,0)          ItemOrKitUnConsilliation
      ,ISNULL(CSI.ItemOrKitReleasedForExpedition,0)    ItemOrKitReleasedForExpedition
      ,CSI.ItemOrKitQuality
      ,S.Name
  FROM [dbo].[cdlKitsItems]     Kit
  INNER JOIN [dbo].[cdlItems]   It
      ON Kit.[ItemOrKitId] = It.ID
  Left Outer JOIN [dbo].[CardStockItems] CSI
      ON It.ID=CSI.ItemOrKitId AND CSI.[ItemVerKit]=Kit.[ItemVerKit]
  INNER JOIN [dbo].[cdlStocks]  S
      ON CSI.StockId = S.Id
  WHERE Kit.[IsActive] = 1 AND It.IsActive = 1 AND CSI.IsActive = 1 AND S.IsActive = 1










