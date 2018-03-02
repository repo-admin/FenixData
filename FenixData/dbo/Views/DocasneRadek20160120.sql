

CREATE VIEW [dbo].[DocasneRadek20160120]
AS

/****** Script for SelectTopNRows command from SSMS  ******/

SELECT   --It.ID [ItID],It.[CMSOId],
 It.[ItemVerKit] 
,It.[ItemOrKitID],It.[ItemOrKitDescription]
,It.[ItemOrKitQuantity] ,CAST(It.[ItemOrKitQuantity] AS INT) ItemOrKitQuantityInt 
,It.[ItemOrKitUnitOfMeasureId],It.[ItemOrKitUnitOfMeasure]              
,It.[ItemOrKitQualityId]  ,It.[ItemOrKitQualityCode]
,It.[IncotermsId],It.[IncotermDescription]
,It.[NDReceipt]                     
--,It.[KitSNs]
,It.[IsActive] ,It.[ModifyDate],It.[ModifyUserId]
,CAST(COI.ItemOrKitQuantity AS INT)          COIItemOrKitQuantityInt           
,CAST(COI.ItemOrKitQuantityDelivered AS INT) ItemOrKitQuantityDeliveredInt 
,C.[ID]  ,C.[MessageId],C.[MessageTypeId]             
,C.[MessageDescription],C.[DateOfShipment],C.[RefurbishedOrderID],C.[CustomerID]                                                  
,C.[Reconciliation] 
,CASE C.[Reconciliation]				--2015-10-27
	WHEN 0 THEN '?'						--2015-10-27, 2015-10-23
   WHEN 1 THEN 'SCHVÁLENO'          --2015-10-27
   WHEN 2 THEN 'ZAMÍTNUTO'          --2015-10-27
	WHEN 3 THEN 'D0 ODESLÁNA'	    	--2015-10-27, 2015-10-23		 
   Else '?'									--2015-10-27, 2015-10-23
END ReconciliationYesNo		--2015-10-27
,O.[MessageDateOfShipment],O.[DateOfDelivery]
,cDP.[CompanyName],cDP.[City] 
,CASE It.[ItemVerKit] WHEN 0 THEN 'Item' WHEN 1 THEN 'Kit' ELSE '?' END  ItemVerKitText                                            
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
WHERE Reconciliation IN (0,1) 
      AND It.IsActive=1
      AND C.IsActive=1
      AND It.[ItemVerKit]=1
      AND It.[ItemOrKitID] IN (1500000072,1500000030,1500000054)
--ORDER BY It.[ItemOrKitID]






