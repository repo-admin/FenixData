
CREATE VIEW [dbo].[vwShipmentOrderIt]
AS
/*
2014-09-17
*/
SELECT CMSOI.[ID]
      ,CMSOI.[CMSOId]
      ,CASE CMSOI.[SingleOrMaster] WHEN 0 THEN 'Single' WHEN 1 THEN 'Master' ELSE '' END SingleOrMaster 
      ,CASE CMSOI.[ItemVerKit]     WHEN 0 THEN 'Item'   WHEN 1 THEN 'Kit'    ELSE '' END ItemVerKit
      ,CMSOI.[ItemOrKitID]
      ,CMSOI.[ItemOrKitDescription]
      ,CMSOI.[ItemOrKitQuantity]
      ,CMSOI.[ItemOrKitQuantityReal]
      ,CAST(CMSOI.[ItemOrKitQuantity] AS INT)     ItemOrKitQuantityInt
      ,CAST(CMSOI.[ItemOrKitQuantityReal] AS INT) ItemOrKitQuantityRealInt
      ,CMSOI.[ItemOrKitUnitOfMeasureId]
      ,CMSOI.[ItemOrKitUnitOfMeasure]
      ,CMSOI.[ItemOrKitQualityId]
      ,CMSOI.[ItemOrKitQualityCode]
      ,CMSOI.[ItemType]
      ,CMSOI.[IncotermsId]
      ,CMSOI.[Incoterms]
      ,CMSOI.[PackageValue]
      ,CMSOI.[ShipmentOrderSource]
      ,CMSOI.[VydejkyId]
      ,CMSOI.[CardStockItemsId]
      ,CMSOI.[HeliosOrderRecordId]
      ,CMSOI.[IsActive]
      ,CMSOI.[ModifyDate]
      ,CMSOI.[ModifyUserId]
  FROM [dbo].[CommunicationMessagesShipmentOrdersSentItems]  CMSOI


