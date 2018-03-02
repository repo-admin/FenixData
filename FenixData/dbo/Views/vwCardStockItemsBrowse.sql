
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[vwCardStockItemsBrowse]
AS
SELECT [ID]
      ,[ItemVerKit]
      ,ItemVerKitDescription
      ,[ItemOrKitID]
      ,[ItemOrKitUnitOfMeasureId]
      ,[ItemOrKitQuantity]
      ,[ItemOrKitQuality]
      ,[ItemOrKitFree]
      ,[ItemOrKitUnConsilliation]
      ,[ItemOrKitReserved]
      ,[ItemOrKitReleasedForExpedition]
      ,[ItemOrKitExpedited]
      ,[StockId]
      ,[IsActive]
      ,[ModifyDate]
      ,[ModifyUserId]
       ,cdlItemsId
      ,[GroupGoods]
      ,[Code]
      ,[DescriptionCz]
      ,[DescriptionEng]
      ,[MeasuresId]
      ,[ItemTypesId]
      ,[PackagingId]
      ,[ItemType]
      ,[PC]
      ,[Packaging]
      ,[IsSent]
      ,[SentDate]
      ,cdlItemsIsActive
      ,cdlItemsModifyDate
      ,cdlItemsModifyUserId
      ,cdlStocksID
      ,[DestPlacesID]
      ,cdlStocksName
      ,[HeliosID]
      ,cdlStocksIsSent
      ,cdlStocksSentDate
      ,cdlStocksIsActive
      ,cdlStocksModifyDate
      ,cdlStocksModifyUserId
 FROM vwCardStockItems
 WHERE [ItemVerKit]=0






