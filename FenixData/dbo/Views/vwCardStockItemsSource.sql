



/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[vwCardStockItemsSource]
AS
SELECT CSI.[ID]
      ,CSI.[ItemVerKit]
      ,CSI.[ItemOrKitId]
      ,CSI.[ItemOrKitUnitOfMeasureId]
      ,CSI.[ItemOrKitQuantity]
      ,CSI.[ItemOrKitQuality]
      ,CSI.[ItemOrKitFree]
      ,CSI.[ItemOrKitUnConsilliation]
      ,CSI.[ItemOrKitReserved]
      ,CSI.[ItemOrKitReleasedForExpedition]
      ,CSI.[ItemOrKitExpedited]
      ,CSI.[StockId]
      ,CSI.[IsActive]
      ,CSI.[ModifyDate]
      ,CSI.[ModifyUserId]
      ,RCI.ID  IDsource
      ,RCI.CMSOId CMSOId
      ,RCI.[ItemQuantity]       R1ItemQuantity
      ,0       RF1ItemOrKitQuantity
      ,0       S1ItemOrKitQuantity
      ,0       S0ItemOrKitQuantity
      ,0       S0ItemOrKitQuantityReal
      ,0       K1KitQuantity
      ,0       ApprKitQuantity
      ,0       zKitu_Reserved
      ,0       S1zKitu
      ,''      ItemOrKitIDzKitu
      ,RC.Reconciliation       Reconciliation
      ,0       KitQuantityK0
      ,0       KitQuantityDeliveredK0
  FROM [dbo].[CardStockItems]     CSI
  LEFT OUTER JOIN [dbo].[CommunicationMessagesReceptionConfirmationItems] RCI
     ON CSI.[ItemOrKitId] = RCI.[ItemID] AND CSI.ItemOrKitQuality=RCI.ItemQualityId
  INNER JOIN CommunicationMessagesReceptionConfirmation RC
     ON RCI.CMSOId = RC.ID
  WHERE CSI.IsActive=1 AND RC.IsActive=1
UNION ALL

SELECT CSI.[ID]
      ,CSI.[ItemVerKit]
      ,CSI.[ItemOrKitId]
      ,CSI.[ItemOrKitUnitOfMeasureId]
      ,CSI.[ItemOrKitQuantity]
      ,CSI.[ItemOrKitQuality]
      ,CSI.[ItemOrKitFree]
      ,CSI.[ItemOrKitUnConsilliation]
      ,CSI.[ItemOrKitReserved]
      ,CSI.[ItemOrKitReleasedForExpedition]
      ,CSI.[ItemOrKitExpedited]
      ,CSI.[StockId]
      ,CSI.[IsActive]
      ,CSI.[ModifyDate]
      ,CSI.[ModifyUserId]
      ,ROCI.ID  IDsource
      ,ROCI.CMSOId CMSOId
      ,0       R1ItemQuantity
      ,ROCI.ItemOrKitQuantity   RF1ItemOrKitQuantity
      ,0       S1ItemOrKitQuantity
      ,0       S0ItemOrKitQuantity
      ,0       S0ItemOrKitQuantityReal
      ,0       K1KitQuantity
      ,0       ApprKitQuantity
      ,0       zKitu_Reserved
      ,0       S1zKitu
      ,''      ItemOrKitIDzKitu
      ,RC.Reconciliation       Reconciliation
      ,0       KitQuantityK0
      ,0       KitQuantityDeliveredK0

  FROM [dbo].[CardStockItems]     CSI
  LEFT OUTER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems]  ROCI
  ON CSI.[ItemOrKitId] = ROCI.[ItemOrKitID] AND CSI.ItemOrKitQuality=ROCI.ItemOrKitQualityId
  INNER JOIN CommunicationMessagesRefurbishedOrderConfirmation RC
  ON ROCI.CMSOId = RC.ID
  WHERE CSI.IsActive=1 AND RC.IsActive=1

  UNION ALL

SELECT CSI.[ID]
      ,CSI.[ItemVerKit]
      ,CSI.[ItemOrKitId]
      ,CSI.[ItemOrKitUnitOfMeasureId]
      ,CSI.[ItemOrKitQuantity]
      ,CSI.[ItemOrKitQuality]
      ,CSI.[ItemOrKitFree]
      ,CSI.[ItemOrKitUnConsilliation]
      ,CSI.[ItemOrKitReserved]
      ,CSI.[ItemOrKitReleasedForExpedition]
      ,CSI.[ItemOrKitExpedited]
      ,CSI.[StockId]
      ,CSI.[IsActive]
      ,CSI.[ModifyDate]
      ,CSI.[ModifyUserId]
      ,SOCI.ID  IDsource
      ,SOCI.CMSOId CMSOId
      ,0       R1ItemQuantity
      ,0       RF1ItemOrKitQuantity
      ,SOCI.RealItemOrKitQuantity  S1ItemOrKitQuantity
      ,0       S0ItemOrKitQuantity
      ,0       S0ItemOrKitQuantityReal
      ,0       K1KitQuantity
      ,0       ApprKitQuantity
      ,0       zKitu_Reserved
      ,0       S1zKitu
      ,''      ItemOrKitIDzKitu
      ,RC.Reconciliation       Reconciliation
      ,0       KitQuantityK0
      ,0       KitQuantityDeliveredK0

  FROM [dbo].[CardStockItems]     CSI
  LEFT OUTER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems] SOCI
  ON CSI.[ItemOrKitId] = SOCI.[ItemOrKitID] AND CSI.ItemOrKitQuality=SOCI.ItemOrKitQualityId
  INNER JOIN CommunicationMessagesShipmentOrdersConfirmation RC
  ON SOCI.CMSOId = RC.ID
  WHERE CSI.IsActive=1 AND RC.IsActive=1
    UNION ALL

SELECT CSI.[ID]
      ,CSI.[ItemVerKit]
      ,CSI.[ItemOrKitId]
      ,CSI.[ItemOrKitUnitOfMeasureId]
      ,CSI.[ItemOrKitQuantity]
      ,CSI.[ItemOrKitQuality]
      ,CSI.[ItemOrKitFree]
      ,CSI.[ItemOrKitUnConsilliation]
      ,CSI.[ItemOrKitReserved]
      ,CSI.[ItemOrKitReleasedForExpedition]
      ,CSI.[ItemOrKitExpedited]
      ,CSI.[StockId]
      ,CSI.[IsActive]
      ,CSI.[ModifyDate]
      ,CSI.[ModifyUserId]
      ,SOCI.ID  IDsource
      ,SOCI.CMSOId CMSOId
      ,0       R1ItemQuantity
      ,0       RF1ItemOrKitQuantity
      ,0       S1ItemOrKitQuantity
      ,SOCI.[ItemOrKitQuantity]        S0ItemOrKitQuantity
      ,SOCI.ItemOrKitQuantityReal      S0ItemOrKitQuantityReal
      ,0       K1KitQuantity
      ,0       ApprKitQuantity
      ,0       zKitu_Reserved
      ,0       S1zKitu
      ,''      ItemOrKitIDzKitu
      ,ISNULL(SOC.Reconciliation ,0)       Reconciliation
      ,0       KitQuantityK0
      ,0       KitQuantityDeliveredK0

  FROM [dbo].[CardStockItems]     CSI
  LEFT OUTER JOIN [dbo].[CommunicationMessagesShipmentOrdersSentItems] SOCI
  ON CSI.[ItemOrKitId] = SOCI.[ItemOrKitID] AND CSI.ItemOrKitQuality=SOCI.ItemOrKitQualityId
  INNER JOIN CommunicationMessagesShipmentOrdersSent RS
    ON SOCI.CMSOId = RS.ID
  LEFT OUTER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmation]   SOC
     ON RS.ID = SOC.ShipmentOrderID
  WHERE CSI.IsActive=1 AND RS.IsActive=1



    UNION ALL


SELECT CSI.[ID]
      ,CSI.[ItemVerKit]
      ,CSI.[ItemOrKitId]
      ,CSI.[ItemOrKitUnitOfMeasureId]
      ,CSI.[ItemOrKitQuantity]
      ,CSI.[ItemOrKitQuality]
      ,CSI.[ItemOrKitFree]
      ,CSI.[ItemOrKitUnConsilliation]
      ,CSI.[ItemOrKitReserved]
      ,CSI.[ItemOrKitReleasedForExpedition]
      ,CSI.[ItemOrKitExpedited]
      ,CSI.[StockId]
      ,CSI.[IsActive]
      ,CSI.[ModifyDate]
      ,CSI.[ModifyUserId]
      ,KCI.ID  IDsource
      ,KCI.CMSOId CMSOId
      ,0       R1ItemQuantity
      ,0       RF1ItemOrKitQuantity
      ,0       S1ItemOrKitQuantity
      ,0       S0ItemOrKitQuantity
      ,0       S0ItemOrKitQuantityReal
      ,KCI.KitQuantity   K1KitQuantity
      ,0       ApprKitQuantity
      ,0       zKitu_Reserved
      ,0       S1zKitu
      ,''      ItemOrKitIDzKitu
      ,RC.Reconciliation       Reconciliation
      ,0       KitQuantityK0
      ,0       KitQuantityDeliveredK0

  FROM [dbo].[CardStockItems]     CSI
  LEFT OUTER JOIN [dbo].[CommunicationMessagesKittingsConfirmationItems] KCI
  ON CSI.[ItemOrKitId] = KCI.KitID AND CSI.ItemVerKit = 1  AND CSI.ItemOrKitQuality=KCI.KitQualityId
  INNER JOIN CommunicationMessagesKittingsConfirmation RC
  ON KCI.CMSOId = RC.ID
  WHERE CSI.IsActive=1 AND RC.IsActive=1

UNION ALL

SELECT CSI.[ID]
      ,CSI.[ItemVerKit]
      ,CSI.[ItemOrKitId]
      ,CSI.[ItemOrKitUnitOfMeasureId]
      ,CSI.[ItemOrKitQuantity]
      ,CSI.[ItemOrKitQuality]
      ,CSI.[ItemOrKitFree]
      ,CSI.[ItemOrKitUnConsilliation]
      ,CSI.[ItemOrKitReserved]
      ,CSI.[ItemOrKitReleasedForExpedition]
      ,CSI.[ItemOrKitExpedited]
      ,CSI.[StockId]
      ,CSI.[IsActive]
      ,CSI.[ModifyDate]
      ,CSI.[ModifyUserId]
      ,AKS.ID IDsource
      ,-1  CMSOId
      ,0       R1ItemQuantity
      ,0       RF1ItemOrKitQuantity
      ,0       S1ItemOrKitQuantity
      ,0       S0ItemOrKitQuantity
      ,0       S0ItemOrKitQuantityReal
      ,0       K1KitQuantity
      ,AKS.[KitQuantity]  ApprKitQuantity
      ,0       zKitu_Reserved
      ,0       S1zKitu
      ,''      ItemOrKitIDzKitu
      ,0       Reconciliation
      ,0       KitQuantityK0
      ,0       KitQuantityDeliveredK0

  FROM [dbo].[CardStockItems]     CSI
  LEFT OUTER JOIN [dbo].[CommunicationMessagesKittingsApprovalKitsSent] AKS
  ON CSI.[ItemOrKitId] = AKS.[KitID] AND CSI.ItemOrKitQuality=AKS.KitQualityId
  INNER JOIN [dbo].[CommunicationMessagesKittingsApprovalKitsSent]      Appr
  ON AKS.ApprovalID = Appr.ID
  WHERE CSI.IsActive=1 AND Appr.IsActive=1

UNION ALL

SELECT CSI.[ID]
      ,CSI.[ItemVerKit]
      ,CSI.[ItemOrKitId]
      ,CSI.[ItemOrKitUnitOfMeasureId]
      ,CSI.[ItemOrKitQuantity]
      ,CSI.[ItemOrKitQuality]
      ,CSI.[ItemOrKitFree]
      ,CSI.[ItemOrKitUnConsilliation]
      ,CSI.[ItemOrKitReserved]
      ,CSI.[ItemOrKitReleasedForExpedition]
      ,CSI.[ItemOrKitExpedited]
      ,CSI.[StockId]
      ,CSI.[IsActive]
      ,CSI.[ModifyDate]
      ,CSI.[ModifyUserId]
      ,-1      IDsource
      ,-1      CMSOId
      ,0       R1ItemQuantity
      ,0       RF1ItemOrKitQuantity
      ,0       S1ItemOrKitQuantity
      ,0       S0ItemOrKitQuantity
      ,0       S0ItemOrKitQuantityReal
      ,0       K1KitQuantity
      ,0       ApprKitQuantity
      ,KitReserved.zKitu_Reserved 
      ,0       S1zKitu
      ,''      ItemOrKitIDzKitu
      ,0       Reconciliation
      ,0       KitQuantityK0
      ,0       KitQuantityDeliveredK0

  FROM [dbo].[CardStockItems]     CSI
  INNER JOIN (SELECT  cKI.ItemOrKitId ,cKI.[ItemOrKitQuantity], KSI.KitQualityId
                     ,cKI.[ItemOrKitQuantity]*KSI.[KitQuantity]-ISNULL([KitQuantityDelivered],0) zKitu_Reserved
              FROM [dbo].[CommunicationMessagesKittingsSentItems]           KSI
              INNER JOIN [dbo].[CommunicationMessagesKittingsSent]          KS
                 ON KSI.[CMSOId] = KS.ID
              INNER JOIN [dbo].[cdlKitsItems]                               cKI
                 ON KSI.KitId = cKI.cdlKitsId
              WHERE KSI.[KitQuantity]-ISNULL([KitQuantityDelivered],0) > 0 AND KSI.IsActive=1 AND KS.IsActive=1)   KitReserved
   ON CSI.[ItemOrKitId] = KitReserved.ItemOrKitId AND CSI.ItemOrKitQuality=KitReserved.KitQualityId
  WHERE CSI.IsActive=1

UNION ALL


SELECT CSI.[ID]
      ,CSI.[ItemVerKit]
      ,CSI.[ItemOrKitId]
      ,CSI.[ItemOrKitUnitOfMeasureId]
      ,CSI.[ItemOrKitQuantity]
      ,CSI.[ItemOrKitQuality]
      ,CSI.[ItemOrKitFree]
      ,CSI.[ItemOrKitUnConsilliation]
      ,CSI.[ItemOrKitReserved]
      ,CSI.[ItemOrKitReleasedForExpedition]
      ,CSI.[ItemOrKitExpedited]
      ,CSI.[StockId]
      ,CSI.[IsActive]
      ,CSI.[ModifyDate]
      ,CSI.[ModifyUserId]
      ,x.ID  IDsource
      ,x.CMSOId CMSOId
      ,0       R1ItemQuantity
      ,0       RF1ItemOrKitQuantity
      ,0       S1ItemOrKitQuantity
      ,0       S0ItemOrKitQuantity
      ,0       S0ItemOrKitQuantityReal
      ,0       K1KitQuantity
      ,0       ApprKitQuantity
      ,0       zKitu_Reserved
      ,x.RealItemOrKitQuantity       S1zKitu
      ,x.cKIIItemOrKitId                 ItemOrKitIDzKitu
      ,0       Reconciliation
      ,0       KitQuantityK0
      ,0       KitQuantityDeliveredK0

  FROM [dbo].[CardStockItems]     CSI
  INNER JOIN (SELECT SOCI.*,cKII.ItemOrKitId cKIIItemOrKitId FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems] SOCI
              INNER JOIN CommunicationMessagesShipmentOrdersConfirmation RC
                  ON SOCI.CMSOId = RC.ID AND RC.IsActive=1 AND SOCI.ItemVerKit=1
              INNER JOIN [dbo].[cdlKits]   cKI
                  ON SOCI.ItemOrKitID = cKI.ID AND SOCI.ItemOrKitQualityId=cKI.KitQualitiesId
              INNER JOIN [dbo].[cdlKitsItems]   cKII
                  ON cKII.cdlKitsId = cKI.ID 
              WHERE RC.IsActive=1  ) x
  ON CSI.ItemOrKitID = x.ItemOrKitId AND CSI.ItemOrKitQuality=x.ItemOrKitQualityId
  WHERE CSI.IsActive=1

  UNION ALL

  SELECT CSI.[ID]
      ,CSI.[ItemVerKit]
      ,CSI.[ItemOrKitId]
      ,CSI.[ItemOrKitUnitOfMeasureId]
      ,CSI.[ItemOrKitQuantity]
      ,CSI.[ItemOrKitQuality]
      ,CSI.[ItemOrKitFree]
      ,CSI.[ItemOrKitUnConsilliation]
      ,CSI.[ItemOrKitReserved]
      ,CSI.[ItemOrKitReleasedForExpedition]
      ,CSI.[ItemOrKitExpedited]
      ,CSI.[StockId]
      ,CSI.[IsActive]
      ,CSI.[ModifyDate]
      ,CSI.[ModifyUserId]
      ,KitI.ID  IDsource
      ,KitI.CMSOId CMSOId
      ,0       R1ItemQuantity
      ,0       RF1ItemOrKitQuantity
      ,0       S1ItemOrKitQuantity
      ,0       S0ItemOrKitQuantity
      ,0       S0ItemOrKitQuantityReal
      ,0       K1KitQuantity
      ,0       ApprKitQuantity
      ,0       zKitu_Reserved
      ,0       S1zKitu
      ,0       ItemOrKitIDzKitu
      ,ISNULL(KitC.Reconciliation,0)       Reconciliation
      ,KitI.KitQuantity  KitQuantityK0
      ,KitI.KitQuantityDelivered KitQuantityDeliveredK0
  FROM [dbo].[CardStockItems]     CSI
  INNER JOIN [dbo].[CommunicationMessagesKittingsSentItems]  KitI
     ON CSI.[ItemOrKitId] = KitI.KitId AND CSI.ItemOrKitQuality=KitI.KitQualityId
INNER JOIN [dbo].[CommunicationMessagesKittingsSent]  KitH
     ON KitI.CMSOId = KitH.ID
LEFT OUTER JOIN [dbo].[CommunicationMessagesKittingsConfirmation]  KitC
    ON KitH.ID= KitC.KitOrderID
  WHERE CSI.IsActive=1 AND KitH.IsActive=1 AND KitI.IsActive=1

















