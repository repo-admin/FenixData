CREATE VIEW [dbo].[vwCMKSent]
AS
-- ===============================================================================================================================================
-- Description  : zobrazuje Přehled objednávek kitů
-- Created by   : Weczerek Max
-- Created date : 
-- Edited date  : 2014-08-05  M. Weczerek
--									2014-09-18  M. Weczerek
--                2015-03-11  M. Rezler .. přidány sloupce: RealCompletationDate, KitQuantity, KitQuantityDelivered, KitID, ModelCPE
--                2015-10-23  M. Rezler
-- ===============================================================================================================================================
SELECT CMKS.[ID]
      ,CMKS.[MessageId]
      ,CMKS.[MessageType]     MessageTypeID
      ,CMKS.[MessageDescription]
      ,CMKS.[MessageDateOfShipment]
      ,CMKS.[MessageStatusId]
      ,CMKS.[KitDateOfDelivery]
      ,CMKS.[StockId]
      ,CMKS.[IsActive]
      ,CMKS.[ModifyDate]
      ,CMKS.[ModifyUserId]
      ,cSt.[Name] AS CompanyName
      ,cS.DescriptionCz
      ,cS.Code
      ,CMKSI.HeliosOrderID
      ,ISNULL(CMKC.[Reconciliation], -1)  Reconciliation
			,kittConf2.MessageDateOfReceipt AS RealCompletationDate
			,CMKSI2.KitQuantity
			,CMKSI2.KitQuantityDelivered
			,cKits.[ID] AS KitID
			,cKits.[Code] AS ModelCPE
  FROM [dbo].[CommunicationMessagesKittingsSent]	CMKS
  INNER JOIN [dbo].[cdlStocks]										cSt
      ON CMKS.[StockId] = cSt.Id
  INNER JOIN [dbo].[cdlStatuses]									cS
      ON CMKS.[MessageStatusId] = cS.Id
  LEFT OUTER JOIN (SELECT DISTINCT[HeliosOrderID],[CMSOId]  FROM [dbo].[CommunicationMessagesKittingsSentItems])  CMKSI
      ON CMKS.ID=CMKSI.CMSOId
  LEFT OUTER JOIN (SELECT DISTINCT Reconciliation, [KitOrderID] FROM [dbo].[CommunicationMessagesKittingsConfirmation] WHERE [Reconciliation] = 2) CMKC
			ON CMKS.Id = CMKC.KitOrderID
	LEFT OUTER JOIN (SELECT * FROM [dbo].[CommunicationMessagesKittingsConfirmation] WHERE [Reconciliation] IN (0, 1))  kittConf2  --2015-10-23
      ON CMKS.ID = kittConf2.KitOrderID
	LEFT OUTER JOIN (SELECT DISTINCT [KitId], [CMSOId], [KitQuantity], [KitQuantityDelivered] FROM [dbo].[CommunicationMessagesKittingsSentItems])  CMKSI2
			ON CMKS.ID = CMKSI2.CMSOId
	INNER JOIN [dbo].[cdlKits]											cKits
			ON CMKSI2.[KitId] = cKits.ID

