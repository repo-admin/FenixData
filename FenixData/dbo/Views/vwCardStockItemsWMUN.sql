CREATE VIEW [dbo].[vwCardStockItemsWMUN]
AS
/*
-- ==========================================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-07-14
-- Used by      : 
-- Description  : Karty skladu (bez jména uživatele, který kartu editoval)
-- Parameters   : 
-- History      :
-- ==========================================================================================================
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
      ,CAST(CSI.[ItemOrKitQuantity] AS INT) ItemOrKitQuantityInteger
      ,CSI.[ItemOrKitQuality]
      ,cQ.Code  AS QualitiesCode
      ,CSI.[ItemOrKitFree]
      ,CAST(CSI.[ItemOrKitFree] AS INT) ItemOrKitFreeInteger
      ,CSI.[ItemOrKitUnConsilliation]
      ,CAST(CSI.[ItemOrKitUnConsilliation] AS INT)  ItemOrKitUnConsilliationInteger
      ,CSI.[ItemOrKitReserved]
      ,CAST(CSI.[ItemOrKitReserved] AS INT)  ItemOrKitReservedInteger
      ,CSI.[ItemOrKitReleasedForExpedition]
      ,CAST(CSI.[ItemOrKitReleasedForExpedition] AS INT)  ItemOrKitReleasedForExpeditionInteger
      ,CSI.[ItemOrKitExpedited]
      ,CAST(CSI.[ItemOrKitExpedited] AS INT)  ItemOrKitExpeditedInteger
      ,CSI.[StockId]
      ,CSI.[IsActive]
      ,CSI.[ModifyDate]
      ,CSI.[ModifyUserId],
       cI.[ID]          AS cdlItemsId
      ,ISNULL(cI.[GroupGoods],'')  GroupGoods
      ,COALESCE(cI.[Code],'')  Code
      ,COALESCE(cI.[DescriptionCz],'') DescriptionCz
      ,cI.DescriptionEng
      ,COALESCE(cI.[MeasuresId],'') AS [MeasuresId]
      ,COALESCE(cM.Code,'')               AS MeasuresCode
      ,cI.[ItemTypesId]
      ,cI.[PackagingId]
      ,RTRIM(cI.[ItemType]) ItemType
      ,cI.[PC]
      ,cI.[Packaging]
      ,cI.[IsSent]
      ,cI.[SentDate]
      ,cI.[IsActive]     AS cdlItemsIsActive
      ,cI.[ModifyDate]   AS cdlItemsModifyDate
      ,cI.[ModifyUserId] AS cdlItemsModifyUserId
      ,cI.Packaging      AS cdlItemsPackaging
      ,cS.[ID]           AS cdlStocksID
      ,cS.[DestPlacesID]
      ,cS.[Name]         AS cdlStocksName
      ,cS.[HeliosID]
      ,cS.[IsSent]       AS cdlStocksIsSent
      ,cS.[SentDate]     AS cdlStocksSentDate
      ,cS.[IsActive]     AS cdlStocksIsActive
      ,cS.[ModifyDate]   AS cdlStocksModifyDate
      ,cS.[ModifyUserId] AS cdlStocksModifyUserId
      ,0      AS cdlKitsPackaging
      ,0 GroupsId
      ,'' cdlKitsCode
      ,'' cdlKitGroupsCode      
  FROM [dbo].[CardStockItems]   CSI
  LEFT OUTER JOIN [dbo].[cdlItems]   cI
      ON CSI.[ItemOrKitID] = cI.ID AND CSI.[ItemVerKit] = 0
  LEFT OUTER JOIN [dbo].[cdlMeasures] cM
      ON CSI.[ItemOrKitUnitOfMeasureId] = cM.ID AND CSI.[ItemVerKit] = 0
  LEFT OUTER JOIN [dbo].[cdlQualities] cQ
      ON CSI.[ItemOrKitQuality] = cQ.ID
  INNER JOIN [dbo].[cdlStocks]  cS
      ON CSI.[StockId] = cS.ID
WHERE CSI.[ItemVerKit] = 0

UNION ALL

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
      ,CAST(CSI.[ItemOrKitQuantity] AS INT) ItemOrKitQuantityInteger
      ,CSI.[ItemOrKitQuality]
      ,cQ.Code  AS QualitiesCode
      ,CSI.[ItemOrKitFree]
      ,CAST(CSI.[ItemOrKitFree] AS INT) ItemOrKitFreeInteger
      ,CSI.[ItemOrKitUnConsilliation]
      ,CAST(CSI.[ItemOrKitUnConsilliation] AS INT)  ItemOrKitUnConsilliationInteger
      ,CSI.[ItemOrKitReserved]
      ,CAST(CSI.[ItemOrKitReserved] AS INT)  ItemOrKitReservedInteger
      ,CSI.[ItemOrKitReleasedForExpedition]
      ,CAST(CSI.[ItemOrKitReleasedForExpedition] AS INT)  ItemOrKitReleasedForExpeditionInteger
      ,CSI.[ItemOrKitExpedited]
      ,CAST(CSI.[ItemOrKitExpedited] AS INT)  ItemOrKitExpeditedInteger
      ,CSI.[StockId]
      ,CSI.[IsActive]
      ,CSI.[ModifyDate]
      ,CSI.[ModifyUserId]
      ,0   AS cdlItemsId
      ,0  GroupGoods
      ,COALESCE(cK.[Code],'')  Code
      ,COALESCE(cK.[DescriptionCz],'') DescriptionCz
      ,cK.[DescriptionEng]
      ,COALESCE(cK.[MeasuresId],'') AS [MeasuresId]
      ,COALESCE(cMK.Code,'')               AS MeasuresCode
      ,0 [ItemTypesId]
      ,0 [PackagingId]
      ,'' [ItemType]
      ,'' [PC]
      ,0 [Packaging]
      ,0 [IsSent]
      ,CK.[SentDate]
      ,0  AS cdlItemsIsActive
      ,0  AS cdlItemsModifyDate
      ,0  AS cdlItemsModifyUserId
      ,0  AS cdlItemsPackaging
      ,cS.[ID]           AS cdlStocksID
      ,cS.[DestPlacesID]
      ,cS.[Name]         AS cdlStocksName
      ,cS.[HeliosID]
      ,cS.[IsSent]       AS cdlStocksIsSent
      ,cS.[SentDate]     AS cdlStocksSentDate
      ,cS.[IsActive]     AS cdlStocksIsActive
      ,cS.[ModifyDate]   AS cdlStocksModifyDate
      ,cS.[ModifyUserId] AS cdlStocksModifyUserId
      ,cK.Packaging      AS cdlKitsPackaging
      ,cK.GroupsId
      ,cK.Code           AS cdlKitsCode
      ,cKG.Code          AS cdlKitGroupsCode      
  FROM [dbo].[CardStockItems]   CSI
  LEFT OUTER JOIN  [dbo].[cdlKits]   cK
      ON CSI.[ItemOrKitID] = cK.ID AND CSI.[ItemVerKit] = 1
  LEFT OUTER JOIN [dbo].[cdlMeasures] cMK
      ON CSI.[ItemOrKitUnitOfMeasureId] = cMK.ID AND CSI.[ItemVerKit] = 1
  LEFT OUTER JOIN [dbo].[cdlQualities] cQ
      ON CSI.[ItemOrKitQuality] = cQ.ID
  INNER JOIN [dbo].[cdlStocks]  cS
      ON CSI.[StockId] = cS.ID
  LEFT OUTER JOIN [dbo].[cdlKitGroups] cKG
      ON CK.GroupsId=cKG.Id
WHERE CSI.[ItemVerKit] = 1


GO
GRANT SELECT
    ON OBJECT::[dbo].[vwCardStockItemsWMUN] TO [mis]
    AS [dbo];

