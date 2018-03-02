
CREATE VIEW [dbo].[vwCheckDuplicityCodeS1]
AS
/*
Weczerek
30.03.2015


Kontroluje, zda v jedné S1 není x krát stejný materiál => byl by pak i v S0

*/
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


