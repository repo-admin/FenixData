








CREATE VIEW [dbo].[vwCPEreport]
AS

--  pro Jardu
--  2014-11-11, 2014-11-25, 2014-12-04, 2014-12-09

--  CPE zařízení, závoz
--  požadovaný datum navezení
--  firma, kam se naveze JMENO
--  kod, název položky , která se naváží
--  množství požadované v návozu
--  množství skutečné v návozu

SELECT CODE
      ,CMSOS.CustomerName
      ,CMSOS.RequiredDateOfShipment   AS [DatumPozadovany]
      ,CMSOS.[RequiredDateOfShipment] AS [DatumDodani]
      ,cIID,ItemOrKitQualityCode 
      ,ItemOrKitQuantity
      ,ItemOrKitQuantityReal
      ,cICode
      ,cIDescriptionCz--  * ,ItemOrKitID, ItemOrKitDescription
FROM (
SELECT CMSSI.[ID]
      ,'' AS CODE
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
  WHERE cI.ItemType='CPE'
        AND CMSSI.[IsActive] = 1 AND cI.[IsActive] = 1
        AND CMSSI.ItemVerKit=0

UNION ALL

SELECT CMSSI.[ID]
      ,cKI2.Code
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
  FROM [Fenix].[dbo].[CommunicationMessagesShipmentOrdersSentItems]   CMSSI
  INNER JOIN (
               SELECT cKI.*,cI.ID cIID, cI.Code cICode, cI.DescriptionCz cIDescriptionCz,cI.ItemType
               FROM [dbo].[cdlKitsItems]   cKI
               INNER JOIN [dbo].[cdlItems]  cI
                       ON  cKI.ItemOrKitID  = cI.ID
               WHERE cI.ItemType='CPE'
                       AND cKI.[IsActive] = 1 AND cI.[IsActive] = 1
              )  xx
        ON CMSSI.[ItemOrKitID] = xx.cdlKitsId
  INNER JOIN [dbo].[cdlKits]    cKI2
        ON xx.cdlKitsId = cKI2.ID
  WHERE CMSSI.[IsActive] =1  AND CMSSI.ItemVerKit=1
  
)  xx
  INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersSent]          CMSOS
  ON xx.CMSOId=CMSOS.ID

WHERE LEFT(xx.cIDescriptionCz,3) <> 'DMM' AND   CMSOS.IsActive=1


GO
GRANT SELECT
    ON OBJECT::[dbo].[vwCPEreport] TO [VydejkySprRWD]
    AS [dbo];

