



CREATE VIEW [dbo].[vwCMRF0SentIt]
AS
/*
2014-09-23
*/
SELECT RF0I.[ID]
      ,RF0I.[CMSOId]
      ,RF0I.[ItemVerKit]
      ,CASE RF0I.[ItemVerKit]  WHEN 0 THEN 'Item' WHEN 1 THEN 'Kit' ELSE '' END ItemVerKitText
      ,RF0I.[ItemOrKitID]
      ,RF0I.[ItemOrKitDescription]
      ,RF0I.[ItemOrKitQuantity]
      ,RF0I.[ItemOrKitQuantityDelivered]
      ,CAST(RF0I.[ItemOrKitQuantity] AS INT) ItemOrKitQuantityInt
      ,CAST(RF0I.[ItemOrKitQuantityDelivered] AS INT)  ItemOrKitQuantityDeliveredInt
      ,RF0I.[ItemOrKitUnitOfMeasureId]
      ,RF0I.[ItemOrKitUnitOfMeasure]
      ,RF0I.[ItemOrKitQualityId]
      ,RF0I.[ItemOrKitQualityCode]
      ,RF0I.[IsActive]
      ,RF0I.[ModifyDate]
      ,RF0I.[ModifyUserId]
  FROM [dbo].[CommunicationMessagesRefurbishedOrderItems]  RF0I


