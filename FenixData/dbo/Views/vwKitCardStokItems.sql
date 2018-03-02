





CREATE VIEW [dbo].[vwKitCardStokItems]
AS
select CSI.ID  CardStockItemsID
     , CSI.ItemOrKitId, CSI.[ItemOrKitUnitOfMeasureId], CM.Code MeasureCode  ,CSI.[ItemOrKitQuantity] ,CSI.[ItemOrKitQuality] ,CSI.[ItemOrKitFree] ,CSI.[ItemOrKitUnConsilliation] ,CSI.[ItemOrKitReserved] ,CSI.[ItemOrKitReleasedForExpedition] ,CSI.[StockId], cS.Name
     , cI.GroupGoods, cI.Code,cI.DescriptionCz,CSI.ItemOrKitExpedited
     , CK.Id  cdlKitsID
     , CASE CSI.[ItemVerKit]
          WHEN 0 THEN 'Mater/zb'
          WHEN 1 THEN 'Kit'
          ELSE '???'
       END ItemVerKitDescription
      ,CK.Packaging
      ,CK.GroupsId
      ,cKG.Code          AS cdlKitGroupsCode
      ,CAST(CSI.[ItemOrKitQuantity] AS INT) AS ItemOrKitQuantityInt
      ,CAST(CSI.[ItemOrKitFree] AS INT) AS ItemOrKitFreeInt
      ,CAST(CSI.[ItemOrKitUnConsilliation] AS INT) AS ItemOrKitUnConsilliationInt
      ,CAST(CSI.[ItemOrKitReserved] AS INT) AS ItemOrKitReservedInt
      ,CAST(CSI.[ItemOrKitReleasedForExpedition] AS INT) AS ItemOrKitReleasedForExpeditionInt
      ,CAST(CSI.[ItemOrKitExpedited] AS INT) AS ItemOrKitExpeditedInt

from [dbo].[cdlKitsItems]   CKI
INNER JOIN [dbo].[cdlKits]           CK
      ON CKI.cdlKitsId = CK.ID
INNER JOIN [dbo].[CardStockItems]    CSI
      ON CKI.ItemOrKitId = CSI.ItemOrKitId AND CK.KitQualitiesId = CSI.ItemOrKitQuality
LEFT OUTER JOIN [dbo].[cdlItems]     cI
      ON CSI.ItemOrKitId =   Ci.ID
LEFT OUTER JOIN [dbo].[cdlMeasures]    cM
      ON CSI.ItemOrKitUnitOfMeasureId = cM.ID
LEFT OUTER JOIN [dbo].[cdlStocks]         cS
      ON CSI.StockId=cS.Id
LEFT OUTER JOIN [dbo].[cdlKitGroups] cKG
      ON CK.GroupsId=cKG.Id
WHERE CKI.IsActive=1 AND CK.IsActive = 1 AND CSI.IsActive=1
--      AND CK.Id=6 AND  AND CSI.StockId = 2










