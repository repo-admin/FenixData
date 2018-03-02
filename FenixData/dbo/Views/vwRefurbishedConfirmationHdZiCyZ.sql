

CREATE VIEW [dbo].[vwRefurbishedConfirmationHdZiCyZ]
  AS
/*
-- ====================================================================================================================
-- Created by   : Weczerek Max
-- Created date : 2016-05-25
--                
-- Description  : zobrazuje shipment Confirmation + hlavicka z tabulky [dbo].[CommunicationMessagesShipmentOrdersSent]
-- Edited       : 
--              : 
-- Notice       : musí se nejprve odzkoušet; zatím se v aplikaci nepoužívá    2016-05-25
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
      ,CMRC.[IsActive]
      ,CMRC.[ModifyDate]
      ,CMRC.[ModifyUserId]
      ,CMRS.MessageDateOfShipment
      ,CMRS.DateOfDelivery
      ,cDp.[CompanyName]
      ,cDp.City
      ,zc.FULL_NAME
  FROM [dbo].[CommunicationMessagesRefurbishedOrderConfirmation] CMRC
  INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrder]       CMRS 
      ON CMRC.RefurbishedOrderID = CMRS.Id
  INNER JOIN [dbo].[cdlDestinationPlaces]       cDp
      ON CMRC.[CustomerID] = cDp.ID
  LEFT OUTER JOIN ZiCyZ.[dbo].[VW_EMPLOYEES]    zc
      ON CMRC.ModifyUserId = zc.ZC_ID

  WHERE CMRC.IsActive = 1 AND CMRS.IsActive = 1




