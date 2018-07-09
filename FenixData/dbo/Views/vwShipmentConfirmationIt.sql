









CREATE VIEW [dbo].[vwShipmentConfirmationIt]
AS
  /*
  -- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-08-31
-- Updated date : 2014-09-09, 2014-09-24, 2014-10-03, 2014-11-10, 2015-04-28 (DISTINCT)
-- Description  : zobrazuje Shipment Confirmation Items 
-- ===============================================================================================
  */

SELECT DISTINCT CMRCI.[ID] ,CMRCI.[CMSOId] ,
        CASE CMRCI.[SingleOrMaster] WHEN 0 THEN 'Single' WHEN 1 THEN 'Master' ELSE '' END SingleOrMaster 
       ,CMRCI.[HeliosOrderRecordID] 
       ,CASE CMRCI.[ItemVerKit]  WHEN 0 THEN 'Item' WHEN 1 THEN 'Kit' ELSE '' END ItemVerKit,CMRCI.[ItemOrKitID]
       ,CMRCI.[ItemOrKitDescription] 
       ,CMRCI.[ItemOrKitQuantity] CMRSIItemQuantity 
       ,CAST(CMRCI.[ItemOrKitQuantity] AS INT) CMRSIItemQuantityInt
       ,CMRCI.[ItemOrKitUnitOfMeasureId] ,CMRCI.[ItemOrKitUnitOfMeasure]
       ,CMRCI.[ItemOrKitQualityId] ,CMRCI.[ItemOrKitQualityCode] ,CMRCI.[IncotermsId] ,CMRCI.[IncotermDescription] ,CMRCI.[RealDateOfDelivery]
       ,CMRCI.[RealItemOrKitQuantity] 
       ,CAST(CMRCI.[RealItemOrKitQuantity] AS INT) RealItemOrKitQuantityInt
       ,CMRCI.[RealItemOrKitQualityID] 
       ,CMRCI.[RealItemOrKitQuality]
       ,CMRCI.[Status]
       ,CMRCI.[KitSNs] ,CMRCI.[IsActive] ,CMRCI.[ModifyDate] ,CMRCI.[ModifyUserId], Q.Code, CMSOSI.CMSOId AS CommunicationMessagesSentId
       ,CMSOSI.[ItemOrKitQuantityReal]
       ,CAST(CMSOSI.[ItemOrKitQuantityReal] AS int) ItemOrKitQuantityRealInt
       , CMSOSI.[CardStockItemsId]
       , CMSOSI.[VydejkyId]
       , CMSOSI.[ShipmentOrderSource]
       , CAST(CMSOSI.ItemOrKitQuantity AS INT)       CMSOSIItemOrKitQuantity
FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems]         CMRCI
INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmation]        CMSOC
     ON CMRCI.CMSOId = CMSOC.Id
INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersSentItems]           CMSOSI
     ON CMSOC.[ShipmentOrderID] = CMSOSI.[CMSOId] and CMRCI.[ItemOrKitID] = CMSOSI.[ItemOrKitID] AND CMRCI.[ItemVerKit] = CMSOSI.[ItemVerKit] AND CMRCI.[RealItemOrKitQualityID] = CMSOSI.[ItemOrKitQualityId]
     AND CMSOSI.[SingleOrMaster] = CMRCI.[SingleOrMaster] 

LEFT OUTER JOIN [dbo].[cdlQualities]  Q
ON Q.ID = CMRCI.[RealItemOrKitQualityID]
















