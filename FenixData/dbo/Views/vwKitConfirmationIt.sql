



/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [dbo].[vwKitConfirmationIt]
AS
  /*
  -- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-07-23
-- Updated date : 2014-09-09
--                2014-09-17
-- Description  : zobrazuje Reception Confirmation Items + neco z tabulky cdlItems
-- ===============================================================================================
  */


SELECT CMRCI.[ID] , CMRCI.[CMSOId] , CMRSI.[HeliosOrderID] ,CMRSI.[HeliosOrderRecordId]
     , CMRCI.[KitId] ,  CMRCI.[KitDescription] ,cI.DescriptionCz
     , CMRCI.[KitQuantity]
     , CMRSI.[KitQuantity] CMRSIItemQuantity 
     , CAST(CMRCI.[KitQuantity] AS INT) KitQuantityInt
     , CAST(CMRSI.[KitQuantity] AS INT) CMRSIItemQuantityInt
     , CMRCI.[KitUnitOfMeasure] ,CMRCI.[KitQualityId] ,CMRCI.[IsActive] ,CMRCI.[ModifyDate] ,CMRCI.[ModifyUserId]
     , CMRSI.CMSOId AS CommunicationMessagesSentId,Q.Code
     , CMRCI.[KitSNs]
  FROM [dbo].[CommunicationMessagesKittingsConfirmationItems] CMRCI
LEFT OUTER JOIN [dbo].[cdlKits]  cI
ON CMRCI.[KitID] = cI.ID
INNER JOIN [dbo].[vwKitConfirmationHd]  Hd
ON CMRCI.[CMSOId] = Hd.Id
INNER JOIN [dbo].[CommunicationMessagesKittingsSentItems] CMRSI
ON Hd.[KitOrderID] = CMRSI.[CMSOId] AND CMRCI.[KitID] = CMRSI.[KitId]
LEFT OUTER JOIN [dbo].[cdlQualities]  Q
ON Q.ID = CMRCI.[KitQualityId]
   --WHERE CMRCI.[IsActive] = 1




GO
GRANT SELECT
    ON OBJECT::[dbo].[vwKitConfirmationIt] TO [FenixR]
    AS [dbo];

