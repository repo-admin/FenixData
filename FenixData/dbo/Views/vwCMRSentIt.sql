

CREATE VIEW [dbo].[vwCMRSentIt]
AS
/*
2014-09-16
2014-09-17
*/
SELECT [ID]
      ,[CMSOId]
      ,[HeliosOrderId]
      ,[HeliosOrderRecordId]
      ,[ItemId]
      ,[GroupGoods]
      ,[ItemCode]
      ,[ItemDescription]
      ,[ItemQuantity]
      ,ItemQuantityDelivered
      ,CAST([ItemQuantity] AS int)            ItemQuantityInt
      ,CAST([ItemQuantityDelivered] AS int)   ItemQuantityDeliveredInt
      ,[MeasuresID]
      ,[ItemUnitOfMeasure]
      ,[ItemQualityId]
      ,[ItemQualityCode]
      ,[SourceId]
      ,[IsActive]
      ,[ModifyDate]
      ,[ModifyUserId]
  FROM [dbo].[CommunicationMessagesReceptionSentItems]


