
CREATE VIEW [dbo].[vwReturnedItemItems]
AS
/*
VR2
2014-10-07
*/
SELECT RII.[ID]
      ,RII.[CMSOId]
      ,RII.[ItemId]
      ,RII.[ItemDescription]
      ,RII.[ItemQuantity]
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
      ,CMRI.[ID]                      CMRIID
      ,CMRI.[MessageId]               CMRIMessageId
      ,CMRI.[MessageTypeId]           CMRIMessageTypeId
      ,CMRI.[MessageDescription]      CMRIMessageDescription
      ,CMRI.[MessageDateOfReceipt]    CMRIMessageDateOfReceipt
      ,CMRI.[Reconciliation]          CMRIReconciliation
      ,CMRI.[IsActive]                CMRIIsActive
      ,CMRI.[ModifyDate]              CMRIModifyDate
      ,CMRI.[ModifyUserId]            CMRIModifyUserId
  FROM [dbo].[CommunicationMessagesReturnedItemItems]  RII
  INNER JOIN [dbo].[CommunicationMessagesReturnedItem]  CMRI
  ON RII.[CMSOId] = CMRI.ID


