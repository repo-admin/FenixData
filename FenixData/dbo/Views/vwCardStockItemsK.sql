




/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[vwCardStockItemsK]
AS
/*
20140826  7:56
20140917  9:56
*/
SELECT CSI.[ID]
      ,CSI.[ItemVerKit]
      ,CASE CSI.[ItemVerKit]
          WHEN 0 THEN 'Mater/zb'
          WHEN 1 THEN 'Kit'
          ELSE '???'
       END ItemVerKitDescription
      ,CSI.[ItemOrKitID]
      ,CSI.[ItemOrKitUnitOfMeasureId]
      ,CSI.[ItemOrKitQuantity]
      ,CSI.[ItemOrKitQuality]
      ,CSI.[ItemOrKitFree]
      ,CSI.[ItemOrKitUnConsilliation]
      ,CSI.[ItemOrKitReserved]
      ,CSI.[ItemOrKitReleasedForExpedition]
      ,CSI.[ItemOrKitExpedited]
      ,CAST(CSI.[ItemOrKitQuantity]  AS int)                ItemOrKitQuantityInt
      ,CAST(CSI.[ItemOrKitQuality]  AS int)                 ItemOrKitQualityInt
      ,CAST(CSI.[ItemOrKitFree]  AS int)                    ItemOrKitFreeInt
      ,CAST(CSI.[ItemOrKitUnConsilliation] AS int)          ItemOrKitUnConsilliationInt
      ,CAST(CSI.[ItemOrKitReserved]  AS int)                ItemOrKitReservedInt
      ,CAST(CSI.[ItemOrKitReleasedForExpedition] AS int)    ItemOrKitReleasedForExpeditionInt
      ,CAST(CSI.[ItemOrKitExpedited]  AS int)               ItemOrKitExpeditedInt
      ,CSI.[StockId]
      ,CSI.[IsActive]
      ,CSI.[ModifyDate]
      ,CSI.[ModifyUserId],
       cI.[ID]          AS cdlItemsId
      ,cI.[Code]
      ,cI.[DescriptionCz]
      ,cI.[DescriptionEng]
      ,cI.[MeasuresId]
      ,cI.[MeasuresCode]
      ,cI.[KitQualitiesId]
      ,cI.[KitQualitiesCode]
      ,cI.[IsSent]
      ,cI.[SentDate]
      ,cI.[IsActive]     AS cdlItemsIsActive
      ,cI.[ModifyDate]   AS cdlItemsModifyDate
      ,cI.[ModifyUserId] AS cdlItemsModifyUserId
      ,cS.[ID]           AS cdlStocksID
      ,cS.[DestPlacesID]
      ,cS.[Name]         AS cdlStocksName
      ,cS.[HeliosID]
      ,cS.[IsSent]       AS cdlStocksIsSent
      ,cS.[SentDate]     AS cdlStocksSentDate
      ,cS.[IsActive]     AS cdlStocksIsActive
      ,cS.[ModifyDate]   AS cdlStocksModifyDate
      ,cS.[ModifyUserId] AS cdlStocksModifyUserId
  FROM [dbo].[CardStockItems]   CSI
  INNER JOIN [dbo].[cdlKits]   cI
      ON CSI.[ItemOrKitID] = cI.ID
  INNER JOIN [dbo].[cdlStocks]  cS
      ON CSI.[StockId] = cS.ID
  --WHERE CSI.[ItemVerKit]=0











