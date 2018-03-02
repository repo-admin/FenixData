CREATE PROCEDURE [dbo].[prCardStockMovementsKit] 
	@ItemOrKitId              int = -1, 
	@ItemOrKitUnitOfMeasureId int = -1, 
   @ItemOrKitQuality         int = -1
AS
BEGIN
	SET NOCOUNT ON;

IF OBJECT_ID('tempdb..#CardStockItemsSource','table') IS NOT NULL DROP TABLE #CardStockItemsSource
CREATE table #CardStockItemsSource
(
       ID                      INT NULL
      ,CMSOId                  INT NULL
      ,IDc                     INT NULL
      ,CMSOIdc                 INT NULL
      ,ItemVerKit              INT NULL
      ,ItemOrKitID             INT NULL
      ,ItemOrKitDescription    nchar(250) NULL
      ,S0ItemOrKitQuantity     INT NULL
      ,S1ItemOrKitQuantityReal INT NULL
      ,K0ItemOrKitQuantity     INT NULL
      ,K1ItemOrKitQuantityReal INT NULL
      ,RF0ItemOrKitQuantity    INT NULL
      ,RF1ItemOrKitQuantityReal INT NULL
      ,ItemOrKitUnitOfMeasure  nchar(250) NULL
      ,ItemOrKitQualityCode    nchar(250) NULL
      ,Reconciliation          INT NULL
 )





   -- Card status
SELECT [ID]
      ,[ItemVerKit]
      ,[ItemVerKitDescription]
      ,[ItemOrKitID]
      ,[DescriptionCz]
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
SELECT SOSI.[ID]
      ,SOSI.[CMSOId]
      ,SOC.ID IDc
      ,SOCI.CMSOId CMSOIdc
      ,SOSI.[ItemVerKit]
      ,SOSI.[ItemOrKitID]
      ,SOSI.[ItemOrKitDescription]
      ,SOSI.[ItemOrKitQuantity]        S0ItemOrKitQuantity
      ,SOSI.[ItemOrKitQuantityReal]    S1ItemOrKitQuantityReal
      ,0                               K0ItemOrKitQuantity
      ,0                               K1ItemOrKitQuantityReal
      ,0                               RF0ItemOrKitQuantity
      ,0                               RF1ItemOrKitQuantityReal
      ,SOSI.[ItemOrKitUnitOfMeasure]
      ,SOSI.[ItemOrKitQualityCode]
      ,ISNULL(SOC.Reconciliation,0) Reconciliation
  FROM [dbo].[CommunicationMessagesShipmentOrdersSentItems]     SOSI
  INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersSent]    SOS
     ON SOSI.[CMSOId] = SOS.ID
  LEFT OUTER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmation]  SOC
     ON SOS.ID = SOC.ShipmentOrderID
  LEFT OUTER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems] SOCI
     ON SOC.ID = SOCI.CMSOId
  WHERE SOSI.[IsActive] = 1 AND SOS.[IsActive] = 1
    AND SOC.IsActive=1 AND SOCI.IsActive=1 AND SOSI.[ItemOrKitID] = @ItemOrKitId AND SOCI.[ItemOrKitID] = @ItemOrKitId
    AND     
    SOSI.[ItemOrKitUnitOfMeasureId]  = @ItemOrKitUnitOfMeasureId 
    AND
    SOSI.[ItemOrKitQualityId]          = @ItemOrKitQuality 

UNION ALL

SELECT KSI.[ID]
      ,KSI.[CMSOId]
      ,KC.ID IDc
      ,KCI.CMSOId CMSOIdc
      ,1                           ItemVerKit
      ,KSI.[KitId]                 ItemOrKitID
      ,KSI.[KitDescription]        ItemOrKitDescription
      , 0                          S0ItemOrKitQuantity
      , 0                          S1ItemOrKitQuantityReal
      ,KSI.[KitQuantity]           K0ItemOrKitQuantity
      ,KSI.[KitQuantityDelivered]  K1ItemOrKitQuantityReal
      ,0                           RF0ItemOrKitQuantity
      ,0                           RF1ItemOrKitQuantityReal
      ,KSI.[KitUnitOfMeasure]      ItemOrKitUnitOfMeasure
      ,KSI.[KitQualityCode]        ItemOrKitQualityCode
      ,ISNULL(KC.Reconciliation,0) Reconciliation
  FROM [dbo].[CommunicationMessagesKittingsSentItems]    KSI
  INNER JOIN [dbo].[CommunicationMessagesKittingsSent]   KS
     ON KSI.CMSOId = KS.ID
  LEFT OUTER JOIN [dbo].[CommunicationMessagesKittingsConfirmation] KC
     ON KS.ID =   KC.KitOrderID
  LEFT OUTER JOIN [dbo].[CommunicationMessagesKittingsConfirmationItems]  KCI
     ON KC.ID = KCI.CMSOId
  WHERE KSI.IsActive=1 AND KS.IsActive=1 AND KC.IsActive=1 AND KCI.IsActive=1 AND KSI.[KitId] = @ItemOrKitId  AND KCI.[KitId] = @ItemOrKitId
    AND     
    KSI.[MeasuresID]            = @ItemOrKitUnitOfMeasureId 
    AND
    KSI.[KitQualityId]          = @ItemOrKitQuality 

UNION ALL

SELECT ROI.[ID]
      ,ROI.[CMSOId]
      ,ROC.ID IDc
      ,ROCI.CMSOId CMSOIdc
      ,ROI.[ItemVerKit]
      ,ROI.[ItemOrKitID]
      ,ROI.[ItemOrKitDescription]
      , 0                          S0ItemOrKitQuantity
      , 0                          S1ItemOrKitQuantityReal
      , 0                          K0ItemOrKitQuantity
      , 0                          K1ItemOrKitQuantityReal
      ,ROI.[ItemOrKitQuantity]          RF0ItemOrKitQuantity
      ,ROI.[ItemOrKitQuantityDelivered] RF1ItemOrKitQuantityReal
      ,ROI.[ItemOrKitUnitOfMeasure]
      ,ROI.[ItemOrKitQualityCode]
      ,ROC.Reconciliation
  FROM [dbo].[CommunicationMessagesRefurbishedOrderItems]           ROI
  INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrder]          RO
      ON ROI.CMSOId= RO.ID
  LEFT OUTER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmation]  ROC
     ON  RO.ID = ROC.[RefurbishedOrderID]
  LEFT OUTER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems]  ROCI
     ON  ROC.ID = ROCI.CMSOId
  WHERE ROI.[ItemVerKit] = 1 AND ROI.IsActive = 1 AND RO.IsActive = 1 AND ROC.IsActive = 1  AND ROI.[ItemOrKitID] = @ItemOrKitId  AND ROCI.[ItemOrKitID] = @ItemOrKitId
    AND     
    ROI.[ItemOrKitUnitOfMeasureId]  = @ItemOrKitUnitOfMeasureId 
    AND
    ROI.[ItemOrKitQualityId]        = @ItemOrKitQuality 

) detail

SELECT * FROM #CardStockItemsSource
--
SELECT 'Bez zamítnutých'
      ,SUM(ISNULL(K0ItemOrKitQuantity,0))      sumaK0ItemOrKitQuantity
      ,SUM(ISNULL(K1ItemOrKitQuantityReal,0))  sumaK1ItemQuantity
      ,SUM(ISNULL(RF0ItemOrKitQuantity,0))     sumaRF0ItemOrKitQuantity        
      ,SUM(ISNULL(RF1ItemOrKitQuantityReal,0)) sumaRF1ItemOrKitQuantity   
      ,SUM(ISNULL(S0ItemOrKitQuantity,0))      sumaS0ItemOrKitQuantity    
      ,SUM(ISNULL(S1ItemOrKitQuantityReal,0))  sumaS0ItemOrKitQuantityReal
FROM #CardStockItemsSource WHERE Reconciliation<>2
SELECT 'Jen odsouhlasené'
      ,SUM(ISNULL(K0ItemOrKitQuantity,0))      sumaK0ItemOrKitQuantity
      ,SUM(ISNULL(K1ItemOrKitQuantityReal,0))  sumaK1ItemQuantity
      ,SUM(ISNULL(RF0ItemOrKitQuantity,0))     sumaRF0ItemOrKitQuantity        
      ,SUM(ISNULL(RF1ItemOrKitQuantityReal,0)) sumaRF1ItemOrKitQuantity   
      ,SUM(ISNULL(S0ItemOrKitQuantity,0))      sumaS0ItemOrKitQuantity    
      ,SUM(ISNULL(S1ItemOrKitQuantityReal,0))  sumaS0ItemOrKitQuantityReal
FROM #CardStockItemsSource WHERE Reconciliation=1
SELECT 'Jen neodsouhlasené'
      ,SUM(ISNULL(K0ItemOrKitQuantity,0))      sumaK0ItemOrKitQuantity
      ,SUM(ISNULL(K1ItemOrKitQuantityReal,0))  sumaK1ItemQuantity
      ,SUM(ISNULL(RF0ItemOrKitQuantity,0))     sumaRF0ItemOrKitQuantity        
      ,SUM(ISNULL(RF1ItemOrKitQuantityReal,0)) sumaRF1ItemOrKitQuantity   
      ,SUM(ISNULL(S0ItemOrKitQuantity,0))      sumaS0ItemOrKitQuantity    
      ,SUM(ISNULL(S1ItemOrKitQuantityReal,0))  sumaS0ItemOrKitQuantityReal
FROM #CardStockItemsSource WHERE Reconciliation=2 


SELECT SUM(ISNULL(K1ItemOrKitQuantityReal,0))+SUM(ISNULL(RF1ItemOrKitQuantityReal,0)) PRIJEMreal
FROM #CardStockItemsSource WHERE Reconciliation=1
SELECT SUM(ISNULL(K0ItemOrKitQuantity,0))+SUM(ISNULL(RF0ItemOrKitQuantity,0)) PRIJEMobjednano
FROM #CardStockItemsSource WHERE Reconciliation<>2

--SELECT ' ', SUM(S0ItemOrKitQuantity)-SUM(S1ItemOrKitQuantity)+SUM(KitQuantityK0)-SUM(KitQuantityDeliveredK1) [Rezervováno]
--          ,SUM(R1ItemQuantity)+ SUM(RF1ItemOrKitQuantity)      [Přijato]
--          ,(SUM(R1ItemQuantity)+ SUM(RF1ItemOrKitQuantity))-(SUM(S0ItemOrKitQuantity)-SUM(S1ItemOrKitQuantity)+SUM(KitQuantityK0)-SUM(KitQuantityDeliveredK1)) -SUM(S1ItemOrKitQuantity) -SUM(KitQuantityDeliveredK1) [Volné]
--FROM #CardStockItemsSource WHERE Reconciliation<>2 

END



