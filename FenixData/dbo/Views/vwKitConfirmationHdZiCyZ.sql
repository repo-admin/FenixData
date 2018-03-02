

CREATE VIEW [dbo].[vwKitConfirmationHdZiCyZ]
AS
  /*
-- ==========================================================================================================
-- Description  : zobrazuje Kit Confirmation + hlavicka z tabulky [dbo].[CommunicationMessagesKitSent]
-- Created by   : Weczerek Max
-- Created date : 2014-08-12
-- Edited date  : 2015-03-13 M. Rezler .. přidány sloupce: OrderedKitQuantity, DeliveredKitQuantity, ModelCPE
--              : 2015-10-23 M. Rezler .. rozšíření ReconciliationText 
--              : 2015-10-29 M. Rezler .. ReconciliationText určováno voláním funkce
--
-- Notice       : musí se nejprve odzkoušet; zatím se v aplikaci nepoužívá    2016-05-25
-- ==========================================================================================================
  */
SELECT CMRC.[ID]
      ,CMRC.[MessageId]
      ,CMRC.[MessageTypeId]
      ,CMRC.[MessageDescription]
      ,CMRC.[MessageDateOfReceipt]
      ,CMRC.[KitOrderID]
      ,CMRC.[Reconciliation]
		,(SELECT [dbo].[fnReconciliationDescriptionUpper](CMRC.[Reconciliation])) AS ReconciliationText
    --,CASE CMRC.[Reconciliation]	      --2015-10-29 
		--WHEN 0 THEN '?'							--2015-10-29, 2015-10-23
		--WHEN 1 THEN 'SCHVÁLENO'			   --2015-10-29
      --WHEN 2 THEN 'ZAMÍTNUTO'			   --2015-10-29
		--WHEN 3 THEN 'D0 ODESLÁNA'		   --2015-10-29, 2015-10-23
      --Else '?'								   --2015-10-29, 2015-10-23
    --END ReconciliationText
      ,CMRS.MessageDateOfShipment
      ,CMRS.KitDateOfDelivery
      ,COALESCE(CAST(CMKSI.HeliosOrderID AS VARCHAR(50)),'') AS HeliosObj
      ,CMRC.IsActive
      ,CMRS.Notice
      ,CMRS.HeliosOrderId 
		,CMKSI2.[KitQuantity] AS OrderedKitQuantity				/* objednane mnozstvi */
		,CMRCI.[KitQuantity]  AS DeliveredKitQuantity			/* sestavene/dodane mnozstvi */
		,cKits.[Code]         AS ModelCPE  
      ,zc.FULL_NAME
  FROM [dbo].[CommunicationMessagesKittingsConfirmation]   CMRC
  INNER JOIN [dbo].[CommunicationMessagesKittingsSent]     CMRS 
      ON CMRC.KitOrderID = CMRS.Id
  LEFT OUTER JOIN (SELECT DISTINCT[HeliosOrderID],[CMSOId]  FROM [dbo].[CommunicationMessagesKittingsSentItems])					CMKSI
      ON CMRS.ID=CMKSI.CMSOId	
	LEFT OUTER JOIN (SELECT [KitQuantity], [CMSOId] FROM [dbo].[CommunicationMessagesKittingsConfirmationItems])				   CMRCI
			ON CMRC.ID = CMRCI.CMSOId
	LEFT OUTER JOIN (SELECT DISTINCT [KitId], [CMSOId], [KitQuantity] FROM [dbo].[CommunicationMessagesKittingsSentItems])     CMKSI2
			ON CMRS.ID = CMKSI2.CMSOId
	INNER JOIN [dbo].[cdlKits]											cKits
			ON CMKSI2.[KitId] = cKits.ID
  LEFT OUTER JOIN ZiCyZ.[dbo].[VW_EMPLOYEES]    zc
      ON CMRC.ModifyUserId = zc.ZC_ID
  WHERE CMRC.IsActive = 1 AND CMRS.IsActive = 1 


