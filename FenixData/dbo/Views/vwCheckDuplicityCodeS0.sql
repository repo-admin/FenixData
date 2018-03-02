

CREATE VIEW [dbo].[vwCheckDuplicityCodeS0]
AS
/*
Weczerek
20.04.2015

View zobrazuje ve výdejkách ty výdejky, u kterých se vyskytuje jeden materiál ve více řádcích
To má za následek, že se vytvoří 2 resp více stejných řádků v S0, soubor S1 se navrátí správně, ale zobrazení při schvalování S1 je špatné
a i zápis do dodaného zboží u S0 je "nějaký" --> VŽDY JE TĚBA ZKONTROLOVAT !!

*/


SELECT bb.*, SOSI.ID SOSIID, SOSI.[ItemOrKitQuantity],SOSI.[ItemOrKitQuantityReal] FROM
(
SELECT * FROM
(
  SELECT 
  COUNT(*) Pocet,
  [CMSOId], [SingleOrMaster], [ItemVerKit], [ItemOrKitID], [ItemOrKitUnitOfMeasureId], [RealItemOrKitQualityId]
  FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems]
  WHERE IsActive = 1 
  GROUP BY [CMSOId], [SingleOrMaster], [ItemVerKit], [ItemOrKitID], [ItemOrKitUnitOfMeasureId], [RealItemOrKitQualityId]
)  aa
WHERE Pocet>1

) bb
INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmation]        SOCH
    ON bb.CMSOId = SOCH.id
INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersSentItems]           SOSI
    ON SOCH.ShipmentOrderID = SOSI.CMSOId
WHERE bb.[SingleOrMaster]   = SOSI.[SingleOrMaster] AND 
      bb.[ItemVerKit]       = SOSI.[ItemVerKit] AND 
      bb.[ItemOrKitID]      = SOSI.[ItemOrKitID] AND  
      bb.[ItemOrKitUnitOfMeasureId] = SOSI.[ItemOrKitUnitOfMeasureId] AND  
      bb.[RealItemOrKitQualityId]   = SOSI.[ItemOrKitQualityId] 
      AND
      SOSI.[ItemOrKitQuantity] <> SOSI.[ItemOrKitQuantityReal]





