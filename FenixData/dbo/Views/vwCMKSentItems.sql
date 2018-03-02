


CREATE VIEW [dbo].[vwCMKSentItems]
AS
/*
2014-08-05
2014-09-17
*/
SELECT [ID]
      ,[CMSOId]
      ,[KitId]
      ,[KitDescription]
      ,[KitQuantity]
      ,[KitQuantityDelivered]
      ,CAST([KitQuantity] AS int) KitQuantityInt
      ,CAST([KitQuantityDelivered] AS int) KitQuantityDeliveredInt
      ,[MeasuresID]
      ,[KitUnitOfMeasure]
      ,[KitQualityId]
      ,[KitQualityCode]
      ,[HeliosOrderID]
      ,[HeliosOrderRecordId]
      ,[CardStockItemsId]
      ,[IsActive]
      ,[ModifyDate]
      ,[ModifyUserId]
  FROM [dbo].[CommunicationMessagesKittingsSentItems]








