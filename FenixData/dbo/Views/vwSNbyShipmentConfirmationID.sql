
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[vwSNbyShipmentConfirmationID]
AS
/*
2015-08-25

*/
SELECT S.*
FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmation]        C
INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems]     CI
  ON C.ID = CI.CMSOId
INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmationSerNumSent]   S
  ON CI.ID = S.ShipmentOrdersItemsOrKitsID

-- WHERE C.ID=2041  -- sem se zapisuje ID confirmace shipmentu
