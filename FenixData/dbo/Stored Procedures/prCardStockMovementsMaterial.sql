-- =============================================================
-- Author:		  Weczerek Max
-- Create date:  2015-03-03
-- Description:	zobrazuje pohyby (příjmy, výdaje na kartě)
-- jeste budu testovat a upravovat   2015-03-03
-- =============================================================
CREATE PROCEDURE [dbo].[prCardStockMovementsMaterial] 
	@ItemOrKitId              int = -1, 
	@ItemOrKitUnitOfMeasureId int = -1, 
   @ItemOrKitQuality  int = -1
AS
BEGIN
	SET NOCOUNT ON;

IF OBJECT_ID('tempdb..#CardStockItemsSource','table') IS NOT NULL DROP TABLE #CardStockItemsSource
CREATE table #CardStockItemsSource
(
       IDsource                INT NULL
      ,CMSOId                  INT NULL
      ,R1ItemQuantity          INT NULL
      ,RF1ItemOrKitQuantity    INT NULL
      ,S1ItemOrKitQuantity     INT NULL
      ,S0ItemOrKitQuantity     INT NULL
      ,S0ItemOrKitQuantityReal INT NULL
      ,K1KitQuantity           INT NULL
      ,ApprKitQuantity         INT NULL
      ,zKitu_Reserved          INT NULL
      ,S1zKitu                 INT NULL
      ,ItemOrKitIDzKitu        INT NULL
      ,Reconciliation          INT NULL
      ,KitQuantityK0           INT NULL
      ,KitQuantityDeliveredK1  INT NULL
      ,ModifyDate              DateTime NULL  -- 2015-04-09
      ,Ident                   VARCHAR (50)
 )

   -- Card status
SELECT [ID]
      ,[ItemVerKit]
      ,[ItemVerKitDescription]
      ,[ItemOrKitID]
      ,[DescriptionCz]
      ,ItemOrKitQuantity
      ,[ItemOrKitUnitOfMeasureId]
      ,[MeasuresCode]
      ,[ItemOrKitQuality]
      ,[QualitiesCode]
      --,[ItemOrKitFree]
      ,[ItemOrKitFreeInteger]                   [Volné]
      --,[ItemOrKitUnConsilliation]
      ,[ItemOrKitUnConsilliationInteger]        [Ke schválení]
      --,[ItemOrKitReserved]
      ,[ItemOrKitReservedInteger]               [Rezervováno]
      --,[ItemOrKitReleasedForExpedition]
      ,[ItemOrKitReleasedForExpeditionInteger]  [Uvolněno]
      --,[ItemOrKitExpedited]
      ,[ItemOrKitExpeditedInteger]              [Expedováno]
      ,[ItemType]

  FROM [dbo].[vwCardStockItems] 
  WHERE ItemOrKitId               = @ItemOrKitId    
        AND     
        ItemOrKitUnitOfMeasureId  = @ItemOrKitUnitOfMeasureId 
        AND
        ItemOrKitQuality          = @ItemOrKitQuality 
        AND
        [IsActive] = 1

   --  Detail 

INSERT INTO #CardStockItemsSource
SELECT * FROM
(
SELECT 
       RCI.ID  IDsource
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
      ,0       KitQuantityDeliveredK1
      ,RCI.ModifyDate
      ,'Reception' yy
  FROM [dbo].[CardStockItems]     CSI
  LEFT OUTER JOIN [dbo].[CommunicationMessagesReceptionConfirmationItems] RCI
     ON CSI.[ItemOrKitId] = RCI.[ItemID] AND CSI.ItemOrKitQuality=RCI.ItemQualityId
  INNER JOIN CommunicationMessagesReceptionConfirmation RC
     ON RCI.CMSOId = RC.ID
  WHERE RC.IsActive=1 
        AND 
        RCI.IsActive=1
        AND
        CSI.ItemOrKitId               = @ItemOrKitId    
        AND     
        CSI.ItemOrKitUnitOfMeasureId  = @ItemOrKitUnitOfMeasureId 
        AND
        CSI.ItemOrKitQuality          = @ItemOrKitQuality 
        AND
        CSI.IsActive=1
        AND 
        RCI.ModifyDate>'20131231'

UNION ALL

SELECT ROCI.ID  IDsource
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
      ,0       KitQuantityDeliveredK1
      ,ROCI.ModifyDate
      ,'Refurbished' yy
  FROM [dbo].[CardStockItems]     CSI
  LEFT OUTER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems]  ROCI
    ON CSI.[ItemOrKitId] = ROCI.[ItemOrKitID] AND CSI.ItemOrKitQuality=ROCI.ItemOrKitQualityId
  INNER JOIN CommunicationMessagesRefurbishedOrderConfirmation RC
    ON ROCI.CMSOId = RC.ID
  WHERE RC.IsActive=1 
        AND 
        ROCI.IsActive=1
        AND
        CSI.ItemOrKitId               = @ItemOrKitId    
        AND     
        CSI.ItemOrKitUnitOfMeasureId  = @ItemOrKitUnitOfMeasureId 
        AND
        CSI.ItemOrKitQuality          = @ItemOrKitQuality 
        AND
        CSI.IsActive=1
        AND 
        ROCI.ModifyDate>'20131231'


UNION ALL

SELECT SOCI.ID  IDsource
      ,SOCI.CMSOId CMSOId
      ,0       R1ItemQuantity
      ,0       RF1ItemOrKitQuantity
      ,SOCI.RealItemOrKitQuantity    S1ItemOrKitQuantity
      ,0       S0ItemOrKitQuantity
      ,0       S0ItemOrKitQuantityReal
      ,0       K1KitQuantity
      ,0       ApprKitQuantity
      ,0       zKitu_Reserved
      ,0       S1zKitu
      ,''      ItemOrKitIDzKitu
      ,RC.Reconciliation       Reconciliation
      ,0       KitQuantityK0
      ,0       KitQuantityDeliveredK1
      ,SOCI.ModifyDate
      ,'ShipmentConfirmace' yy
  FROM [dbo].[CardStockItems]     CSI
  LEFT OUTER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems] SOCI
     ON CSI.[ItemOrKitId] = SOCI.[ItemOrKitID] AND CSI.ItemOrKitQuality=SOCI.ItemOrKitQualityId
  INNER JOIN CommunicationMessagesShipmentOrdersConfirmation RC
     ON SOCI.CMSOId = RC.ID
  WHERE RC.IsActive=1 
        AND 
        SOCI.IsActive=1
        AND
        CSI.ItemOrKitId               = @ItemOrKitId    
        AND     
        CSI.ItemOrKitUnitOfMeasureId  = @ItemOrKitUnitOfMeasureId 
        AND
        CSI.ItemOrKitQuality          = @ItemOrKitQuality 
        AND
        CSI.IsActive=1
                AND 
        SOCI.ModifyDate>'20131231'

UNION ALL

SELECT SOCI.ID  IDsource
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
      ,0       KitQuantityDeliveredK1
      ,SOCI.ModifyDate
      ,'ShipmentOrders' yy
  FROM [dbo].[CardStockItems]     CSI
  LEFT OUTER JOIN [dbo].[CommunicationMessagesShipmentOrdersSentItems] SOCI
     ON CSI.[ItemOrKitId] = SOCI.[ItemOrKitID] AND CSI.ItemOrKitQuality=SOCI.ItemOrKitQualityId
  INNER JOIN CommunicationMessagesShipmentOrdersSent RS
     ON SOCI.CMSOId = RS.ID
  LEFT OUTER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmation]   SOC
     ON RS.ID = SOC.ShipmentOrderID
  WHERE RS.IsActive=1 
        AND 
        SOCI.IsActive=1
        AND
        CSI.ItemOrKitId               = @ItemOrKitId    
        AND     
        CSI.ItemOrKitUnitOfMeasureId  = @ItemOrKitUnitOfMeasureId 
        AND
        CSI.ItemOrKitQuality          = @ItemOrKitQuality 
        AND
        CSI.IsActive=1
        AND 
        SOCI.ModifyDate>'20131231'

    UNION ALL


SELECT KCI.ID  IDsource
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
      ,0       KitQuantityDeliveredK1
      ,KCI.ModifyDate
      ,'KittingsConfirmation' yy
  FROM [dbo].[CardStockItems]     CSI
  LEFT OUTER JOIN [dbo].[CommunicationMessagesKittingsConfirmationItems] KCI
    ON CSI.[ItemOrKitId] = KCI.KitID  AND CSI.ItemOrKitQuality=KCI.KitQualityId
  INNER JOIN CommunicationMessagesKittingsConfirmation RC
    ON KCI.CMSOId = RC.ID
  WHERE RC.IsActive=1 
        AND 
        CSI.ItemVerKit = 1
        AND 
        KCI.IsActive=1
        AND
        CSI.ItemOrKitId               = @ItemOrKitId    
        AND     
        CSI.ItemOrKitUnitOfMeasureId  = @ItemOrKitUnitOfMeasureId 
        AND
        CSI.ItemOrKitQuality          = @ItemOrKitQuality 
        AND
        CSI.IsActive=1
        AND 
        KCI.ModifyDate>'20131231'


 UNION ALL

SELECT AKS.ID  IDsource
      ,-1      CMSOId
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
      ,0       KitQuantityDeliveredK1
      ,AKS.ModifyDate
      ,'KittingsApproval' yy
  FROM [dbo].[CardStockItems]     CSI
  LEFT OUTER JOIN [dbo].[CommunicationMessagesKittingsApprovalKitsSent] AKS
      ON CSI.[ItemOrKitId] = AKS.[KitID] AND CSI.ItemOrKitQuality=AKS.KitQualityId
  INNER JOIN [dbo].[CommunicationMessagesKittingsApprovalKitsSent]      Appr
      ON AKS.ApprovalID = Appr.ID
  WHERE AKS.IsActive=1 
        AND 
        Appr.IsActive=1
        AND
        CSI.ItemOrKitId               = @ItemOrKitId    
        AND     
        CSI.ItemOrKitUnitOfMeasureId  = @ItemOrKitUnitOfMeasureId 
        AND
        CSI.ItemOrKitQuality          = @ItemOrKitQuality 
        AND
        CSI.IsActive=1
                AND 
        AKS.ModifyDate>'20131231'


UNION ALL

SELECT -1      IDsource
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
      ,0       KitQuantityDeliveredK1
      ,KitReserved.ModifyDate
      ,'KitReserved-KSI' yy
  FROM [dbo].[CardStockItems]     CSI
  INNER JOIN (SELECT  cKI.ItemOrKitId ,cKI.[ItemOrKitQuantity], KSI.KitQualityId
                     ,cKI.[ItemOrKitQuantity]*KSI.[KitQuantity]-ISNULL([KitQuantityDelivered],0) zKitu_Reserved, KSI.ModifyDate
              FROM [dbo].[CommunicationMessagesKittingsSentItems]           KSI
              INNER JOIN [dbo].[CommunicationMessagesKittingsSent]          KS
                 ON KSI.[CMSOId] = KS.ID
              INNER JOIN [dbo].[cdlKitsItems]                               cKI
                 ON KSI.KitId = cKI.cdlKitsId
              WHERE KSI.[KitQuantity]-ISNULL([KitQuantityDelivered],0) > 0 AND KSI.IsActive=1 AND KS.IsActive=1)   KitReserved
   ON CSI.[ItemOrKitId] = KitReserved.ItemOrKitId AND CSI.ItemOrKitQuality=KitReserved.KitQualityId
  WHERE 
        CSI.ItemOrKitId               = @ItemOrKitId    
        AND     
        CSI.ItemOrKitUnitOfMeasureId  = @ItemOrKitUnitOfMeasureId 
        AND
        CSI.ItemOrKitQuality          = @ItemOrKitQuality 
        AND
        CSI.IsActive=1
        AND 
        KitReserved.ModifyDate>'20131231'


UNION ALL


SELECT 
       x.ID  IDsource
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
      ,0       KitQuantityDeliveredK1
      ,x.ModifyDate
      ,'x ShipmentOrdersConfirmation' yy
  FROM [dbo].[CardStockItems]     CSI
  INNER JOIN (SELECT SOCI.*,cKII.ItemOrKitId cKIIItemOrKitId FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems] SOCI
              INNER JOIN CommunicationMessagesShipmentOrdersConfirmation RC
                  ON SOCI.CMSOId = RC.ID
              INNER JOIN [dbo].[cdlKits]   cKI
                  ON SOCI.ItemOrKitID = cKI.ID AND SOCI.ItemOrKitQualityId=cKI.KitQualitiesId
              INNER JOIN [dbo].[cdlKitsItems]   cKII
                  ON cKII.cdlKitsId = cKI.ID 
              WHERE RC.IsActive=1  AND RC.IsActive=1 AND SOCI.ItemVerKit=1          ) x
  ON CSI.ItemOrKitID = x.ItemOrKitId AND CSI.ItemOrKitQuality=x.ItemOrKitQualityId
  WHERE 
        CSI.ItemOrKitId               = @ItemOrKitId    
        AND     
        CSI.ItemOrKitUnitOfMeasureId  = @ItemOrKitUnitOfMeasureId 
        AND
        CSI.ItemOrKitQuality          = @ItemOrKitQuality 
        AND
        CSI.IsActive=1
        AND 
        x.ModifyDate>'20131231'



  UNION ALL

 SELECT 
       T.ID  IDsource
      ,T.CMSOId CMSOId
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
      ,ISNULL(H.Reconciliation,0)       Reconciliation
      ,TS.KitQuantity                   KitQuantityK0
      ,T.KitQuantity                    KitQuantityDeliveredK1
      ,TS.ModifyDate
      ,'TS KittingsSent' yy
FROM [dbo].[CardStockItems]        CSI
INNER JOIN [dbo].[cdlKitsItems]    cdlKI
     ON CSI.ItemOrKitID = cdlKI.ItemOrKitId
INNER JOIN [dbo].[cdlKits]         cdlK
     ON cdlKI.cdlKitsId = cdlK.ID
INNER JOIN [dbo].[CommunicationMessagesKittingsConfirmationItems]   T
    ON T.KitID = cdlK.ID
INNER JOIN [dbo].[CommunicationMessagesKittingsConfirmation]  H
      ON T.CMSOId = H.ID
INNER JOIN [dbo].[CommunicationMessagesKittingsSent]  HS
ON H.KitOrderID  = HS.ID
INNER JOIN [dbo].[CommunicationMessagesKittingsSentItems] TS
ON HS.ID = TS.CMSOId
WHERE  
        T.[IsActive] = 1
        AND H.[IsActive] = 1
        AND HS.[IsActive] = 1
        AND H.Reconciliation<>2
        AND TS.[IsActive] = 1
        AND
        CSI.ItemOrKitId               = @ItemOrKitId    
        AND     
        CSI.ItemOrKitUnitOfMeasureId  = @ItemOrKitUnitOfMeasureId 
        AND
        CSI.ItemOrKitQuality          = @ItemOrKitQuality 
        AND
        CSI.IsActive=1
        AND 
        T.ModifyDate>'20131231'

--  SELECT 
--       KitI.ID  IDsource
--      ,KitI.CMSOId CMSOId
--      ,0       R1ItemQuantity
--      ,0       RF1ItemOrKitQuantity
--      ,0       S1ItemOrKitQuantity
--      ,0       S0ItemOrKitQuantity
--      ,0       S0ItemOrKitQuantityReal
--      ,0       K1KitQuantity
--      ,0       ApprKitQuantity
--      ,0       zKitu_Reserved
--      ,0       S1zKitu
--      ,0       ItemOrKitIDzKitu
--      ,ISNULL(KitC.Reconciliation,0)       Reconciliation
--      ,KitI.KitQuantity  KitQuantityK0
--      ,KitI.KitQuantityDelivered KitQuantityDeliveredK0
--  FROM [dbo].[CardStockItems]     CSI
--  INNER JOIN [dbo].[CommunicationMessagesKittingsSentItems]  KitI
--     ON CSI.[ItemOrKitId] = KitI.KitId AND CSI.ItemOrKitQuality=KitI.KitQualityId
--INNER JOIN [dbo].[CommunicationMessagesKittingsSent]  KitH
--     ON KitI.CMSOId = KitH.ID
--LEFT OUTER JOIN [dbo].[CommunicationMessagesKittingsConfirmation]  KitC
--    ON KitH.ID= KitC.KitOrderID
--  WHERE KitH.IsActive=1 AND KitI.IsActive=1
--        AND
--        CSI.ItemOrKitId               = @ItemOrKitId    
--        AND     
--        CSI.ItemOrKitUnitOfMeasureId  = @ItemOrKitUnitOfMeasureId 
--        AND
--        CSI.ItemOrKitQuality          = @ItemOrKitQuality 
--        AND
--        CSI.IsActive=1
) detail ORDER BY CONVERT(CHAR(8),ModifyDate,112)

SELECT * FROM #CardStockItemsSource ORDER BY CONVERT(CHAR(8), ModifyDate,112)
--
SELECT 'Bez zamítnutých  <>2'
      ,SUM(R1ItemQuantity          )  sumaR1ItemQuantity         
      ,SUM(RF1ItemOrKitQuantity    )  sumaRF1ItemOrKitQuantity   
      ,SUM(S1ItemOrKitQuantity     )  [Expedováno]    
      ,SUM(S0ItemOrKitQuantity     )  sumaS0ItemOrKitQuantity    
      ,SUM(ISNULL(S0ItemOrKitQuantityReal,0) )  sumaS0ItemOrKitQuantityReal
      ,SUM(K1KitQuantity           )  sumaK1KitQuantity          
      ,SUM(ApprKitQuantity         )  sumaApprKitQuantity        
      ,SUM(zKitu_Reserved          )  sumazKitu_Reserved         
      ,SUM(S1zKitu                 )  sumaS1zKitu                
      ,SUM(ItemOrKitIDzKitu        )  sumaItemOrKitIDzKitu       
      ,0  sumaReconciliation         
      ,SUM(KitQuantityK0           )  sumaKitQuantityK0          
      ,SUM(KitQuantityDeliveredK1  )  sumaKitQuantityDeliveredK1 
FROM #CardStockItemsSource WHERE Reconciliation<>2 AND ModifyDate>'20131231'
SELECT 'Jen odsouhlasené =1'
      ,SUM(R1ItemQuantity          )  sumaR1ItemQuantity         
      ,SUM(RF1ItemOrKitQuantity    )  sumaRF1ItemOrKitQuantity   
      ,SUM(S1ItemOrKitQuantity     )  [Expedováno]    
      ,SUM(S0ItemOrKitQuantity     )  sumaS0ItemOrKitQuantity    
      ,SUM(ISNULL(S0ItemOrKitQuantityReal,0) )  sumaS0ItemOrKitQuantityReal
      ,SUM(K1KitQuantity           )  sumaK1KitQuantity          
      ,SUM(ApprKitQuantity         )  sumaApprKitQuantity        
      ,SUM(zKitu_Reserved          )  sumazKitu_Reserved         
      ,SUM(S1zKitu                 )  sumaS1zKitu                
      ,SUM(ItemOrKitIDzKitu        )  sumaItemOrKitIDzKitu       
      ,0          sumaReconciliation         
      ,SUM(KitQuantityK0           )  sumaKitQuantityK0          
      ,SUM(KitQuantityDeliveredK1  )  sumaKitQuantityDeliveredK1 
FROM #CardStockItemsSource WHERE Reconciliation=1 AND ModifyDate>'20131231'
SELECT 'Jen neodsouhlasené  =0'
      ,SUM(R1ItemQuantity          )  sumaR1ItemQuantity         
      ,SUM(RF1ItemOrKitQuantity    )  sumaRF1ItemOrKitQuantity   
      ,SUM(S1ItemOrKitQuantity     )  [Expedováno]    
      ,SUM(S0ItemOrKitQuantity     )  sumaS0ItemOrKitQuantity    
      ,SUM(ISNULL(S0ItemOrKitQuantityReal,0) )  sumaS0ItemOrKitQuantityReal
      ,SUM(K1KitQuantity           )  sumaK1KitQuantity          
      ,SUM(ApprKitQuantity         )  sumaApprKitQuantity        
      ,SUM(zKitu_Reserved          )  sumazKitu_Reserved         
      ,SUM(S1zKitu                 )  sumaS1zKitu                
      ,SUM(ItemOrKitIDzKitu        )  sumaItemOrKitIDzKitu       
      ,0  sumaReconciliation         
      ,SUM(KitQuantityK0           )  sumaKitQuantityK0          
      ,SUM(KitQuantityDeliveredK1  )  sumaKitQuantityDeliveredK1 
FROM #CardStockItemsSource WHERE Reconciliation=0  AND ModifyDate>'20131231'


SELECT ' ', SUM(S0ItemOrKitQuantity)-SUM(S1ItemOrKitQuantity)+SUM(KitQuantityK0)-SUM(KitQuantityDeliveredK1) [Rezervováno]
          ,SUM(R1ItemQuantity)+ SUM(RF1ItemOrKitQuantity)      [Přijato]
          ,(SUM(R1ItemQuantity)+ SUM(RF1ItemOrKitQuantity))-(SUM(S0ItemOrKitQuantity)-SUM(S1ItemOrKitQuantity)+SUM(KitQuantityK0)-SUM(KitQuantityDeliveredK1)) -SUM(S1ItemOrKitQuantity) -SUM(KitQuantityDeliveredK1) [Volné]
FROM #CardStockItemsSource WHERE Reconciliation<>2  AND ModifyDate>'20131231'


SELECT * FROM [dbo].[A_CardStockItems]  
WHERE [ItemOrKitId] = @ItemOrKitId AND ItemOrKitQuality = @ItemOrKitQuality AND A_ModifyDate>'20131231'
ORDER BY CONVERT(CHAR(8), A_ModifyDate,112)
--
END


