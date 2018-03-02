
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[vwVR2It]
AS
/*
2014-10-10

*/
SELECT RII.[ID]
      ,RII.[CMSOId]
      ,RII.[ItemId]
      ,RII.[ItemDescription]
      ,RII.[ItemQuantity]
      ,CAST(RII.[ItemQuantity] AS int) ItemQuantityInt
      ,RII.[ItemOrKitQualityId]
      ,RII.[ItemOrKitQuality]
      ,RII.[ItemUnitOfMeasureId]
      ,RII.[ItemUnitOfMeasure]
      ,RII.[SN]
      ,RII.[NDReceipt]
      ,RII.[ReturnedFrom]
      ,RII.[IsActive]
      ,RII.[ModifyDate]
      ,RII.[ModifyUserId]
      ,RI.[ID]                   RIID
      ,RI.[MessageId]            RIMessageId
      ,RI.[MessageTypeId]        RIMessageTypeId
      ,RI.[MessageDescription]   RIMessageDescription
      ,RI.[MessageDateOfReceipt] RIMessageDateOfReceipt
      ,RI.[Reconciliation]       RIReconciliation
      ,RI.[IsActive]             RIIsActive
      ,RI.[ModifyDate]           RIModifyDate
      ,RI.[ModifyUserId]         RIModifyUserId
FROM [dbo].[CommunicationMessagesReturnedItemItems]  RII
INNER JOIN [dbo].[CommunicationMessagesReturnedItem] RI
ON RII.CMSOId = RI.ID
