


CREATE VIEW [dbo].[vwOrdersShipmentReport_]
AS

--  
--  2014-11-11


--  požadovaný datum navezení
--  firma, kam se naveze JMENO
--  kod, název položky , která se naváží
--  množství požadované v návozu



SELECT CMSOS.CustomerName,CMSOS.RequiredDateOfShipment,cIID,ItemOrKitQualityCode , ItemOrKitQuantity, cICode, cIDescriptionCz,ItemOrKitID, ItemOrKitDescription,ItemOrKitQuantityReal--  * ,ItemOrKitID, ItemOrKitDescription
FROM (
SELECT CMSSI.[ID]
      ,CMSSI.[CMSOId]
      ,CMSSI.[SingleOrMaster]
      ,CMSSI.[ItemVerKit]
      ,CMSSI.[ItemOrKitID]
      ,CMSSI.[ItemOrKitDescription]
      ,CMSSI.[ItemOrKitQuantity]
      ,CMSSI.[ItemOrKitQuantityReal]
      ,CMSSI.[ItemOrKitUnitOfMeasureId]
      ,CMSSI.[ItemOrKitUnitOfMeasure]
      ,CMSSI.[ItemOrKitQualityId]
      ,CMSSI.[ItemOrKitQualityCode]
      ,CMSSI.[ItemType]
      ,CMSSI.[IncotermsId]
      ,CMSSI.[Incoterms]
      ,CMSSI.[PackageValue]
      ,CMSSI.[ShipmentOrderSource]
      ,CMSSI.[VydejkyId]
      ,CMSSI.[CardStockItemsId]
      ,CMSSI.[HeliosOrderRecordId]
      ,CMSSI.[IsActive]
      ,CMSSI.[ModifyDate]
      ,CMSSI.[ModifyUserId]
      ,CMSSI.[IdRowReleaseNote]
      ,cI.ID cIID
      ,cI.Code cICode
      ,cI.DescriptionCz cIDescriptionCz
  FROM [dbo].[CommunicationMessagesShipmentOrdersSentItems] CMSSI
  INNER JOIN [dbo].[cdlItems]  cI
        ON  CMSSI.ItemOrKitID  = cI.ID
  WHERE CMSSI.[IsActive] = 1 AND cI.[IsActive] = 1

UNION ALL

SELECT CMSSI.[ID]
      ,CMSSI.[CMSOId]
      ,CMSSI.[SingleOrMaster]
      ,CMSSI.[ItemVerKit]
      ,CMSSI.[ItemOrKitID]
      ,CMSSI.[ItemOrKitDescription]
      ,CMSSI.[ItemOrKitQuantity]
      ,CMSSI.[ItemOrKitQuantityReal]
      ,CMSSI.[ItemOrKitUnitOfMeasureId]
      ,CMSSI.[ItemOrKitUnitOfMeasure]
      ,CMSSI.[ItemOrKitQualityId]
      ,CMSSI.[ItemOrKitQualityCode]
      ,CMSSI.[ItemType]
      ,CMSSI.[IncotermsId]
      ,CMSSI.[Incoterms]
      ,CMSSI.[PackageValue]
      ,CMSSI.[ShipmentOrderSource]
      ,CMSSI.[VydejkyId]
      ,CMSSI.[CardStockItemsId]
      ,CMSSI.[HeliosOrderRecordId]
      ,CMSSI.[IsActive]
      ,CMSSI.[ModifyDate]
      ,CMSSI.[ModifyUserId]
      ,CMSSI.[IdRowReleaseNote]
      ,cIID
      ,cICode
      ,cIDescriptionCz
  FROM [dbo].[CommunicationMessagesShipmentOrdersSentItems] CMSSI
  INNER JOIN (
            SELECT cKI.*,cI.ID cIID, cI.Code cICode, cI.DescriptionCz cIDescriptionCz
               FROM [dbo].[cdlKitsItems]   cKI
               INNER JOIN [dbo].[cdlItems]  cI
                       ON  cKI.ItemOrKitID  = cI.ID
               WHERE cKI.[IsActive] = 1 AND cI.[IsActive] = 1)  xx
        ON CMSSI.[ItemOrKitID] = xx.cdlKitsId
  WHERE  CMSSI.[IsActive] = 1
  ) yy
  INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersSent]  CMSOS
     ON CMSOS.ID = yy.CMSOId
WHERE CMSOS.[IsActive] = 1


