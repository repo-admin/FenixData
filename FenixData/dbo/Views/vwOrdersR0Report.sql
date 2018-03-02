



CREATE VIEW [dbo].[vwOrdersR0Report]
AS

--  
--  2014-11-11


--  požadovaný datum navezení
--  firma, kam se naveze JMENO
--  kod, název položky , která se naváží
--  množství požadované v návozu



SELECT DISTINCT yy.ID, yy.CMSOId, CMSOS.ItemSupplierDescription,CMSOS.ItemDateOfDelivery,cIID,cICode, cIDescriptionCz,ItemQuantity, ItemQuantityDelivered--  * ,ItemOrKitID, ItemOrKitDescription
FROM (
SELECT CMSSI.[ID]
      ,CMSSI.[CMSOId]
      ,CMSSI.[HeliosOrderId]
      ,CMSSI.[HeliosOrderRecordId]
      ,CMSSI.[ItemID]
      ,CMSSI.[GroupGoods]
      ,CMSSI.[ItemCode]
      ,CMSSI.[ItemDescription]
      ,CMSSI.[ItemQuantity]
      ,CMSSI.[ItemQuantityDelivered]
      ,CMSSI.[MeasuresID]
      ,CMSSI.[ItemUnitOfMeasure]
      ,CMSSI.[ItemQualityId]
      ,CMSSI.[ItemQualityCode]
      ,CMSSI.[SourceId]
      ,CMSSI.[IsActive]
      ,CMSSI.[ModifyDate]
      ,CMSSI.[ModifyUserId]
      ,cI.ID cIID
      ,cI.Code cICode
      ,cI.DescriptionCz cIDescriptionCz
  FROM [dbo].[CommunicationMessagesReceptionSentItems]       CMSSI
  INNER JOIN [dbo].[cdlItems]  cI
        ON  CMSSI.[ItemID]  = cI.ID
  WHERE CMSSI.[IsActive] = 1 AND cI.[IsActive] = 1

UNION ALL

SELECT CMSSI.[ID]
      ,CMSSI.[CMSOId]
      ,CMSSI.[HeliosOrderId]
      ,CMSSI.[HeliosOrderRecordId]
      ,CMSSI.[ItemID]
      ,CMSSI.[GroupGoods]
      ,CMSSI.[ItemCode]
      ,CMSSI.[ItemDescription]
      ,CMSSI.[ItemQuantity]
      ,CMSSI.[ItemQuantityDelivered]
      ,CMSSI.[MeasuresID]
      ,CMSSI.[ItemUnitOfMeasure]
      ,CMSSI.[ItemQualityId]
      ,CMSSI.[ItemQualityCode]
      ,CMSSI.[SourceId]
      ,CMSSI.[IsActive]
      ,CMSSI.[ModifyDate]
      ,CMSSI.[ModifyUserId]
      ,xx.cIID
      ,xx.cICode
      --,xx.cIDescriptionCz
      ,cIDescriptionCz
  FROM [dbo].[CommunicationMessagesReceptionSentItems] CMSSI
  INNER JOIN (
            SELECT cKI.*,cI.ID cIID, cI.Code cICode, cI.DescriptionCz cIDescriptionCz
               FROM [dbo].[cdlKitsItems]   cKI
               INNER JOIN [dbo].[cdlItems]  cI
                       ON  cKI.ItemOrKitID  = cI.ID
               WHERE cKI.[IsActive] = 1 AND cI.[IsActive] = 1)  xx
        ON CMSSI.[ItemID] = xx.cIID
  WHERE  CMSSI.[IsActive] = 1
  ) yy
  INNER JOIN [dbo].[CommunicationMessagesReceptionSent]  CMSOS
     ON CMSOS.ID = yy.CMSOId
WHERE CMSOS.[IsActive] = 1



