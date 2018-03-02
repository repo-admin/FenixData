
CREATE VIEW [dbo].[vwRefurbishedConfirmationIt]
AS
  /*
-- ==============================================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-09-25
--                2014-09-29, 2014-10-09, 2015-10-23
-- Description  : zobrazuje shipment Confirmation Items 
-- Edited       : 2015-10-23 M.Rezler rozšíření ReconciliationYesNo 
--              : 2015-10-27 M.Rezler ReconciliationYesNo určováno voláním funkce
-- ==============================================================================================================
  */

SELECT It.ID [ItID],It.[CMSOId],It.[ItemVerKit] 
,It.[ItemOrKitID],It.[ItemOrKitDescription]
,It.[ItemOrKitQuantity] ,CAST(It.[ItemOrKitQuantity] AS INT) ItemOrKitQuantityInt 
,It.[ItemOrKitUnitOfMeasureId],It.[ItemOrKitUnitOfMeasure]              
,It.[ItemOrKitQualityId]  ,It.[ItemOrKitQualityCode]
,It.[IncotermsId],It.[IncotermDescription]
,It.[NDReceipt]                     
,It.[KitSNs],It.[IsActive] ,It.[ModifyDate],It.[ModifyUserId]

,CAST(COI.ItemOrKitQuantity AS INT)          COIItemOrKitQuantityInt           
,CAST(COI.ItemOrKitQuantityDelivered AS INT) ItemOrKitQuantityDeliveredInt 

,C.[ID]  ,C.[MessageId],C.[MessageTypeId]             
,C.[MessageDescription],C.[DateOfShipment],C.[RefurbishedOrderID],C.[CustomerID]                                                  
,C.[Reconciliation] 
,(SELECT [dbo].[fnReconciliationDescriptionUpper](C.[Reconciliation])) AS ReconciliationYesNo
--,CASE C.[Reconciliation]				--2015-10-27
--		WHEN 0 THEN '?'							--2015-10-27, 2015-10-23
--    WHEN 1 THEN 'SCHVÁLENO'   --2015-10-27
--    WHEN 2 THEN 'ZAMÍTNUTO'   --2015-10-27
--		WHEN 3 THEN 'D0 ODESLÁNA'		--2015-10-27, 2015-10-23		 
--    --Else '?'									--2015-10-27, 2015-10-23
--    END ReconciliationYesNo		--2015-10-27
,O.[MessageDateOfShipment],O.[DateOfDelivery]
,cDP.[CompanyName],cDP.[City] ,SN1, SN2,                                             
CASE It.[ItemVerKit] WHEN 0 THEN 'Item' WHEN 1 THEN 'Kit' ELSE '?' END  ItemVerKitText                                            
FROM [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems] It  
INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmation] C  
  ON It.CMSOId = C.ID  
INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrder]   O  
  ON C.RefurbishedOrderID = O.ID  
LEFT OUTER JOIN [dbo].[cdlDestinationPlaces] cDP                        
  ON O.[CustomerID] = cDP.ID 
LEFT OUTER JOIN [dbo].[CommunicationMessagesRefurbishedOrderItems]  COI                          
 ON O.ID = COI.CMSOId AND It.[ItemVerKit] = COI.ItemVerKit AND It.[ItemOrKitID] = COI.ItemOrKitID 
AND It.[ItemOrKitQualityId] = COI.ItemOrKitQualityId                                              
LEFT OUTER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmationSerNumSent] SNS            
ON It.ID = SNS.RefurbishedItemsOrKitsID 






/*  Změněno dne 2014-10-09
SELECT It.[ID] ItID ,It.[CMSOId] ,It.[ItemVerKit]  ,CASE It.[ItemVerKit] WHEN 0 THEN 'Item' WHEN 1 THEN 'Kit' ELSE '?' END  ItemVerKitText
,It.[ItemOrKitID],It.[ItemOrKitDescription] ,It.[ItemOrKitQuantity]
,CAST(It.[ItemOrKitQuantity] AS INT)  ItemOrKitQuantityInt
,It.[ItemOrKitUnitOfMeasureId] ,It.[ItemOrKitUnitOfMeasure]
,It.[ItemOrKitQualityId],It.[ItemOrKitQualityCode]
 ,It.[IncotermsId],It.[IncotermDescription]
,It.[NDReceipt]
      ,It.[KitSNs]
      ,It.[IsActive]
      ,It.[ModifyDate]
      ,It.[ModifyUserId]

      ,CAST(COI.ItemOrKitQuantity AS INT) COIItemOrKitQuantityInt
      ,CAST(COI.ItemOrKitQuantityDelivered AS INT) ItemOrKitQuantityDeliveredInt
      
      ,Hd.[ID]
      ,Hd.[MessageId]
      ,Hd.[MessageTypeId]
      ,Hd.[MessageDescription]
      ,Hd.[DateOfShipment]
      ,Hd.[RefurbishedOrderID]
      ,Hd.[CustomerID]
      ,Hd.[Reconciliation]
      ,Hd.[ReconciliationYesNo]
      ,Hd.[MessageDateOfShipment]
      ,Hd.[DateOfDelivery]            -- pozadovane datum z objednavky
      ,Hd.[CompanyName]
      ,Hd.[City]
  FROM [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems]  It
  LEFT OUTER JOIN [dbo].[vwRefurbishedConfirmationHd]                       Hd
  ON It.CMSOId = Hd.ID
  LEFT OUTER JOIN [dbo].[CommunicationMessagesRefurbishedOrder]            COH
  ON Hd.RefurbishedOrderID = COH.ID
  LEFT OUTER JOIN [dbo].[CommunicationMessagesRefurbishedOrderItems]  COI
  ON COH.ID = COI.CMSOId AND It.[ItemVerKit] = COI.ItemVerKit AND It.[ItemOrKitID] = COI.ItemOrKitID AND It.[ItemOrKitQualityId] = COI.ItemOrKitQualityId
  --WHERE COH.IsActive=1 AND COI.IsActive=1  AND Hd.IsActive=1

  */






