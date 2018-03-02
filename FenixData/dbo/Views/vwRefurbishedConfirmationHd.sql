
CREATE VIEW [dbo].[vwRefurbishedConfirmationHd]
  AS
/*
-- ====================================================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-09-25
--                2014-10-03, 2015-10-21
-- Description  : zobrazuje shipment Confirmation + hlavicka z tabulky [dbo].[CommunicationMessagesShipmentOrdersSent]
-- Edited       : 2015-10-21 M.Rezler rozšíření ReconciliationYesNo
--              : 2015-10-27 M.Rezler ReconciliationYesNo určováno voláním funkce
-- ====================================================================================================================
*/
SELECT CMRC.[ID]
      ,CMRC.[MessageId]
      ,CMRC.[MessageTypeId]
      ,CMRC.[MessageDescription]
      ,CMRC.[DateOfShipment]
      ,CMRC.[RefurbishedOrderID]
      ,CMRC.[CustomerID]
      ,CMRC.[Reconciliation]
      ,(SELECT [dbo].[fnReconciliationDescriptionUpper](CMRC.[Reconciliation])) AS ReconciliationYesNo
				--,CASE CMRC.[Reconciliation]	--2015-10-27
				--WHEN 0 THEN '?'							--2015-10-27, 2015-10-21
				--WHEN 1 THEN 'SCHVÁLENO'			--2015-10-27 
				--WHEN 2 THEN 'ZAMÍTNUTO'			--2015-10-27 
				--WHEN 3 THEN 'D0 ODESLÁNA'		--2015-10-27, 2015-10-21
				--WHEN 4 THEN 'ZRUŠENO D1'			--2015-10-27, 2015-10-21
				--Else '?'											--2015-10-27, 2015-10-21
				--END ReconciliationYesNo			--2015-10-27 
      ,CMRC.[IsActive]
      ,CMRC.[ModifyDate]
      ,CMRC.[ModifyUserId]
      ,CMRS.MessageDateOfShipment
      ,CMRS.DateOfDelivery
      ,cDp.[CompanyName]
      ,cDp.City
  FROM [dbo].[CommunicationMessagesRefurbishedOrderConfirmation] CMRC
  INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrder]       CMRS 
      ON CMRC.RefurbishedOrderID = CMRS.Id
  INNER JOIN [dbo].[cdlDestinationPlaces]   cDp
      ON CMRC.[CustomerID] = cDp.ID
  WHERE CMRC.IsActive = 1 AND CMRS.IsActive = 1



