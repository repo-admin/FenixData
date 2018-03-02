




/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [dbo].[vwReceptionConfirmationIt]
AS
  /*
  -- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-07-23
--                2014-09-17
-- Description  : zobrazuje Reception Confirmation Items + neco z tabulky cdlItems
-- ===============================================================================================
  */
SELECT CMRCI.[ID] ,CMRCI.[CMSOId] ,CMRCI.[ItemID] , cI.GroupGoods, cI.Code, CMRCI.[ItemDescription] ,cI.DescriptionCz
, CMRCI.[ItemQuantity]
, CAST(CMRCI.[ItemQuantity] AS INT) ItemQuantityInt
, CAST(CMRSI.[ItemQuantity] AS INT) CMRSIItemQuantity 
, CMRCI.[ItemUnitOfMeasure] 
, CMRCI.[ItemQualityId] 
, CMRCI.[IsActive] 
, CMRCI.[ModifyDate] 
, CMRCI.[ModifyUserId]
, [CommunicationMessagesSentId]
, NDReceipt
, ItemSns
  FROM [dbo].[CommunicationMessagesReceptionConfirmationItems] CMRCI
LEFT OUTER JOIN [dbo].[cdlItems]  cI
ON CMRCI.[ItemID] = cI.ID
INNER JOIN [dbo].[vwReceptionConfirmationHd]   Hd
ON CMRCI.[CMSOId] = Hd.Id
INNER JOIN [dbo].[CommunicationMessagesReceptionSentItems] CMRSI
ON Hd.[CommunicationMessagesSentId] = CMRSI.[CMSOId] AND CMRCI.[ItemID] = CMRSI.[ItemId]

   --WHERE CMRCI.[IsActive] = 1











