/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW vwVR2SN
AS
/*
2014-10-10
*/
SELECT SrN.[ID]
      ,SrN.[RefurbishedItemsOrKitsID]
      ,SrN.[SN]
      ,SrN.[IsActive]
      ,SrN.[ModifyDate]
      ,SrN.[ModifyUserId]
      ,VR2It.[ID]                        VR2ItID
      ,VR2It.[CMSOId]                    VR2ItCMSOId
      ,VR2It.[ItemId]                    VR2ItItemId
      ,VR2It.[ItemDescription]           VR2ItItemDescription
      ,VR2It.[ItemQuantity]              VR2ItItemQuantity
      ,VR2It.[ItemQuantityInt]           VR2ItItemQuantityInt
      ,VR2It.[ItemOrKitQualityId]        VR2ItItemOrKitQualityId
      ,VR2It.[ItemOrKitQuality]          VR2ItItemOrKitQuality
      ,VR2It.[ItemUnitOfMeasureId]       VR2ItItemUnitOfMeasureId
      ,VR2It.[ItemUnitOfMeasure]         VR2ItItemUnitOfMeasure
      ,VR2It.[SN]                        VR2ItSN
      ,VR2It.[NDReceipt]                 VR2ItNDReceipt
      ,VR2It.[ReturnedFrom]              VR2ItReturnedFrom
      ,VR2It.[IsActive]                  VR2ItIsActive
      ,VR2It.[ModifyDate]                VR2ItModifyDate
      ,VR2It.[ModifyUserId]              VR2ItModifyUserId
      ,VR2It.[RIID]                      VR2ItRIID
      ,VR2It.[RIMessageId]               VR2ItRIMessageId
      ,VR2It.[RIMessageTypeId]           VR2ItRIMessageTypeId
      ,VR2It.[RIMessageDescription]      VR2ItRIMessageDescription
      ,VR2It.[RIMessageDateOfReceipt]    VR2ItRIMessageDateOfReceipt
      ,VR2It.[RIReconciliation]          VR2ItRIReconciliation
      ,VR2It.[RIIsActive]                VR2ItRIIsActive
      ,VR2It.[RIModifyDate]              VR2ItRIModifyDate
      ,VR2It.[RIModifyUserId]            VR2ItRIModifyUserId
  FROM [dbo].[CommunicationMessagesReturnedItemsSerNum]  SrN
  INNER JOIN [dbo].[vwVR2It]                                      VR2It
  ON SrN.RefurbishedItemsOrKitsID = VR2It.ID